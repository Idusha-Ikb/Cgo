#!/usr/bin/env python3
"""
SecureTrack SL - Real SQLite Database & REST API Server
An IoT-Based Real-Time Container Monitoring & Anti-Theft Framework for Sri Lanka Customs

Database: SQLite 3 (Auto-created as 'securetrack.db')
Tables:
  - users
  - containers
  - alerts
  - company_profile

Endpoints:
  - POST /api/auth/login
  - POST /api/auth/register
  - GET  /api/containers
  - GET  /api/containers/<id>
  - GET  /api/alerts
  - GET  /api/telemetry/<id>
  - GET  /api/profile
  - POST /api/profile
  - POST /api/iot/telemetry (Simulates ESP32/SIM800L module packet)
"""

import json
import os
import sqlite3
import sys
import time
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs

PORT = 8000
DB_FILE = os.path.join(os.path.dirname(__file__), "securetrack.db")

def get_db_connection():
    """Create and return a SQLite database connection with row factory."""
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    return conn

def init_database():
    """Initialize database schema and seed initial SRS data if empty."""
    conn = get_db_connection()
    cursor = conn.cursor()

    # 1. Users Table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT,
        role TEXT NOT NULL,
        company TEXT,
        company_id TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """)

    # 2. Containers Table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS containers (
        id TEXT PRIMARY KEY,
        owner TEXT NOT NULL,
        route TEXT NOT NULL,
        current_location TEXT NOT NULL,
        destination TEXT NOT NULL,
        estimated_arrival TEXT NOT NULL,
        driver_name TEXT NOT NULL,
        seal_status TEXT NOT NULL,
        battery_level INTEGER NOT NULL,
        status TEXT NOT NULL,
        container_color TEXT NOT NULL,
        type TEXT,
        weight TEXT,
        hardware_id TEXT,
        latitude REAL,
        longitude REAL,
        speed_kmh INTEGER DEFAULT 0
    );
    """)

    # 3. Alerts Table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS alerts (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        container_id TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        category TEXT NOT NULL,
        severity TEXT NOT NULL,
        description TEXT
    );
    """)

    # 4. Company Profile Table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS company_profile (
        company_id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        active_count INTEGER DEFAULT 12,
        delivered_count INTEGER DEFAULT 48,
        total_count INTEGER DEFAULT 60,
        alerts_count INTEGER DEFAULT 2
    );
    """)

    # Seed the optional demo user only when a password is configured.
    owner_password = os.environ.get("SECURETRACK_OWNER_PASSWORD")
    cursor.execute("SELECT COUNT(*) as count FROM users;")
    if cursor.fetchone()["count"] == 0 and owner_password:
        cursor.execute("""
        INSERT INTO users (id, name, email, password, phone, role, company, company_id)
        VALUES ('USR-001', 'Tharindu Perera', 'owner@cargooverseas.lk', ?, '+94 77 123 4567', 'Owner', 'Cargo Overseas Freight Pvt Ltd', 'COMP-COF-2024');
        """, (owner_password,))

    # Seed Containers from SRS Document
    cursor.execute("SELECT COUNT(*) as count FROM containers;")
    if cursor.fetchone()["count"] == 0:
        cursor.executemany("""
        INSERT INTO containers (id, owner, route, current_location, destination, estimated_arrival, driver_name, seal_status, battery_level, status, container_color, type, weight, hardware_id, latitude, longitude, speed_kmh)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """, [
            ('CONT-001', 'Cargo Overseas Freight Pvt Ltd', 'Colombo Port - Orugodawatta, Avissawella RD', 'Orugodawatta , Colombo, Sri Lanka', 'Orugodawatta , Colombo, Sri Lanka', '12 Sep 2026 , 10.00 AM', 'S.A. Gamage', 'Infact', 75, 'On Track', '0xFF10B981', '40ft High Cube', '18,500 kg', 'ESP32-SIM800L-001', 6.9380, 79.8820, 42),
            ('CONT-002', 'Cargo Overseas Freight Pvt Ltd', 'Colombo port - 911 Sirimavo Bandaranaike Mawatha, Colombo', 'Colombo port - 911 Sirimavo Bandaranaike Mawatha, Colombo', '911 Sirimavo Bandaranaike Mawatha, Colombo', '12 Sep 2026 , 11.30 AM', 'K.D. Kumara', 'Infact', 20, 'On Track', '0xFFD97706', '20ft Standard', '12,200 kg', 'ESP32-SIM800L-002', 6.9450, 79.8650, 35),
            ('CONT-003', 'Cargo Overseas Freight Pvt Ltd', 'Colombo port - 911 Sirimavo Bandaranaike Mawatha, Colombo', 'Colombo Port Yard 02', '911 Sirimavo Bandaranaike Mawatha, Colombo', '10 Sep 2026 , 02.00 PM', 'R.M. Perera', 'Infact', 92, 'Arrived', '0xFF2563EB', '40ft Refrigerated', '22,000 kg', 'ESP32-SIM800L-003', 6.9500, 79.8550, 0)
        ])

    # Seed Alerts from SRS Document
    cursor.execute("SELECT COUNT(*) as count FROM alerts;")
    if cursor.fetchone()["count"] == 0:
        cursor.executemany("""
        INSERT INTO alerts (id, title, container_id, timestamp, category, severity, description)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """, [
            ('1', 'Route Deviation Alerts', 'CONT-003', '10 Sep 2026 , 14.32', 'Location', 'high', 'Container deviated 2.1 km from approved customs transit corridor.'),
            ('2', 'Low Bettery', 'CONT-002', '09 Sep 2026 , 18.15', 'Bettery', 'warning', 'IoT module battery dropped to 20%. Please schedule charging at next checkpoint.'),
            ('3', 'Seal Opened', 'CONT-001', '08 Sep 2026 , 09.22', 'Security', 'info', 'Smart electronic seal unlocked successfully by authorized customs inspector.'),
            ('4', 'ETA Updated', 'CONT-002', '07 Sep 2026 , 16.32', 'Location', 'info', 'ETA dynamically recalculated based on live road traffic to 11.30 AM.'),
            ('5', 'Location Update', 'CONT-001', '07 Sep 2026 , 12.32', 'Location', 'info', 'Container passed Colombo Fort checkpoint. Signal telemetry verified.')
        ])

    # Seed Company Profile
    cursor.execute("SELECT COUNT(*) as count FROM company_profile;")
    if cursor.fetchone()["count"] == 0:
        cursor.execute("""
        INSERT INTO company_profile (company_id, name, email, phone, address, active_count, delivered_count, total_count, alerts_count)
        VALUES ('COMP-COF-2024', 'Cargo Overseas Freight Pvt Ltd', 'contact@cargooverseas.lk', '+94 11 234 5678', 'No. 45, Harbour View Commercial Center, Colombo 01', 12, 48, 60, 2);
        """)

    conn.commit()
    conn.close()
    print(f"[Database] SQLite database initialized successfully at: {DB_FILE}")

