import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order.dart';
import 'package:food_delivery_app/services/order_service.dart';
import 'package:food_delivery_app/services/auth/auth_services.dart';

class OrderHistoryPage extends StatelessWidget {
  final String customerId; // Added this field
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();

  // Updated constructor to accept customerId
  OrderHistoryPage({Key? key, required this.customerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser(); // Get the current user

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order History')),
        body: const Center(
          child: Text('Please log in to see your order history'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: FutureBuilder<List<Order>>(
        future: _orderService
            .getOrderHistory(customerId), // Fetch orders for the customerId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching order history'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle:
                      Text('Total: \$${order.totalPrice.toStringAsFixed(2)}'),
                  onTap: () {
                    // Handle order tap if needed
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
