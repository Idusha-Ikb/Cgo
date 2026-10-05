import 'package:flutter/material.dart';

/// Container data representation
class ContainerModel {
  final String id;
  final String owner;
  final String route;
  final String currentLocation;
  final String destination;
  final String estimatedArrival;
  final String driverName;
  final String sealStatus;
  final int batteryLevel;
  final String status; // 'On Track', 'Arrived'
  final Color containerColor;
  final String assetImage;

  const ContainerModel({
    required this.id,
    required this.owner,
    required this.route,
    required this.currentLocation,
    required this.destination,
    required this.estimatedArrival,
    required this.driverName,
    required this.sealStatus,
    required this.batteryLevel,
    required this.status,
    required this.containerColor,
    required this.assetImage,
  });

  static List<ContainerModel> get sampleContainers => const [
        ContainerModel(
          id: 'CONT-001',
          owner: 'Cargo Overseas Freight Pvt Ltd',
          route: 'Colombo Port Gate 04 ➔ Orugodawatta Customs Yard (RCT)',
          currentLocation: 'Baseline Road, Colombo',
          destination: 'Orugodawatta Examination Yard (RCT)',
          estimatedArrival: '12 Sep 2026 , 10.00 AM',
          driverName: 'S.A. Gamage',
          sealStatus: 'Intact',
          batteryLevel: 75,
          status: 'On Track',
          containerColor: Color(0xFF10B981), // Green
          assetImage: 'assets/images/cont_green.png',
        ),
        ContainerModel(
          id: 'CONT-002',
          owner: 'Cargo Overseas Freight Pvt Ltd',
          route: 'Colombo Port Gate 02 ➔ Grayline 1 (GL1) Yard (Grandpass)',
          currentLocation: 'Prince of Wales Ave, Colombo 14',
          destination: 'Grayline 1 (GL1) Examination Yard',
          estimatedArrival: '12 Sep 2026 , 11.30 AM',
          driverName: 'K.D. Kumara',
          sealStatus: 'Intact',
          batteryLevel: 20,
          status: 'On Track',
          containerColor: Color(0xFFD97706), // Brown/Amber
          assetImage: 'assets/images/cont_brown.png',
        ),
        ContainerModel(
          id: 'CONT-003',
          owner: 'Cargo Overseas Freight Pvt Ltd',
          route: 'Colombo Port Gate 05 ➔ Grayline 2 (GL2) Yard (Peliyagoda)',
          currentLocation: 'Grayline 2 Yard Terminal, Peliyagoda',
          destination: 'Grayline 2 (GL2) Examination Yard',
          estimatedArrival: '10 Sep 2026 , 02.00 PM',
          driverName: 'R.M. Perera',
          sealStatus: 'Intact',
          batteryLevel: 92,
          status: 'Arrived',
          containerColor: Color(0xFF2563EB), // Blue
          assetImage: 'assets/images/cont_blue.png',
        ),
      ];
}

/// Alert notification item model
class AlertItem {
  final String id;
  final String title;
  final String containerId;
  final String timestamp;
  final String category; // 'Security', 'Location', 'Bettery'
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const AlertItem({
    required this.id,
    required this.title,
    required this.containerId,
    required this.timestamp,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  static List<AlertItem> get sampleAlerts => const [
        AlertItem(
          id: '1',
          title: 'Route Deviation Alerts',
          containerId: 'CONT-003',
          timestamp: '10 Sep 2026 , 14.32',
          category: 'Location',
          icon: Icons.warning_amber_rounded,
          iconColor: Color(0xFFDC2626), // Red
          bgColor: Color(0xFFFEE2E2),
        ),
        AlertItem(
          id: '2',
          title: 'Low Bettery',
          containerId: 'CONT-002',
          timestamp: '09 Sep 2026 , 18.15',
          category: 'Bettery',
          icon: Icons.battery_alert_rounded,
          iconColor: Color(0xFFD97706), // Orange
          bgColor: Color(0xFFFEF3C7),
        ),
        AlertItem(
          id: '3',
          title: 'Seal Opened',
          containerId: 'CONT-001',
          timestamp: '08 Sep 2026 , 09.22',
          category: 'Security',
          icon: Icons.check_circle_rounded,
          iconColor: Color(0xFF16A34A), // Green
          bgColor: Color(0xFFDCFCE7),
        ),
        AlertItem(
          id: '4',
          title: 'ETA Updated',
          containerId: 'CONT-002',
          timestamp: '07 Sep 2026 , 16.32',
          category: 'Location',
          icon: Icons.calculate_outlined,
          iconColor: Color(0xFF0284C7), // Blue
          bgColor: Color(0xFFE0F2FE),
        ),
        AlertItem(
          id: '5',
          title: 'Location Update',
          containerId: 'CONT-001',
          timestamp: '07 Sep 2026 , 12.32',
          category: 'Location',
          icon: Icons.location_on_rounded,
          iconColor: Color(0xFFD97706), // Yellow / Amber
          bgColor: Color(0xFFFEF3C7),
        ),
      ];
}

/// User details model
class UserModel {
  final String name;
  final String email;
  final String phone;
  final String role; // 'Owner', 'Driver'
  final String company;
  final String companyId;

  const UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.company = 'Cargo Overseas Freight Pvt Ltd',
    this.companyId = 'COMP-COF-2024',
  });

