import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shopping_app/models/cart/add_to_cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart/get_products.dart';
import 'config.dart';

class CartHelper {
  static var client = http.Client();

  Future<bool> addToCart(AddToCart model, String action) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String? userToken = pref.getString('token');

      final Uri url = Uri.http(Config.apiUrl, Config.addCartUrl);
      final Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'token': 'Bearer $userToken',
      };

      // Extract the cartItem ID from the model
      String cartItemId = model.cartItem;

      // Send only the cartItem ID in the request payload
      Map<String, dynamic> requestBody = {"cartItem": cartItemId, "action": action};

      final response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      return false;
    }
  }

  Future<List<Product>> getCart() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userToken = pref.getString('token');
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'token': 'Bearer $userToken'};

    var url = Uri.http(Config.apiUrl, Config.getCartUrl);

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<Product> cart = [];
      var products = jsonData[0]['products'];
      cart = List<Product>.from(products.map((product) => Product.fromJson(product)));
      return cart;
    } else {
      throw Exception("Failed to get cart item");
    }
  }

  Future<bool> deleteItem(String id) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userToken = pref.getString('token');
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'token': 'Bearer $userToken'};

    var url = Uri.http(Config.apiUrl, "${Config.addCartUrl}/$id");

    var response = await client.delete(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
