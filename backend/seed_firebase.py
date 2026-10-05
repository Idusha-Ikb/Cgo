#!/usr/bin/env python3
"""
Seed Cloud Firestore Database via REST API directly for project: track-sl
"""
import urllib.request
import json
import ssl

PROJECT_ID = "track-sl"
BASE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents"

containers = [
    {
        "id": "CONT-001",
        "owner": "Cargo Overseas Freight Pvt Ltd",
        "route": "Colombo Port - Orugodawatta, Avissawella RD",
        "currentLocation": "Orugodawatta, Colombo, Sri Lanka",
        "destination": "Orugodawatta Logistics Terminal",
        "estimatedArrival": "12 Sep 2026, 10.00 AM",
        "driverName": "S.A. Gamage",
        "sealStatus": "Intact",
        "batteryLevel": 75,
        "status": "On Track",
        "latitude": 6.9455,
        "longitude": 79.8510,
        "speed": 42
    },
    {
        "id": "CONT-002",
        "owner": "Cargo Overseas Freight Pvt Ltd",
        "route": "Colombo port - 911 Sirimavo Bandaranaike Mawatha, Colombo",
        "currentLocation": "Colombo port - 911 Sirimavo Bandaranaike Mawatha, Colombo",
        "destination": "911 Sirimavo Bandaranaike Mawatha, Colombo",
        "estimatedArrival": "12 Sep 2026, 11.30 AM",
        "driverName": "K.D. Kumara",
        "sealStatus": "Intact",
        "batteryLevel": 20,
        "status": "On Track",
        "latitude": 6.9410,
        "longitude": 79.8525,
        "speed": 35
    },
    {
        "id": "CONT-003",
        "owner": "Cargo Overseas Freight Pvt Ltd",
        "route": "Colombo port - 911 Sirimavo Bandaranaike Mawatha, Colombo",
        "currentLocation": "Colombo Port Yard 02",
        "destination": "911 Sirimavo Bandaranaike Mawatha, Colombo",
        "estimatedArrival": "10 Sep 2026, 02.00 PM",
        "driverName": "R.M. Perera",
        "sealStatus": "Intact",
        "batteryLevel": 92,
        "status": "Arrived",
        "latitude": 6.9380,
        "longitude": 79.8820,
        "speed": 0
    }
]

alerts = [
    {
        "title": "Low Battery Warning on CONT-002 (20%)",
        "containerId": "CONT-002",
        "category": "Battery",
        "timestamp": "12 Sep 2026, 08:30 AM"
    },
    {
        "title": "Ingurukade Checkpoint Cleared for CONT-001",
        "containerId": "CONT-001",
        "category": "Location",
        "timestamp": "12 Sep 2026, 07:38 AM"
    }
]

def seed_containers():
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    print(f"[*] Seeding containers to Firestore project: {PROJECT_ID}...")
    for c in containers:
        doc_id = c["id"]
        url = f"{BASE_URL}/containers/{doc_id}"

        fields = {}
        for k, v in c.items():
            if isinstance(v, int):
                fields[k] = {"integerValue": str(v)}
            elif isinstance(v, float):
                fields[k] = {"doubleValue": v}
            else:
                fields[k] = {"stringValue": str(v)}

        body = json.dumps({"fields": fields}).encode("utf-8")
        req = urllib.request.Request(url, data=body, method="PATCH", headers={"Content-Type": "application/json"})

        try:
            with urllib.request.urlopen(req, context=ctx) as resp:
                print(f" [+] Successfully created container: {doc_id} (HTTP {resp.status})")
        except Exception as e:
            print(f" [-] Failed to create container {doc_id}: {e}")

    print("\n[*] Seeding sample alerts...")
    for a in alerts:
        url = f"{BASE_URL}/alerts"
        fields = {}
        for k, v in a.items():
            fields[k] = {"stringValue": str(v)}
        body = json.dumps({"fields": fields}).encode("utf-8")
        req = urllib.request.Request(url, data=body, method="POST", headers={"Content-Type": "application/json"})
        try:
            with urllib.request.urlopen(req, context=ctx) as resp:
                print(f" [+] Successfully created alert (HTTP {resp.status})")
        except Exception as e:
            print(f" [-] Failed to create alert: {e}")

    print("\n[SUCCESS] Firestore Seeding Complete! Refresh Firebase Console to view containers.")

if __name__ == "__main__":
    seed_containers()
