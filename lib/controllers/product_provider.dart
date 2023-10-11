import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/helper.dart';

class ProductNotifier extends ChangeNotifier {
  List<dynamic> _productSizes = [];
  List<String> _sizes = [];

  int _activePage = 0;

  int get activePage => _activePage;

  set activePage(int newIndex) {
    _activePage = newIndex;
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

  late Future<List<Products>> male;
  late Future<List<Products>> female;
  late Future<List<Products>> kids;

  void getMale() {
    male = Helper().getMaleProducts();
  }

  void getFemale() {
    female = Helper().getFemaleProducts();
  }

  void getKids() {
    kids = Helper().getKidsProducts();
  }

  Future<void> fetchProducts() async {
    notifyListeners();
  }
}
