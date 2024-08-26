import 'package:flutter/material.dart';

// Define a generic model interface
abstract class ProductModel {
  void addItemToCart(int index);
  void removeItemFromCart(int index);
  String calculateTotal();
// Add other methods as needed
}

class VegeModel extends ChangeNotifier implements ProductModel {
  // list of items on sale
  final List<List<dynamic>> _shopItems = const [
    // [ itemName, itemPrice, imagePath, color ]
    ["Cucumber", "1.00", "assets/cucumber.png", Colors.blue],
    ["Tomato", "4.00", "assets/tomato.png", Colors.green],
    ["Carrot", "2.50", "assets/ooty_carrot.png", Colors.yellow],
    ["Potato", "12.80", "assets/potato.png", Colors.brown],
    ["Cabbage", "4.00", "assets/cabbage.png", Colors.green],
    ["Green Peas", "2.50", "assets/greenpeas.png", Colors.yellow],
    ["Garlic", "2.50", "assets/garli.png", Colors.blue],
    ["Cauliflower", "1.00", "assets/caauliflower.png", Colors.yellow],
  ];

  // Map to store cart items and their quantities
  final Map<List<dynamic>, int> _cartItems = {};

  List<List<dynamic>> get cartItems => _cartItems.keys.toList();

  List<List<dynamic>> get shopItems => _shopItems;

  // add item to cart or increment quantity if already in cart
  @override
  void addItemToCart(int index) {
    final item = _shopItems[index];
    if (_cartItems.containsKey(item)) {
      _cartItems[item] = _cartItems[item]! + 1; // Increment quantity
    } else {
      _cartItems[item] = 1; // Add item to cart with quantity 1
    }
    notifyListeners();
  }

  // remove item from cart
  @override
  void removeItemFromCart(int index) {
    final item = _cartItems.keys.toList()[index];
    _cartItems.remove(item);
    notifyListeners();
  }

  @override
  void increaseQuantityAtIndex(int index) {
    final item = _cartItems.keys.toList()[index];
    _cartItems[item] = _cartItems[item]! + 1;
    notifyListeners();
  }

  @override
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
  @override
  String calculateTotal() {
    double totalPrice = 0;
    _cartItems.forEach((item, quantity) {
      totalPrice += double.parse(item[1].toString()) * quantity;
    });
    return totalPrice.toStringAsFixed(2);
  }

  // Get quantity of a specific item in the cart
  @override
  int getQuantityAtIndex(int index) {
    final item = _cartItems.keys.toList()[index];
    return _cartItems[item]!;
  }
}
