import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName='product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments;
    final loadedProduct= Provider.of<Products>(context).findById(productId as String);
    return Scaffold(
      appBar: AppBar(
        title:  Text(loadedProduct.title),
      ),
    );
  }
}