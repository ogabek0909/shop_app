import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String token;
  final String userId;
  Products(this.token,this.userId);

  List<Product> get item {
    return [..._items].toList();
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere(
      (element) => element.id == id,
    );
  }

  Future<void> fetchAndSetProducts([bool filterUserBy = false]) async {
    final filterString = filterUserBy ? 'orderBy="creatorId"&equalTo="$userId"' : ''; 
    Uri url = Uri.parse(
      'https://flutter-chat-3900f-default-rtdb.firebaseio.com/products.json?auth=$token&$filterString',
    );
    try {
      final http.Response response = await http.get(url);
      // print(jsonDecode(response.body));
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if(jsonDecode(response.body)==null){
        return;
      }
       url = Uri.parse(
      'https://flutter-chat-3900f-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$token',
    );
    final favoriteResponse = await http.get(url);
    final favoriteData = jsonDecode(favoriteResponse.body);

      List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: favoriteData==null ? false : favoriteData[key] ?? false,
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    Uri url = Uri.parse(
      'https://flutter-chat-3900f-default-rtdb.firebaseio.com/products.json?auth=$token',
    );
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'id': product.id,
            'description': product.description,
            'creatorId':userId
          }));

      _items.add(
        Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // print(jsonDecode(value.body));
  }

  Future<void> editProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      Uri url = Uri.parse(
        'https://flutter-chat-3900f-default-rtdb.firebaseio.com/products/$id.json?auth=$token',
      );
      await http.patch(url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
    }
    notifyListeners();
  }

  Future<void> deleteProdcut(String id) async {
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    Uri url = Uri.parse(
      'https://flutter-chat-3900f-default-rtdb.firebaseio.com/products/$id.json?auth=$token',
    );
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final value = await http.delete(url);
    if (value.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Couldn\'t delete product!');
    }

    // _items.removeWhere((element) => element.id == id);
  }
}
