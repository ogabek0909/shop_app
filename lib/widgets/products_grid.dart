import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/product.dart';
import 'product_item.dart';


class ProductGrid extends StatelessWidget {
  // final List<Product> loadedProducts;
  // const ProductGrid({super.key,required this.loadedProducts});

  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<Products>(context);
    
    final products = productsData.item;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider(
          create: (context) => products[index],
          child: ProductItem(),
        ),
        itemCount: products.length,
      );
  }
}