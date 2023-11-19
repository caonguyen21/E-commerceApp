import 'dart:convert';

import 'package:http/http.dart' as https;

import '../models/orders/orders_req.dart';
import 'config.dart';

class PaymentHelper {
  static var client = https.Client();

  Future<String> payment(Order model) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };
      var url = Uri.https(Config.paymentBaseUrl, Config.paymentUrl);

      final response = await https.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
      print(response.statusCode);
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
}
