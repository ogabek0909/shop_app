import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token='';
  DateTime? _expiryDate;
  String _userId='';

  bool get isAuth{
    return token != '' ;
  }

  String get userId{
    return _userId;
  }

  String get token{
    if(_expiryDate != null && _token != ''  && _expiryDate!.isAfter(DateTime.now())){
      return _token;
    }
    return '';
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAFkXObQXTWVCqo-HhX_IT5BvPHbXk6CP0');
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'email': email,
              "password": password,
              "returnSecureToken": true,
            },
          ));
      final responseData=jsonDecode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          "token":_token,
          'userId':_userId,
          'expiryDate':_expiryDate!.toIso8601String()
        }
      );
      
      prefs.setString('userData', userData);
      // print(jsonDecode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    print(jsonDecode(prefs.getString('userData')!));
    final extractedData = jsonDecode(prefs.getString('userData')!);
    final expiryDate = DateTime.parse(extractedData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;
    print('object');
    notifyListeners();
    return true;
  }
  void logout(){
    _expiryDate = null;
    _token = '';
    _userId = '';
    notifyListeners();
  }
}
