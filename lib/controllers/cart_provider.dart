import 'dart:core';

import 'package:flutter/cupertino.dart';

import '../models/cart/get_products.dart';

class CartProvider with ChangeNotifier {
  final Set<int> _selectedIndices = <int>{};
  List<Product> _checkout = [];

  List<Product> get checkout => _checkout;

  set setCheckoutList(List<Product> newSate) {
    _checkout = newSate;
    notifyListeners();
  }

  Set<int> get selectedIndices => _selectedIndices;

  void toggleSelection(int index) {
    if (_selectedIndices.contains(index)) {
      _selectedIndices.remove(index);
    } else {
      _selectedIndices.add(index);
    }
    notifyListeners();
  }

  double calculateTotalPrice(List<Product> cartData) {
    double totalPrice = 0.0;

    for (int index in _selectedIndices) {
      if (index >= 0 && index < cartData.length) {
        Product product = cartData[index];
        double productPrice = double.tryParse(product.cartItem.price) ?? 0.0;
        totalPrice += productPrice * product.quantity;
      }
    }

    return totalPrice;
  }
}
