import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus(String token,String userId) async {
    bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    Uri url = Uri.parse(
      'https://flutter-chat-3900f-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$token',
    );
    try {
      final response = await http.put(
        url,
        body: jsonEncode(
          isFavorite
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (_) {}
  }
}
