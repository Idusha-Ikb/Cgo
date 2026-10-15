import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/shipment_model.dart';
import 'firebase_service.dart';

class ShipmentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionName = 'shipments';

  // ValueNotifier for the currently selected/active shipment for navigation
  static final ValueNotifier<ShipmentModel?> activeShipmentNotifier =
      ValueNotifier<ShipmentModel?>(null);

  /// Access the complete Sri Lanka Customs shipments dataset
  static List<ShipmentModel> get defaultCustomsShipments =>
      FirebaseService.allCustomsShipments;

  /// Seeds initial collections to Firestore if empty
  static Future<void> seedInitialShipmentsIfEmpty() async {
    await FirebaseService.seedInitialDataIfEmpty();
  }

  /// Explicitly seed or reset the Sri Lanka Customs dataset in Firestore
  static Future<void> seedCustomsDataset() async {
    await FirebaseService.seedAllCollections();
  }

  /// Stream shipments in real-time with optional status filtering
  static Stream<List<ShipmentModel>> streamShipments({String? statusFilter}) {
    final String? currentDriverId = FirebaseAuth.instance.currentUser?.uid;
    
    Query query = FirebaseFirestore.instance.collection('shipments');

    if (statusFilter == 'Active' || statusFilter == 'Completed') {
      if (currentDriverId == null) return Stream.value([]);
      query = query.where('driverId', isEqualTo: currentDriverId)
                   .where('status', isEqualTo: statusFilter);
    } else if (statusFilter == 'All') {
      
      query = FirebaseFirestore.instance.collection('shipments');
    } else if (statusFilter != null) {
      query = query.where('status', isEqualTo: statusFilter);
    }

    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        if (statusFilter == null || statusFilter == 'All') {
          return defaultCustomsShipments;
        }
        return defaultCustomsShipments
            .where((s) => s.status.toLowerCase() == statusFilter.toLowerCase())
            .toList();
      }

      List<ShipmentModel> shipments = snapshot.docs
          .map((doc) => ShipmentModel.fromFirestore(doc))
          .toList();

      if (statusFilter == 'All') {
        return shipments.where((s) {
          String status = s.status.toLowerCase();
          if (status == 'pending') return true;
          if ((status == 'active' || status == 'completed') && s.driverId == currentDriverId) {
            return true;
          }
          return false;
        }).toList();
      }

      return shipments;
    });
  }

  /// Set the active shipment and notify listeners
  static void setActiveShipment(ShipmentModel shipment) {
    activeShipmentNotifier.value = shipment;
  }
}
