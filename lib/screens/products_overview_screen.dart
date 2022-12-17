import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Shop'),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorites) {
                    _isFavorite = true;
                  } else {
                    _isFavorite = false;
                  }
                });
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: FilterOptions.Favorites,
                  child: Text('Favorites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.All,
                  child: Text('All'),
                ),
              ],
            ),
          ],
        ),
        body: ProductGrid(_isFavorite));
  }
}
