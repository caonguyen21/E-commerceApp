import 'package:http/http.dart' as http;

import '../models/product.dart';
import 'config.dart';

class Helper {
  static var client = http.Client();

  // Male
  Future<List<Product>> getMaleProducts() async {
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
  Future<List<Product>> getFemaleProducts() async {
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
  Future<List<Product>> getKidsProducts() async {
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
}
