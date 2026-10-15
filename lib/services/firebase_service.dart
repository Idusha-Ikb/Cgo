import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../models/shipment_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Consistent vehicle details across the entire application
  static const String defaultVehicleNo = 'WP-DA-4821';
  static const String defaultDriverName = 'Saman Kumara';
  static const String defaultLicenseNo = 'B8392014';
  static const String defaultCompany = 'Customs Bonded Carrier Ltd';
  static const String defaultPhone = '+94 77 123 4567';

  /// Complete Sri Lanka Customs Shipments Dataset with multiple examples for ALL categories
  static List<ShipmentModel> get allCustomsShipments => [
        // ACTIVE
        ShipmentModel(
          id: 'shp_001',
          shipmentId: 'SHP-2026-001',
          containerId: 'CONT-001',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Colombo Port',
          destination: 'Orugodawatta Main Yard',
          status: 'Active',
          assignedRoute: 'Colombo Port - Orugodawatta Main Yard',
          sealNumber: 'SL-CUS-884912',
          iotDeviceId: 'ESP32-ST-0042',
          type: 'Standard 40ft High Cube',
          weight: '24,500 kg',
          cargoDescription: 'Industrial Electronics & Telecommunication Units',
          eta: 'Today, 4:30 PM',
          distance: '12 km',
          estimatedTime: '1h 15m',
          startLatitude: 6.94,
          startLongitude: 79.85,
          endLatitude: 6.9450,
          endLongitude: 79.8800,
          waypoints: const [
            LatLng(6.9380, 79.8650),
            LatLng(6.9420, 79.8720),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ShipmentModel(
          id: 'shp_006',
          shipmentId: 'SHP-2026-006',
          containerId: 'CONT-006',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Colombo Port (SAGT Terminal)',
          destination: 'Kelaniya Inland Container Depot',
          status: 'Active',
          assignedRoute: 'Kandy Road (A1) Transit Corridor',
          sealNumber: 'SL-CUS-884920',
          iotDeviceId: 'ESP32-ST-0048',
          type: 'Standard 20ft Dry Box',
          weight: '16,800 kg',
          cargoDescription: 'Automotive Spare Parts & Heavy Engines',
          eta: 'Today, 5:15 PM',
          distance: '9.8 km',
          estimatedTime: '50 mins',
          startLatitude: 6.9400,
          startLongitude: 79.8500,
          endLatitude: 6.9550,
          endLongitude: 79.9150,
          waypoints: const [
            LatLng(6.9450, 79.8750),
            LatLng(6.9500, 79.8950),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        ShipmentModel(
          id: 'shp_007',
          shipmentId: 'SHP-2026-007',
          containerId: 'CONT-007',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Colombo Port (CICT Terminal)',
          destination: 'Wattala Customs Bonded Yard',
          status: 'Active',
          assignedRoute: 'Negombo Road (A3) Transit Corridor',
          sealNumber: 'SL-CUS-884925',
          iotDeviceId: 'ESP32-ST-0056',
          type: '40ft Refrigerated (Reefer)',
          weight: '22,400 kg',
          cargoDescription: 'Frozen Seafood & Cold-Chain Goods',
          eta: 'Today, 6:00 PM',
          distance: '11.2 km',
          estimatedTime: '1h 00m',
          startLatitude: 6.9400,
          startLongitude: 79.8500,
          endLatitude: 6.9850,
          endLongitude: 79.8900,
          waypoints: const [
            LatLng(6.9550, 79.8650),
            LatLng(6.9700, 79.8800),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
        ShipmentModel(
          id: 'shp_008',
          shipmentId: 'SHP-2026-008',
          containerId: 'CONT-008',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Grayline I Yard',
          destination: 'Colombo Port (Terminal 2)',
          status: 'Active',
          assignedRoute: 'Colombo - Grayline I Yard',
          sealNumber: 'SL-CUS-884931',
          iotDeviceId: 'ESP32-ST-0062',
          type: 'Standard 40ft High Cube',
          weight: '19,200 kg',
          cargoDescription: 'Electronic High-Tech Sensors & Components',
          eta: 'Today, 5:45 PM',
          distance: '34.5 km',
          estimatedTime: '55 mins',
          startLatitude: 7.1650,
          startLongitude: 79.8850,
          endLatitude: 6.9400,
          endLongitude: 79.8500,
          waypoints: const [
            LatLng(7.0800, 79.8780),
            LatLng(7.0000, 79.8700),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),

        // PENDING
        ShipmentModel(
          id: 'shp_002',
          shipmentId: 'SHP-2026-002',
          containerId: 'CONT-002',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Colombo Port (JCT)',
          destination: 'Peliyagoda Container Yard',
          status: 'Pending',
          assignedRoute: 'Port Access Highway - Peliyagoda Bypass',
          sealNumber: 'SL-CUS-884913',
          iotDeviceId: 'ESP32-ST-0045',
          type: 'Standard 20ft Dry Box',
          weight: '18,200 kg',
          cargoDescription: 'Imported Garment Raw Materials & Textiles',
          eta: 'Tomorrow, 09:30 AM',
          distance: '8.5 km',
          estimatedTime: '45 mins',
          startLatitude: 6.9400,
          startLongitude: 79.8500,
          endLatitude: 6.9690,
          endLongitude: 79.8880,
          waypoints: const [
            LatLng(6.9510, 79.8680),
            LatLng(6.9620, 79.8790),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        ShipmentModel(
          id: 'shp_003',
          shipmentId: 'SHP-2026-003',
          containerId: 'CONT-003',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Colombo Port (CICT)',
          destination: 'Biyagama Free Trade Zone',
          status: 'Pending',
          assignedRoute: 'Kelani Valley Corridor - Biyagama Link',
          sealNumber: 'SL-CUS-884914',
          iotDeviceId: 'ESP32-ST-0051',
          type: '40ft Refrigerated (Reefer)',
          weight: '21,000 kg',
          cargoDescription: 'Temperature-Controlled Essential Pharmaceuticals',
          eta: 'Tomorrow, 02:00 PM',
          distance: '22 km',
          estimatedTime: '1h 40m',
          startLatitude: 6.9400,
          startLongitude: 79.8500,
          endLatitude: 6.9444,
          endLongitude: 79.9912,
          waypoints: const [
            LatLng(6.9500, 79.8900),
            LatLng(6.9480, 79.9400),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        ShipmentModel(
          id: 'shp_009',
          shipmentId: 'SHP-2026-009',
          containerId: 'CONT-009',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Colombo Port (Terminal 1)',
          destination: 'Kerawalapitiya Logistics Hub',
          status: 'Pending',
          assignedRoute: 'Outer Circular Expressway (E02) Link',
          sealNumber: 'SL-CUS-884940',
          iotDeviceId: 'ESP32-ST-0071',
          type: 'Standard 40ft High Cube',
          weight: '26,300 kg',
          cargoDescription: 'Solar Power Panels & Inverter Batteries',
          eta: 'Tomorrow, 11:00 AM',
          distance: '16.5 km',
          estimatedTime: '1h 10m',
          startLatitude: 6.9400,
          startLongitude: 79.8500,
          endLatitude: 6.9920,
          endLongitude: 79.8820,
          waypoints: const [
            LatLng(6.9600, 79.8650),
            LatLng(6.9800, 79.8750),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        ShipmentModel(
          id: 'shp_010',
          shipmentId: 'SHP-2026-010',
          containerId: 'CONT-010',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Colombo Port (JCT)',
          destination: 'Kandy Pallekele Customs Bonded Depot',
          status: 'Pending',
          assignedRoute: 'Central Expressway (E04) - A1 Corridor',
          sealNumber: 'SL-CUS-884948',
          iotDeviceId: 'ESP32-ST-0080',
          type: 'Standard 40ft High Cube',
          weight: '23,100 kg',
          cargoDescription: 'Industrial Medical Equipment & Laboratory Gear',
          eta: 'Oct 13, 10:00 AM',
          distance: '118 km',
          estimatedTime: '3h 15m',
          startLatitude: 6.9400,
          startLongitude: 79.8500,
          endLatitude: 7.2800,
          endLongitude: 80.6800,
          waypoints: const [
            LatLng(7.0500, 80.0500),
            LatLng(7.1800, 80.3500),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(hours: 7)),
        ),

        // COMPLETED
        ShipmentModel(
          id: 'shp_004',
          shipmentId: 'SHP-2026-004',
          containerId: 'CONT-004',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Katunayake EPZ Cargo Center',
          destination: 'Colombo Port (Terminal 1)',
          status: 'Completed',
          assignedRoute: 'Colombo - Katunayake Expressway (E03)',
          sealNumber: 'SL-CUS-884910',
          iotDeviceId: 'ESP32-ST-0038',
          type: 'Standard 40ft High Cube',
          weight: '15,800 kg',
          cargoDescription: 'Apparel Exports - Inspected & Cleared',
          eta: 'Delivered (Yesterday)',
          distance: '34 km',
          estimatedTime: '55 mins',
          startLatitude: 7.1650,
          startLongitude: 79.8850,
          endLatitude: 6.9400,
          endLongitude: 79.8500,
          waypoints: const [
            LatLng(7.0800, 79.8780),
            LatLng(7.0000, 79.8700),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        ShipmentModel(
          id: 'shp_005',
          shipmentId: 'SHP-2026-005',
          containerId: 'CONT-005',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Colombo Port (SAGT)',
          destination: 'Hambantota International Port',
          status: 'Completed',
          assignedRoute: 'Southern Expressway (E01) Transit Corridor',
          sealNumber: 'SL-CUS-884908',
          iotDeviceId: 'ESP32-ST-0022',
          type: '40ft Heavy Duty Flat Rack',
          weight: '28,700 kg',
          cargoDescription: 'Heavy Industrial Harbour Maintenance Equipment',
          eta: 'Delivered (Oct 08)',
          distance: '240 km',
          estimatedTime: '3h 30m',
          startLatitude: 6.9400,
          startLongitude: 79.8500,
          endLatitude: 6.1200,
          endLongitude: 81.1200,
          waypoints: const [
            LatLng(6.5000, 80.0500),
            LatLng(6.1500, 80.5000),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        ShipmentModel(
          id: 'shp_011',
          shipmentId: 'SHP-2026-011',
          containerId: 'CONT-011',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Colombo Port (CICT)',
          destination: 'Seethawaka Export Processing Zone',
          status: 'Completed',
          assignedRoute: 'High-Level Road (A4) Transit Corridor',
          sealNumber: 'SL-CUS-884902',
          iotDeviceId: 'ESP32-ST-0019',
          type: 'Standard 20ft Dry Box',
          weight: '17,400 kg',
          cargoDescription: 'Precision Electronic Machinery Components',
          eta: 'Delivered (Oct 07)',
          distance: '52 km',
          estimatedTime: '1h 50m',
          startLatitude: 6.9400,
          startLongitude: 79.8500,
          endLatitude: 6.9500,
          endLongitude: 80.2100,
          waypoints: const [
            LatLng(6.9450, 79.9800),
            LatLng(6.9480, 80.1200),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        ShipmentModel(
          id: 'shp_012',
          shipmentId: 'SHP-2026-012',
          containerId: 'CONT-012',
          driverName: defaultDriverName,
          vehicleNo: defaultVehicleNo,
          origin: 'Trincomalee Harbour Depot',
          destination: 'Colombo Port (Terminal 2)',
          status: 'Completed',
          assignedRoute: 'A6 - Ambepussa Transit Corridor',
          sealNumber: 'SL-CUS-884895',
          iotDeviceId: 'ESP32-ST-0012',
          type: 'Standard 40ft High Cube',
          weight: '27,000 kg',
          cargoDescription: 'Export Refined Minerals & Industrial Silica',
          eta: 'Delivered (Oct 05)',
          distance: '260 km',
          estimatedTime: '5h 15m',
          startLatitude: 8.5700,
          startLongitude: 81.2300,
          endLatitude: 6.9400,
          endLongitude: 79.8500,
          waypoints: const [
            LatLng(8.0300, 80.7500),
            LatLng(7.5000, 80.3500),
          ],
          tamperStatus: 'Secure',
          geofenceStatus: 'Inside Corridor',
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ];

  /// Alerts Dataset
  static List<Map<String, dynamic>> get defaultCustomsAlerts => [
        {
          'id': 'alert_001',
          'title': 'Smart Seal Tamper Alert - CONT-001',
          'description': 'Dual-factor sensor trigger: Magnetic reed switch disengaged unexpectedly near Peliyagoda corridor.',
          'type': 'tamper',
          'priority': 'critical',
          'isRead': false,
          'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 12))),
        },
        {
          'id': 'alert_002',
          'title': 'Route Corridor Deviation Warning',
          'description': 'Vehicle $defaultVehicleNo deviated 280m outside approved Port-Orugodawatte geofence corridor.',
          'type': 'deviation',
          'priority': 'high',
          'isRead': false,
          'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 35))),
        },
        {
          'id': 'alert_003',
          'title': 'Customs Speed Threshold Exceeded',
          'description': 'Speed limit (60 km/h) exceeded on Kelani Bridge transit sector. Current: 68 km/h.',
          'type': 'instruction',
          'priority': 'important',
          'isRead': false,
          'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1, minutes: 15))),
        },
        {
          'id': 'alert_004',
          'title': 'New Container Assigned: CONT-001',
          'description': 'Inspector Bandara paired container CONT-001 with Smart Lock ESP32-ST-0042.',
          'type': 'shipment',
          'priority': 'normal',
          'isRead': true,
          'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2, minutes: 30))),
        },
        {
          'id': 'alert_005',
          'title': 'Customs Checkpoint Directive',
          'description': 'Mandatory security scan scheduled at Peliyagoda Gate 2 checkpoint before depot entry.',
          'type': 'instruction',
          'priority': 'important',
          'isRead': true,
          'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 3))),
        },
        {
          'id': 'alert_006',
          'title': 'Delivery Confirmed & Seal Disarmed',
          'description': 'Shipment SHP-2026-004 delivery logged and RFID seal unlocked by Inspector Wickrama.',
          'type': 'completed',
          'priority': 'normal',
          'isRead': true,
          'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
        },
      ];

  /// Seeds all 3 collections (shipments, users, alerts) with rich datasets
  static Future<void> seedAllCollections() async {
    try {
      debugPrint('Initializing Firebase collections seeding...');
      final user = FirebaseAuth.instance.currentUser;
      final String driverId = user?.uid ?? 'driver_demo_001';

      // Seed Shipments Collection
      final batch = _firestore.batch();
      for (final shipment in allCustomsShipments) {
        final docRef = _firestore.collection('shipments').doc(shipment.shipmentId);
        batch.set(
          docRef,
          shipment.toFirestore()..['driverId'] = driverId,
          SetOptions(merge: true),
        );
      }

      // Seed Users Collection with consistent driver and vehicle details
      final userDocRef = _firestore.collection('users').doc(driverId);
      batch.set(
        userDocRef,
        {
          'uid': driverId,
          'fullName': defaultDriverName,
          'fullname': defaultDriverName,
          'email': user?.email ?? 'driver@securetrack.lk',
          'phone': defaultPhone,
          'vehicleNo': defaultVehicleNo,
          'licenseNo': defaultLicenseNo,
          'company': defaultCompany,
          'role': 'DRIVER',
          'vehicleType': 'Tata Prima 4928.S (Heavy Prime Mover)',
          'trailerType': '40ft Tri-Axle Skeletal Trailer',
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // Seed Alerts Collection
      for (final alert in defaultCustomsAlerts) {
        final alertDocRef = _firestore.collection('alerts').doc(alert['id']);
        batch.set(
          alertDocRef,
          {
            ...alert,
            'driverId': driverId,
          },
          SetOptions(merge: true),
        );
      }

      await batch.commit();
      debugPrint('Successfully seeded shipments, users, and alerts collections!');
    } catch (e) {
      debugPrint('Error seeding Firebase collections: $e');
      rethrow;
    }
  }

  /// Automatically seeds all collections if shipments collection is empty
  static Future<void> seedInitialDataIfEmpty() async {
    try {
      final snapshot = await _firestore.collection('shipments').limit(1).get();
      if (snapshot.docs.isEmpty) {
        await seedAllCollections();
      }
    } catch (e) {
      debugPrint('Error checking/seeding collections: $e');
    }
  }
}
