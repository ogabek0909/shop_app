import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens//product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          secondaryHeaderColor: Colors.deepOrange,
          //fontFamily: 'Loto',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName:(context) => OrdersScreen(),
          UserProductsScreen.routeName:(context) => UserProductsScreen(),
          EditProductScreen.routeName:(context) => EditProductScreen()
        },
      ),
    );
  }
}
