import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackgo_driver/features/trips/domain/entities/vehicle.dart';

class FirebaseVehicleDataSource {
  final FirebaseFirestore _firestore;

  FirebaseVehicleDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Vehicle?> getVehicleById(String id) async {
    final doc = await _firestore.collection('vehicles').doc(id).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return Vehicle.fromFirestore(doc.data()!, doc.id);
  }

  Future<Vehicle?> getAssignedVehicle(String driverId) async {
    final querySnapshot = await _firestore
        .collection('vehicles')
        .where('assignedDriverId', isEqualTo: driverId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return Vehicle.fromFirestore(doc.data(), doc.id);
    }
    return null;
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final querySnapshot = await _firestore.collection('vehicles').get();
    return querySnapshot.docs
        .map((doc) => Vehicle.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
