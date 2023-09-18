import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/helper.dart';

class ProductNotifier extends ChangeNotifier {
  int _activepage = 0;
  List<dynamic> _productSizes = [];
  List<String> _sizes = [];

  int get activepage => _activepage;

  set activePage(int newIndex) {
    _activepage = newIndex;
    notifyListeners();
  }

  List<dynamic> get productSizes => _productSizes;

  set productSizes(List<dynamic> newSizes) {
    _productSizes = newSizes;
    notifyListeners();
  }

  void toggleCheck(int index) {
    if (index >= 0 && index < _productSizes.length) {
      _productSizes[index]['isSelected'] = !_productSizes[index]['isSelected'];
    }
  }

  List<String> get sizes => _sizes;

  set sizes(List<String> newSizes) {
    _sizes = newSizes;
    notifyListeners();
  }

  late Future<List<Product>> male;
  late Future<List<Product>> female;
  late Future<List<Product>> kids;

  void getMale() {
    male = Helper().getMaleProducts();
  }

  void getFemale() {
    female = Helper().getFemaleProducts();
  }

  void getKids() {
    kids = Helper().getKidsProducts();
  }

  late Future<Product> product;

  void getProduct(String category, id) {
    if (category == "Men's Running") {
      product = Helper().getMaleProductsById(id);
    } else if (category == "Women's Running") {
      product = Helper().getFemaleProductsById(id);
    } else {
      product = Helper().getMaleProductsById(id);
    }
  }
}
