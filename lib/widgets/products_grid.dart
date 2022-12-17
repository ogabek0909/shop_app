import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import 'product_item.dart';


class ProductGrid extends StatelessWidget {
  // final List<Product> loadedProducts;
  final bool isFav;
  const ProductGrid(this.isFav,{super.key});

  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<Products>(context);
    
    final products = isFav? productsData.favoriteItems : productsData.item;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        ),
        itemCount: products.length,
      );
  }
}