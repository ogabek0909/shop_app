import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/orders.dart' show Order;
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'OrdersScreen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Order>(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.orders.length,
        itemBuilder: (context, index) => OrderItem(
          order: orders.orders[index],
        ),
      ),
    );
  }
}
