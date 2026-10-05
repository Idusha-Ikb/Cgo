import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'models.dart';

/// Firebase & Cloud Firestore Service for SecureTrack SL
/// Handles Real-Time GPS Telemetry, e-Seal Tampering Alarms & Authentication
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  FirebaseAuth? get auth => _isInitialized ? FirebaseAuth.instance : null;
  FirebaseFirestore? get firestore => _isInitialized ? FirebaseFirestore.instance : null;

  static const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: 'AIzaSyAXAteQym94-YwYHiKjaTFrLm-KGgysouw',
    appId: '1:280482934844:android:22336e33eb9d10a13ad339',
    messagingSenderId: '280482934844',
    projectId: 'track-sl',
    storageBucket: 'track-sl.firebasestorage.app',
  );

  /// Initialize Firebase credentials
  Future<void> init() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: firebaseOptions);
      }
      _isInitialized = true;
      debugPrint('[Firebase] Firebase initialized successfully with project track-sl');
      // Auto seed sample containers into Firestore if empty
      await seedInitialDataIfEmpty();
    } catch (e) {
      debugPrint('[Firebase] Running in hybrid fallback mode: $e');
      _isInitialized = false;
    }
  }

  /// Sign In with Firebase Authentication
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    if (_isInitialized && auth != null) {
      try {
        final credential = await auth!.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        return {
          'success': true,
          'uid': credential.user?.uid,
          'email': credential.user?.email,
        };
      } catch (e) {
        return {'success': false, 'error': e.toString()};
      }
    }
    return {'success': true, 'message': 'Authenticated locally'};
  }

  /// Auto-seed initial containers into Firestore so cloud data exists immediately
  Future<void> seedInitialDataIfEmpty() async {
    if (!_isInitialized || firestore == null) return;
    try {
      final col = firestore!.collection('containers');
      final snapshot = await col.limit(1).get();
      if (snapshot.docs.isEmpty) {
        debugPrint('[Firebase] Seeding initial SRS containers to Firestore...');
        for (final c in ContainerModel.sampleContainers) {
          await col.doc(c.id).set({
            'id': c.id,
            'owner': c.owner,
            'route': c.route,
            'currentLocation': c.currentLocation,
            'destination': c.destination,
            'estimatedArrival': c.estimatedArrival,
            'driverName': c.driverName,
            'sealStatus': c.sealStatus,
            'batteryLevel': c.batteryLevel,
            'status': c.status,
            'latitude': c.id == 'CONT-001' ? 6.9455 : 6.9410,
            'longitude': c.id == 'CONT-001' ? 79.8510 : 79.8525,
            'speed': 42,
            'last_updated': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      debugPrint('[Firebase] Seed note: $e');
    }
  }

  /// Stream containers from Cloud Firestore or Local Repository
  Stream<List<ContainerModel>> getContainersStream() {
    if (_isInitialized && firestore != null) {
      return firestore!.collection('containers').snapshots().map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            final String id = data['id'] ?? doc.id;
            Color containerColor = const Color(0xFF10B981);
            String assetImage = 'assets/images/cont_green.png';
            if (id == 'CONT-002') {
              containerColor = const Color(0xFFD97706);
              assetImage = 'assets/images/cont_brown.png';
            } else if (id == 'CONT-003') {
              containerColor = const Color(0xFF2563EB);
              assetImage = 'assets/images/cont_blue.png';
            }

            return ContainerModel(
              id: id,
              owner: data['owner'] ?? 'Cargo Overseas Freight Pvt Ltd',
              route: data['route'] ?? '',
              currentLocation: data['currentLocation'] ?? '',
              destination: data['destination'] ?? '',
              estimatedArrival: data['estimatedArrival'] ?? '',
              driverName: data['driverName'] ?? 'S.A. Gamage',
              sealStatus: data['sealStatus'] ?? 'Intact',
              batteryLevel: (data['batteryLevel'] as num?)?.toInt() ?? 80,
              status: data['status'] ?? 'On Track',
              containerColor: containerColor,
              assetImage: assetImage,
            );
          }).toList();
        }
        return ContainerModel.sampleContainers;
      }).handleError((_) => ContainerModel.sampleContainers);
    }
    return Stream.value(ContainerModel.sampleContainers);
  }

  /// Stream live telemetry data for a specific container (GPS lat/lng, speed, battery, e-seal)
  Stream<Map<String, dynamic>?> getContainerLiveTelemetryStream(String containerId) {
    if (_isInitialized && firestore != null) {
      return firestore!.collection('containers').doc(containerId).snapshots().map((doc) {
        if (doc.exists && doc.data() != null) {
          return doc.data()!;
        }
        return null;
      }).handleError((_) => null);
    }
    return Stream.value(null);
  }

  /// Stream real-time alerts from Cloud Firestore
  Stream<List<AlertItem>> getAlertsStream({String category = 'All'}) {
    if (_isInitialized && firestore != null) {
      Query query = firestore!.collection('alerts');
      if (category != 'All') {
        query = query.where('category', isEqualTo: category);
      }
      return query.snapshots().map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final cat = data['category'] ?? 'Location';
            IconData icon = Icons.warning_amber_rounded;
            Color iconColor = const Color(0xFFDC2626);
            Color bgColor = const Color(0xFFFEE2E2);

            if (cat == 'Security') {
              icon = Icons.lock_outline_rounded;
              iconColor = const Color(0xFFDC2626);
              bgColor = const Color(0xFFFEE2E2);
            } else if (cat == 'Battery' || cat == 'Bettery') {
              icon = Icons.battery_alert_rounded;
              iconColor = const Color(0xFFD97706);
              bgColor = const Color(0xFFFEF3C7);
            } else {
              icon = Icons.alt_route_rounded;
              iconColor = const Color(0xFF2563EB);
              bgColor = const Color(0xFFDBEAFE);
            }

            return AlertItem(
              id: doc.id,
              title: data['title'] ?? 'Alert Notification',
              containerId: data['containerId'] ?? 'CONT-001',
              timestamp: data['timestamp'] ?? 'Just now',
              category: cat,
              icon: icon,
              iconColor: iconColor,
              bgColor: bgColor,
            );
          }).toList();
        }
        return AlertItem.sampleAlerts.where((a) {
          if (category == 'All') return true;
          return a.category.toLowerCase() == category.toLowerCase();
        }).toList();
      }).handleError((_) => AlertItem.sampleAlerts);
    }
    return Stream.value(
      AlertItem.sampleAlerts.where((a) {
        if (category == 'All') return true;
        return a.category.toLowerCase() == category.toLowerCase();
      }).toList(),
    );
  }

  /// Trigger a live e-Seal Tamper or GPS update in Cloud Firestore (for testing/demo)
  Future<void> updateContainerTelemetry({
    required String containerId,
    double? latitude,
    double? longitude,
    int? speed,
    int? batteryLevel,
    String? sealStatus,
  }) async {
    if (!_isInitialized || firestore == null) return;
    try {
      final Map<String, dynamic> updateData = {
        'last_updated': FieldValue.serverTimestamp(),
      };
      if (latitude != null) updateData['latitude'] = latitude;
      if (longitude != null) updateData['longitude'] = longitude;
      if (speed != null) updateData['speed'] = speed;
      if (batteryLevel != null) updateData['batteryLevel'] = batteryLevel;
      if (sealStatus != null) updateData['sealStatus'] = sealStatus;

      await firestore!.collection('containers').doc(containerId).set(
            updateData,
            SetOptions(merge: true),
          );

      // If tampered, also record in alerts collection
      if (sealStatus != null && sealStatus.toLowerCase() == 'tampered') {
        await firestore!.collection('alerts').add({
          'title': 'CRITICAL: e-Seal Tampered on $containerId',
          'containerId': containerId,
          'category': 'Security',
          'timestamp': DateTime.now().toString().substring(0, 16),
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('[Firebase] Update error: $e');
    }
  }
}
