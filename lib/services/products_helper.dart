import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import 'config.dart';

class Helper {
  static var client = http.Client();

  // Male
  Future<List<Products>> getMaleProducts() async {
    var url = Uri.http(Config.apiUrl, Config.products);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      final maleList = productsFromJson(response.body);
      var male = maleList.where((element) => element.category == "Men's Running");
      return male.toList();
    } else {
      throw Exception("Failed get products list");
    }
  }

  // Female
  Future<List<Products>> getFemaleProducts() async {
    var url = Uri.http(Config.apiUrl, Config.products);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      final femaleList = productsFromJson(response.body);
      var female = femaleList.where((element) => element.category == "Women's Running");
      return female.toList();
    } else {
      throw Exception("Failed get products list");
    }
  }

  // Kid
  Future<List<Products>> getKidsProducts() async {
    var url = Uri.http(Config.apiUrl, Config.products);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      final kidList = productsFromJson(response.body);
      var kid = kidList.where((element) => element.category == "Kids' Running");
      return kid.toList();
    } else {
      throw Exception("Failed get products list");
    }
  }

  // Search
  Future<List<Products>> search(String searchQuery) async {
    var url = Uri.http(Config.apiUrl, "${Config.search}$searchQuery");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      final results = productsFromJson(response.body);
      return results.toList();
    } else {
      throw Exception("Failed get products list");
    }
  }

  // addComment
  Future<bool> addComment(Comment comment, String productId) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String? userToken = pref.getString('token');

      final Uri url = Uri.http(Config.apiUrl, Config.addComment);
      final Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'token': 'Bearer $userToken',
      };

      Map<String, dynamic> requestBody = {
        'productId': productId,
        'text': comment.text,
      };

      var response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 307) {
        // If the server returns a 307 status code, get the new location and retry the request
        String redirectUrl = response.headers['location'] ?? '';

        // Retry the request with the new location
        final redirectedResponse = await http.post(
          Uri.parse(redirectUrl),
          headers: requestHeaders,
          body: jsonEncode(requestBody),
        );

        if (redirectedResponse.statusCode == 200) {
          return true;
        } else {
          // Handle the case where the redirected request was not successful
          return false;
        }
      } else if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // Handle errors here
      return false;
    }
  }
}
