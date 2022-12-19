import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            child: AppBar(
              backgroundColor: Colors.amber,
              title: const Text('Shop'),
              leading: const Icon(Icons.shop),
            ),
          ),
          ListTile(
            title: const Text('Orders'),
            leading: const Icon(Icons.card_membership),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
