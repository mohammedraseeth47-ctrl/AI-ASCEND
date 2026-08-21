import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trackgo_driver/features/authentication/domain/entities/driver_user.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  static DriverUser getDemoDriver(String uid, String? email) {
    return DriverUser(
      id: uid,
      driverId: 'DRV001',
      authUid: uid,
      name: 'Arun Kumar',
      email: email ?? 'driver1@trackgo.com',
      phone: '9876543210',
      region: 'Villupuram',
      rating: 4.94,
      experienceYears: 7,
      status: DriverStatus.available,
      depotId: 'DEPOT-VPM-01',
      assignedDepot: 'Villupuram Central Depot',
      assignedBusId: 'BUS001',
      assignedRouteId: 'VPM-CUD-01',
      licenseNumber: 'TN-32-2015-0048291',
      licenseCategory: 'Commercial HMV',
      licenseExpiry: 'Dec 2028',
      medicalCertificate: 'Class 1 (Valid)',
      vehicleClass: 'PSV Heavy Passenger Transit',
    );
  }

  Future<DriverUser?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    try {
      final driver = await _findDriverByAuthUid(firebaseUser.uid);
      if (driver != null) return driver;
    } catch (_) {}

    return getDemoDriver(firebaseUser.uid, firebaseUser.email);
  }

  Future<DriverUser> login(String email, String password) async {
    try {
      // 1. Real Firebase Authentication
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Authentication failed. No user returned.');
      }

      debugPrint('Firebase authentication successful');
      debugPrint('UID: ${firebaseUser.uid}');
      debugPrint('Email: ${firebaseUser.email}');

      // 2. Attempt Firestore load with graceful demo fallback
      try {
        final driver = await _findDriverByAuthUid(firebaseUser.uid);
        if (driver != null) {
          debugPrint('Using Firestore driver data');
          return driver;
        }
      } catch (firestoreError) {
        debugPrint(
          'Firestore unavailable ($firestoreError) — using demo driver data',
        );
      }

      debugPrint(
        'Firebase authentication successful. Firestore unavailable — using demo driver data',
      );
      return getDemoDriver(firebaseUser.uid, firebaseUser.email);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No driver account found with this email address.');
        case 'wrong-password':
        case 'invalid-credential':
          throw Exception(
            'Invalid email or password. Please verify your credentials.',
          );
        case 'invalid-email':
          throw Exception('The email address format is invalid.');
        case 'user-disabled':
          throw Exception(
            'This driver account has been disabled by operations dispatch.',
          );
        case 'network-request-failed':
          throw Exception(
            'Network connection error. Please check your internet connection.',
          );
        case 'too-many-requests':
          throw Exception(
            'Too many failed login attempts. Please try again later.',
          );
        default:
          throw Exception(
            e.message ??
                'Authentication failed. Please check your credentials.',
          );
      }
    } catch (e) {
      debugPrint('Login exception: $e');
      // If Firebase Auth succeeded but something else failed, return demo driver
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        return getDemoDriver(currentUser.uid, currentUser.email);
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No account found for this email address.');
      }
      throw Exception(e.message ?? 'Password reset failed.');
    }
  }

  Future<DriverUser?> _findDriverByAuthUid(String authUid) async {
    final directDoc = await _firestore.collection('drivers').doc(authUid).get();
    if (directDoc.exists && directDoc.data() != null) {
      return DriverUser.fromFirestore(directDoc.data()!, directDoc.id);
    }
    return null;
  }
}
