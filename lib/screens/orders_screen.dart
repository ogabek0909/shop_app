import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/orders.dart' show Order;
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'OrdersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  
  Future? _ordersFuture;

  Future obtainOrdersFuture (){
    return Provider.of<Order>(context, listen: false).fetchAndSetOrders();
  }
  @override
  void initState() {
    _ordersFuture = obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Order>(context, listen: false);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else {
            return Consumer<Order>(
              builder: (context, orders, child) => ListView.builder(
                itemCount: orders.orders.length,
                itemBuilder: (context, index) => OrderItem(
                  order: orders.orders[index],
                ),
              ),
             
            );
          }
        },
      ),
    );
  }
}
