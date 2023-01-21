import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            automaticallyImplyLeading: false,
            title: const Text('Hello Friend!'),            
          ),
          const Divider(),
          ListTile(
            title: const Text('Shop'),
            leading: const Icon(Icons.shop),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Orders'),
            leading: const Icon(Icons.card_membership),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Manage Products'),
            leading: const Icon(Icons.edit),
            onTap: () {
              Navigator.pushReplacementNamed(context, UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context,listen: false).logout();
              // Navigator.pushReplacementNamed(context, UserProductsScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
