import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/products_helper.dart';

class ProductNotifier extends ChangeNotifier {
  List<Map<String, dynamic>> _productSizes = [];
  List<String> _sizes = [];
  int _activePage = 0;

  int get activePage => _activePage;

  set activePage(int newIndex) {
    _activePage = newIndex;
    notifyListeners();
  }

  List<Map<String, dynamic>> get productSizes => _productSizes;

  set productSizes(List<Map<String, dynamic>> newSizes) {
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

  String getSelectedSize() {
    final selectedSize = _productSizes.firstWhere((size) => size['isSelected'], orElse: () => {});
    return selectedSize['size'] ?? ''; // Return an empty string if no size is selected
  }

  void clearSelectedSizes() {
    for (var i = 0; i < _productSizes.length; i++) {
      _productSizes[i]['isSelected'] = false;
    }
    notifyListeners();
  }

  late Future<List<Products>> male = Helper().getMaleProducts();
  late Future<List<Products>> female = Helper().getFemaleProducts();
  late Future<List<Products>> kids = Helper().getKidsProducts();

  void fetchProducts() {
    notifyListeners();
  }
}
