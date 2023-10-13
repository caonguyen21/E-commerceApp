import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/favorite/add_to_fav.dart';
import '../models/favorite/get_productsfav.dart';
import 'config.dart';

class FavoriteHelper {
  static var client = http.Client();

  Future<bool> addFavorite(Favorite favorite) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String? userToken = pref.getString('token');

      final Uri url = Uri.http(Config.apiUrl, Config.addFavoriteUrl);
      final Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'token': 'Bearer $userToken',
      };

      Map<String, dynamic> requestBody = {
        "productId": favorite.productId,
      };

      var response = await http.post(
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
      // Handle errors here
      return false;
    }
  }

  Future<List<ProductFav>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');

    if (userToken == null) {
      // User is not logged in, handle accordingly (e.g., show a message)
      throw Exception('User is not logged in. Please log in to view favorites.');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $userToken',
    };

    var url = Uri.http(Config.apiUrl, Config.addFavoriteUrl);

    var response = await client.get(url, headers: requestHeaders);
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      // Ensure jsonData is not null and contains a non-empty 'products' key
      if (jsonData != null && jsonData['products'] != null) {
        List<ProductFav> fav = [];
        var products = jsonData['products'];
        fav = List<ProductFav>.from(products.map((product) => ProductFav.fromJson(product)));
        return fav;
      } else {
        throw Exception('Failed to parse favorites data. Missing or invalid products data.');
      }
    } else {
      throw Exception('Failed to get favorites. Status code: ${response.statusCode}');
    }
  }

  Future<bool> deleteFavorite(String id) async {
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

      var url = Uri.http(Config.apiUrl, "${Config.addFavoriteUrl}/$id");
      //print(url);
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
}
