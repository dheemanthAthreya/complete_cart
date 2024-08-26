import 'package:flutter/material.dart';

import '../pages/cart_model.dart';

class FruitModel extends ChangeNotifier implements ProductModel {
  // list of fruit items
  final List<List<dynamic>> _fruitItems = [
    // [ itemName, itemPrice, imagePath, color ]
    ["Watermelon", "1.00", "assets/desi_tomato.png", Colors.blue],
    ["Avocado", "4.00", "assets/desi_tomato.png", Colors.green],
    ["Banana", "2.50", "assets/desi_tomato.png", Colors.yellow],
    ["Mango", "12.80", "assets/desi_tomato.png", Colors.brown],
    ["Orange", "1.00", "assets/desi_tomato.png", Colors.blue],
  ];

  // Map to store cart items and their quantities
  final Map<List<dynamic>, int> _cartItems = {};

  List<List<dynamic>> get cartItems => _cartItems.keys.toList();

  List<List<dynamic>> get fruitItems => _fruitItems;

  // add item to cart or increment quantity if already in cart
  void addItemToCart(int index) {
    final item = _fruitItems[index];
    if (_cartItems.containsKey(item)) {
      _cartItems[item] = _cartItems[item]! + 1; // Increment quantity
    } else {
      _cartItems[item] = 1; // Add item to cart with quantity 1
    }
    notifyListeners();
  }

  // remove item from cart
  void removeItemFromCart(int index) {
    final item = _cartItems.keys.toList()[index];
    _cartItems.remove(item);
    notifyListeners();
  }

  void increaseQuantityAtIndex(int index) {
    final item = _cartItems.keys.toList()[index];
    _cartItems[item] = _cartItems[item]! + 1;
    notifyListeners();
  }

  void decreaseQuantityAtIndex(int index) {
    final item = _cartItems.keys.toList()[index];
    if (_cartItems[item]! > 1) {
      _cartItems[item] = _cartItems[item]! - 1;
    } else {
      _cartItems.remove(item); // Remove item from cart
    }
    notifyListeners();
  }

  // calculate total price
  String calculateTotal() {
    double totalPrice = 0;
    _cartItems.forEach((item, quantity) {
      totalPrice += double.parse(item[1].toString()) * quantity;
    });
    return totalPrice.toStringAsFixed(2);
  }

  // Get quantity of a specific item in the cart
  int getQuantityAtIndex(int index) {
    final item = _cartItems.keys.toList()[index];
    return _cartItems[item]!;
  }
}
