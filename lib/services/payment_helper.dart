import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/orders/orders_req.dart';
import 'config.dart';

class PaymentHelper {
  static var client = https.Client();

  // payment Stripe
  Future<String> payment(Order model) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };
      var url = Uri.https(Config.paymentBaseUrl, Config.paymentUrl);

      final response = await https.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
      if (response.statusCode == 200) {
        var payment = jsonDecode(response.body);
        return payment['url'];
      } else {
        return 'failed';
      }
    } catch (error) {
      return 'failed';
    }
  }

  Future<bool> paymentOnDelivery(OrderOnDelivery model) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String? userToken = pref.getString('token');

      final Uri url = Uri.http(Config.apiUrl, Config.addOrderUrl);
      final Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'token': 'Bearer $userToken',
      };

      var response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        // Handle the case where the initial request was not successful
        return false;
      }
    } catch (error) {
      // Handle errors here
      print("Error during payment on delivery: $error");
      return false;
    }
  }
}