  static const UserModel defaultOwner = UserModel(
    name: 'Tharindu Perera',
    email: 'owner@cargooverseas.lk',
    phone: '+94 77 123 4567',
    role: 'Owner',
    company: 'Cargo Overseas Freight Pvt Ltd',
    companyId: 'COMP-COF-2024',
  );
}

/// Driver Trip details model (SRS Pages 11 & 12)
class DriverTripModel {
  final String tripId;
  final String containerId;
  final String status; // 'On Route', 'Deviated', 'Completed'
  final String startLocation;
  final String startTime;
  final String destination;
  final String expectedTime;
  final String distanceLeft;
  final String eta;
  final double progressPercent;
  final String sealStatus;
  final String weight;
  final String containerType;
  final String nextTurnDistance;
  final String nextTurnInstruction;
  final String totalTrips;
  final String onTimeRate;
  final String totalDistance;
  final bool isDeviated;
  final bool isEmergencyActive;

  const DriverTripModel({
    required this.tripId,
    required this.containerId,
    required this.status,
    required this.startLocation,
    required this.startTime,
    required this.destination,
    required this.expectedTime,
    required this.distanceLeft,
    required this.eta,
    required this.progressPercent,
    required this.sealStatus,
    required this.weight,
    required this.containerType,
    required this.nextTurnDistance,
    required this.nextTurnInstruction,
    this.totalTrips = '24',
    this.onTimeRate = '98%',
    this.totalDistance = '3.2k km',
    this.isDeviated = false,
    this.isEmergencyActive = false,
  });

  static const DriverTripModel sampleTrip = DriverTripModel(
    tripId: 'TRP-8473',
    containerId: 'CTR-2024-8473',
    status: 'On Route',
    startLocation: 'Katunayake Export Processing Zone',
    startTime: 'Today at 6:00 AM',
    destination: 'Port of Colombo',
    expectedTime: 'Today at 11:30 AM',
    distanceLeft: '142 km',
    eta: '2h 30m',
    progressPercent: 0.60,
    sealStatus: 'Closed',
    weight: '18,500 kg',
    containerType: '40ft HC',
    nextTurnDistance: 'In 2.3 km',
    nextTurnInstruction: 'Turn right onto A1 Highway',
  );
}

/// Customs Inspector Log & Audit Record (SRS Pages 9, 20-23)
class InspectionLogModel {
  final String id;
  final String containerId;
  final String action;
  final String inspectorName;
  final String timestamp;
  final String status;
  final String sealTag;
  final int batteryLevel;

  const InspectionLogModel({
    required this.id,
    required this.containerId,
    required this.action,
    required this.inspectorName,
    required this.timestamp,
    required this.status,
    required this.sealTag,
    required this.batteryLevel,
  });

  static List<InspectionLogModel> get sampleLogs => const [
        InspectionLogModel(
          id: 'INSP-101',
          containerId: 'CONT-001',
          action: 'Smart Seal Locked & Initialized (UC-01)',
          inspectorName: 'Officer K. Silva',
          timestamp: '12 Sep 2026, 08:30 AM',
          status: 'Active & Locked',
          sealTag: 'TAG-ESP32-8473',
          batteryLevel: 98,
        ),
        InspectionLogModel(
          id: 'INSP-102',
          containerId: 'CONT-003',
          action: 'Destination Arrival & Seal Unlocked (UC-03)',
          inspectorName: 'Officer K. Silva',
          timestamp: '10 Sep 2026, 02:15 PM',
          status: 'Completed & Unlocked',
          sealTag: 'TAG-ESP32-1120',
          batteryLevel: 91,
        ),
        InspectionLogModel(
          id: 'INSP-103',
          containerId: 'CONT-002',
          action: 'Low Battery & Sensor Check',
          inspectorName: 'Officer K. Silva',
          timestamp: '09 Sep 2026, 06:20 PM',
          status: 'Warning Logged',
          sealTag: 'TAG-ESP32-6721',
          batteryLevel: 20,
        ),
      ];
}
