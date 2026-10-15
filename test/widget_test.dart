import 'package:flutter_test/flutter_test.dart';
import 'package:driver_app/services/shipment_service.dart';

void main() {
  test('Sri Lanka Customs dataset contains valid SRS shipments across all categories', () {
    final shipments = ShipmentService.defaultCustomsShipments;
    expect(shipments.isNotEmpty, true);
    expect(shipments.length, 12);

    final activeShipments = shipments.where((s) => s.status == 'Active').toList();
    final pendingShipments = shipments.where((s) => s.status == 'Pending').toList();
    final completedShipments = shipments.where((s) => s.status == 'Completed').toList();

    expect(activeShipments.length, 4);
    expect(pendingShipments.length, 4);
    expect(completedShipments.length, 4);

    final first = shipments.first;
    expect(first.shipmentId, 'SHP-2026-001');
    expect(first.containerId, 'CONT-001');
    expect(first.status, 'Active');
    expect(first.vehicleNo, 'WP-DA-4821');
    expect(first.sealNumber, 'SL-CUS-884912');
  });

  test('ShipmentModel correctly converts to container details map', () {
    final shipment = ShipmentService.defaultCustomsShipments.first;
    final map = shipment.toContainerDetailsMap();

    expect(map['containerId'], 'CONT-001');
    expect(map['sealNumber'], 'SL-CUS-884912');
    expect(map['status'], 'In Transit');
  });
}
