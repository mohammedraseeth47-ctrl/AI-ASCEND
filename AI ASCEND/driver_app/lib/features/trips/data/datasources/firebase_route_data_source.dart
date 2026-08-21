import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackgo_driver/features/trips/domain/entities/route.dart';

class FirebaseRouteDataSource {
  final FirebaseFirestore _firestore;

  FirebaseRouteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<TransitRoute?> getRouteById(String id) async {
    final doc = await _firestore.collection('routes').doc(id).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return TransitRoute.fromFirestore(doc.data()!, doc.id);
  }

  Future<TransitRoute?> getAssignedRoute(String driverId) async {
    // Check assignments collection for the driver's active route
    final querySnapshot = await _firestore
        .collection('assignments')
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final routeId = querySnapshot.docs.first.data()['routeId'] as String?;
      if (routeId != null) {
        return await getRouteById(routeId);
      }
    }

    // Fallback to first available route
    final all = await getAllRoutes();
    return all.isNotEmpty ? all.first : null;
  }

  Future<List<TransitRoute>> getAllRoutes() async {
    final querySnapshot = await _firestore.collection('routes').get();
    return querySnapshot.docs
        .map((doc) => TransitRoute.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
