import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userId;
  Order(this.token,this.userId);

  List<OrderItem> get orders {
    return [..._orders].toList();
  }

  Future<void> fetchAndSetOrders() async {
    Uri url = Uri.parse(
      'https://flutter-chat-3900f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token',
    );
    final response = await http.get(url);
    
    final List<OrderItem> loadedOrders = [];
    
    if (json.decode(response.body) == null) {
      return;
    }
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((orderId, orderData) {
      // print(extractedData);
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List).map((item) {
            // print(item);
            return CartItem(
              id: item['id'],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title'],
            );
          }).toList(),
        ),
      );
    });
    // print('works');
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final time = DateTime.now();
    Uri url = Uri.parse(
      'https://flutter-chat-3900f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token',
    );
    final response = await http.post(url,
        body: jsonEncode({
          'amount': total,
          'dateTime': time.toIso8601String(),
          'products': cartProduct
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity
                  })
              .toList()
        }));

    _orders.insert(
      0,
      OrderItem(
          id: jsonDecode(response.body)['name'],
          amount: total,
          dateTime: time,
          products: cartProduct),
    );
    notifyListeners();
  }
}
