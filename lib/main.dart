import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          secondaryHeaderColor: Colors.deepOrange,
          //fontFamily: 'Loto',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName:(context) => ProductDetailScreen()
        },
      ),
    );
  }
}