class RequestHandler(BaseHTTPRequestHandler):
    def _send_cors_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')

    def do_OPTIONS(self):
        self.send_response(200)
        self._send_cors_headers()
        self.end_headers()

    def _send_json(self, data, status_code=200):
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/json')
        self._send_cors_headers()
        self.end_headers()
        self.wfile.write(json.dumps(data, indent=2).encode('utf-8'))

    def _read_json_body(self):
        content_length = int(self.headers.get('Content-Length', 0))
        if content_length > 0:
            body = self.rfile.read(content_length)
            try:
                return json.loads(body.decode('utf-8'))
            except Exception:
                return {}
        return {}

    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path.rstrip('/')
        query = parse_qs(parsed.query)

        # Health / Root
        if path == "" or path == "/api" or path == "/api/health":
            self._send_json({
                "status": "online",
                "system": "SecureTrack SL Backend API",
                "database": "SQLite 3 (securetrack.db)",
                "version": "1.0.0",
                "timestamp": time.strftime('%Y-%m-%d %H:%M:%S')
            })
            return

        conn = get_db_connection()
        cursor = conn.cursor()

        # GET /api/containers
        if path == "/api/containers":
            cursor.execute("SELECT * FROM containers ORDER BY id ASC;")
            rows = [dict(row) for row in cursor.fetchall()]
            conn.close()
            self._send_json({"success": True, "data": rows})
            return

        # GET /api/containers/<id>
        if path.startswith("/api/containers/"):
            container_id = path.split("/")[-1].upper()
            cursor.execute("SELECT * FROM containers WHERE UPPER(id) = ?;", (container_id,))
            row = cursor.fetchone()
            conn.close()
            if row:
                self._send_json({"success": True, "data": dict(row)})
            else:
                self._send_json({"success": False, "error": "Container not found"}, 404)
            return

        # GET /api/alerts
        if path == "/api/alerts":
            category = query.get('category', [None])[0]
            if category and category.lower() != 'all':
                cursor.execute("SELECT * FROM alerts WHERE LOWER(category) = ? ORDER BY id ASC;", (category.lower(),))
            else:
                cursor.execute("SELECT * FROM alerts ORDER BY id ASC;")
            rows = [dict(row) for row in cursor.fetchall()]
            conn.close()
            self._send_json({"success": True, "data": rows})
            return

        # GET /api/telemetry/<id>
        if path.startswith("/api/telemetry/"):
            container_id = path.split("/")[-1].upper()
            cursor.execute("SELECT * FROM containers WHERE UPPER(id) = ?;", (container_id,))
            row = cursor.fetchone()
            conn.close()
            if row:
                d = dict(row)
                telemetry = {
                    "container_id": d["id"],
                    "latitude": d["latitude"],
                    "longitude": d["longitude"],
                    "speed_kmh": d["speed_kmh"],
                    "seal_status": d["seal_status"],
                    "battery_level": d["battery_level"],
                    "signal_strength": "4G LTE (Strong)",
                    "last_updated": time.strftime('%Y-%m-%d %H:%M:%S')
                }
                self._send_json({"success": True, "data": telemetry})
            else:
                self._send_json({"success": False, "error": "Container not found"}, 404)
            return

        # GET /api/profile
        if path == "/api/profile":
            cursor.execute("SELECT * FROM company_profile LIMIT 1;")
            row = cursor.fetchone()
            conn.close()
            if row:
                d = dict(row)
                formatted = {
                    "company_id": d["company_id"],
                    "name": d["name"],
                    "email": d["email"],
                    "phone": d["phone"],
                    "address": d["address"],
                    "stats": {
                        "active": d["active_count"],
                        "delivered": d["delivered_count"],
                        "total": d["total_count"],
                        "alerts": d["alerts_count"]
                    }
                }
                self._send_json({"success": True, "data": formatted})
            else:
                self._send_json({"success": False, "error": "Profile not found"}, 404)
            return

        conn.close()
        self._send_json({"success": False, "error": "Not Found"}, 404)

    def do_POST(self):
        parsed = urlparse(self.path)
        path = parsed.path.rstrip('/')
        body = self._read_json_body()

        conn = get_db_connection()
        cursor = conn.cursor()

        # POST /api/auth/login
        if path == "/api/auth/login":
            email = body.get('email', '').strip().lower()
            password = body.get('password', '')

            cursor.execute("SELECT * FROM users WHERE LOWER(email) = ?;", (email,))
            user = cursor.fetchone()

            if user and user["password"] == password:
                u = dict(user)
                conn.close()
                self._send_json({
                    "success": True,
                    "token": f"jwt_{u['id']}_{int(time.time())}",
                    "user": {
                        "id": u["id"],
                        "name": u["name"],
                        "email": u["email"],
                        "role": u["role"],
                        "company": u["company"]
                    }
                })
            else:
                conn.close()
                self._send_json({
                    "success": False,
                    "error": "Access Denied: Unregistered email or invalid password. Please register first."
                }, 401)
            return

        # POST /api/auth/register
        if path == "/api/auth/register":
            name = body.get('name', 'New User')
            email = body.get('email', '').strip().lower()
            phone = body.get('phone', '')
            role = body.get('role', 'Owner')
            password = body.get('password', '')
            if not password:
                conn.close()
                self._send_json({"success": False, "error": "Password is required"}, 400)
                return

            cursor.execute("SELECT COUNT(*) as count FROM users;")
            new_id = f"USR-{cursor.fetchone()['count'] + 1:03d}"

            try:
                cursor.execute("""
                INSERT INTO users (id, name, email, password, phone, role, company, company_id)
                VALUES (?, ?, ?, ?, ?, ?, 'Cargo Overseas Freight Pvt Ltd', 'COMP-COF-2024');
                """, (new_id, name, email, password, phone, role))
                conn.commit()
                conn.close()
                self._send_json({
                    "success": True,
                    "message": "User registered in SQLite database",
                    "user": {
                        "id": new_id,
                        "name": name,
                        "email": email,
                        "phone": phone,
                        "role": role
                    }
                })
            except Exception as e:
                conn.close()
                self._send_json({"success": False, "error": f"Registration error: {str(e)}"}, 400)
            return

        # POST /api/profile
        if path == "/api/profile":
            name = body.get("name")
            email = body.get("email")
            phone = body.get("phone")
            address = body.get("address")

            cursor.execute("""
            UPDATE company_profile
            SET name = COALESCE(?, name),
                email = COALESCE(?, email),
                phone = COALESCE(?, phone),
                address = COALESCE(?, address)
            WHERE company_id = 'COMP-COF-2024';
            """, (name, email, phone, address))
            conn.commit()

            cursor.execute("SELECT * FROM company_profile LIMIT 1;")
            updated = dict(cursor.fetchone())
            conn.close()
            self._send_json({"success": True, "data": updated})
            return

        # POST /api/iot/telemetry
        if path == "/api/iot/telemetry":
            cid = body.get("container_id", "CONT-001").upper()
            cursor.execute("SELECT * FROM containers WHERE UPPER(id) = ?;", (cid,))
            found = cursor.fetchone()

            if found:
                lat = body.get("latitude", found["latitude"])
                lng = body.get("longitude", found["longitude"])
                speed = body.get("speed_kmh", found["speed_kmh"])
                seal = body.get("seal_status", found["seal_status"])
                battery = body.get("battery_level", found["battery_level"])

                cursor.execute("""
                UPDATE containers
                SET latitude = ?, longitude = ?, speed_kmh = ?, seal_status = ?, battery_level = ?
                WHERE UPPER(id) = ?;
                """, (lat, lng, speed, seal, battery, cid))

                # If tamper breach alert triggered
                if body.get("tamper_alert", False):
                    cursor.execute("SELECT COUNT(*) as count FROM alerts;")
                    alert_id = str(cursor.fetchone()["count"] + 1)
                    now_ts = time.strftime('%d %b %Y , %H.%M')
                    cursor.execute("""
                    INSERT INTO alerts (id, title, container_id, timestamp, category, severity, description)
                    VALUES (?, 'Tamper Breach Detected', ?, ?, 'Security', 'critical', 'Magnetic reed sensor broken in transit.');
                    """, (alert_id, cid, now_ts))

                conn.commit()
                cursor.execute("SELECT * FROM containers WHERE UPPER(id) = ?;", (cid,))
                updated_container = dict(cursor.fetchone())
                conn.close()
                self._send_json({"success": True, "message": "Telemetry updated in SQLite DB", "data": updated_container})
            else:
                conn.close()
                self._send_json({"success": False, "error": "Container not found"}, 404)
            return

        conn.close()
        self._send_json({"success": False, "error": "Endpoint not found"}, 404)

def run():
    init_database()
    server_address = ('0.0.0.0', PORT)
    httpd = HTTPServer(server_address, RequestHandler)
    print(f"==================================================")
    print(f"  SecureTrack SL - Real SQLite Database REST API")
    print(f"  Database File: {DB_FILE}")
    print(f"  Running on: http://localhost:{PORT}")
    print(f"  Android Emulator URL: http://10.0.2.2:{PORT}")
    print(f"==================================================")
    print(f"SQL Tables Active:")
    print(f"  - users, containers, alerts, company_profile")
    print(f"==================================================")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nStopping server...")
        httpd.server_close()

if __name__ == '__main__':
    run()
