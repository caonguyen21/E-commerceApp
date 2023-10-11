import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class CartProvider with ChangeNotifier {
  final _cartBox = Hive.box('cart_box');
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  int countUniqueIds() {
    Set<String> uniqueIds = Set<String>();

    for (var item in _cart) {
      String id = item['id'];
      uniqueIds.add(id);
    }

    return uniqueIds.length;
  }

  void loadCartData() {
    final cartData = _cartBox.keys.map((key) {
      final item = _cartBox.get(key);
      return {
        "key": key,
        "id": item['id'],
        "category": item['category'],
        "name": item['name'],
        "price": item['price'],
        "qty": item['qty'],
        "sizes": item['sizes'],
        "imageUrl": item['imageUrl'],
      };
    }).toList();
    _cart = cartData.reversed.toList();
    // Don't notify listeners here
  }

  Future<void> createCart(Map<String, dynamic> newCart) async {
    await _cartBox.add(newCart);
  }

  Future<void> deleteCart(int key) async {
    await _cartBox.delete(key);
    notifyListeners(); // Notify listeners after deleting an item
  }

  void incrementQuantity(int index) {
    _cart[index]['qty']++;
    updateCartItem(index);
  }

  void decrementQuantity(int index) {
    if (_cart[index]['qty'] > 1) {
      _cart[index]['qty']--;
      updateCartItem(index);
    }
  }

  void updateCartItem(int index) {
    _cart[index]['totalPrice'] =
        calculateTotalPrice(_cart[index]['price'], _cart[index]['qty']);
    _cartBox.put(_cart[index]['key'], _cart[index]);
    notifyListeners(); // Notify listeners after updating an item
  }

  String calculateTotalPrice(String price, int qty) {
    double priceNumeric = double.parse(price.replaceAll('\$', ''));
    double totalPrice = priceNumeric * qty;
    return '\$${totalPrice.toStringAsFixed(2)}';
  }
}
