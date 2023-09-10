import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

class Helper {
  Future<List<Product>> getMaleProducts() async {
    final data = await rootBundle.loadString("assets/json/men_shoes.json");
    final maleList = productsFromJson(data);
    return maleList;
  }

  Future<List<Product>> getFemaleProducts() async {
    final data = await rootBundle.loadString("assets/json/women_shoes.json");
    final femaleList = productsFromJson(data);
    return femaleList;
  }

  Future<List<Product>> getKidsProducts() async {
    final data = await rootBundle.loadString("assets/json/kids_shoes.json");
    final kidsList = productsFromJson(data);
    return kidsList;
  }

  Future<Product> getMaleProductsById(String id) async {
    final data = await rootBundle.loadString("assets/json/men_shoes.json");
    final maleList = productsFromJson(data);
    final product = maleList.firstWhere((product) => product.id == id);
    return product;
  }

  Future<Product> getFemaleProductsById(String id) async {
    final data = await rootBundle.loadString("assets/json/women_shoes.json");
    final femaleList = productsFromJson(data);
    final product = femaleList.firstWhere((product) => product.id == id);
    return product;
  }

  Future<Product> getKidsProductsById(String id) async {
    final data = await rootBundle.loadString("assets/json/kids_shoes.json");
    final kidsList = productsFromJson(data);
    final product = kidsList.firstWhere((product) => product.id == id);
    return product;
  }
}
