import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/UserProductScreen';

  Future<void> fetchProducts(BuildContext context)async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        
        onRefresh: () => fetchProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productsData.item.length,
            itemBuilder: (context, index) {
              // return ListTile(title: Text('fdsafda'),);
              return UserProductItem(
                id: productsData.item[index].id,
                imageUrl: productsData.item[index].imageUrl,
                title: productsData.item[index].title,
              );
      
            },
          ),
        ),
      ),
    );
  }
}
