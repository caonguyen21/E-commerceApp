import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shopping_app/models/cart/add_to_cart.dart';
import 'package:flutter_shopping_app/models/orders/orders_res.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart/get_products.dart';
import 'config.dart';

class CartHelper {
  static var client = http.Client();

  Future<bool> addToCart(AddToCart model, String action, String size) async {
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
      Map<String, dynamic> requestBody = {"cartItem": cartItemId, "action": action, "size": size};

      var response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(requestBody),
      );

      // Check for 307 status code
      if (response.statusCode == 307) {
        // If the server returns a 307 status code, get the new location and retry the request
        String redirectUrl = response.headers['location'] ?? '';

        // Retry the request with the new location
        response = await http.post(
          Uri.parse(redirectUrl),
          headers: requestHeaders,
          body: jsonEncode(requestBody),
        );
      }

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');

    if (userToken == null) {
      // User is not logged in, handle accordingly (e.g., show a message)
      throw Exception('User is not logged in. Please log in to view the cart.');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $userToken',
    };

    var url = Uri.http(Config.apiUrl, Config.getCartUrl);

    var response = await client.get(url, headers: requestHeaders);
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<Product> cart = [];
      var products = jsonData[0]['products'];
      cart = List<Product>.from(products.map((product) => Product.fromJson(product)));
      return cart;
    } else {
      throw Exception("Failed to get cart items");
    }
  }

  Future<bool> deleteItem(String id) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? userToken = pref.getString('token');

      if (userToken == null) {
        // Handle the case where userToken is null (user not authenticated)
        return false;
      }

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'token': 'Bearer $userToken',
      };

      var url = Uri.http(Config.apiUrl, "${Config.addCartUrl}/$id");

      final response = await http.delete(url, headers: requestHeaders);

      if (response.statusCode == 307) {
        // If the server returns a 307 status code, get the new location and retry the request
        String redirectUrl = response.headers['location'] ?? '';

        // Retry the request with the new location
        final redirectedResponse = await http.delete(
          Uri.parse(redirectUrl),
          headers: requestHeaders,
        );
        if (redirectedResponse.statusCode == 200) {
          return true;
        } else {
          // Print the response status code and body for debugging
          return false;
        }
      } else if (response.statusCode == 200) {
        return true;
      } else {
        // Print the response status code and body for debugging
        return false;
      }
    } catch (error) {
      // Handle errors here
      return false;
    }
  }

  Future<List<PaidOrders>> getOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');

    if (userToken == null) {
      // User is not logged in, handle accordingly (e.g., show a message)
      throw Exception('User is not logged in. Please log in to view the cart.');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $userToken',
    };

    var url = Uri.http(Config.apiUrl, Config.orders);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var products = paidOrdersFromJson(response.body);
      return products;
    } else {
      throw Exception("Failed to get cart items");
    }
  }
}
