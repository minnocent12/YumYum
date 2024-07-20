import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add an order to Firestore
  Future<void> addOrder({
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double totalPrice,
  }) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      await _firestore.collection('orders').add({
        'userId': user.uid,
        'orderId': orderId,
        'items': items,
        'totalPrice': totalPrice,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  // Fetch order history for the current user
  Future<List<Map<String, dynamic>>> getOrderHistory() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      QuerySnapshot orderSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> orders = orderSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return orders;
    } catch (e) {
      throw Exception('Failed to fetch order history: $e');
    }
  }
}
