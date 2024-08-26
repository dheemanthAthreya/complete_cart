import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'order_placed_page.dart'; // Import OrderPlacedPage
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
      ),
      body: Consumer<CartModel>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "My Cart",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: value.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = value.cartItems[index];
                      final totalPrice = double.parse(item[1].toString()) *
                          value.getQuantityAtIndex(index);
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          leading: Image.asset(item[2], height: 36),
                          title: Text(item[0], style: const TextStyle(fontSize: 18)),
                          subtitle: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  value.decreaseQuantityAtIndex(index);
                                },
                              ),
                              Text('${value.getQuantityAtIndex(index)}', style: const TextStyle(fontSize: 12)),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  value.increaseQuantityAtIndex(index);
                                },
                              ),
                            ],
                          ),
                          trailing: Text('\₹${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Price', style: TextStyle(color: Colors.green[200])),
                          const SizedBox(height: 8),
                          Text('\₹${value.calculateTotal()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _validateAndPlaceOrder(context, value);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green.shade200),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: const [
                              Text('Confirm', style: TextStyle(color: Colors.white)),
                              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        selectedItemColor: Color(0xff6c63ff),
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          // Navigation logic here
        },
      ),
    );
  }

  Future<Map<String, int>> _fetchItemQuantities() async {
    final itemQuantities = <String, int>{};
    final querySnapshot = await FirebaseFirestore.instance.collection('items').get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final itemName = data['itemName'] as String;
      final quantity = data['quantity'] as int;
      itemQuantities[itemName] = quantity;
    }

    return itemQuantities;
  }

  Future<void> _validateAndPlaceOrder(BuildContext context, CartModel value) async {
    final itemQuantities = await _fetchItemQuantities();
    final itemQuantitiesExceeded = <String, int>{};

    // Check for quantity exceedances
    for (var item in value.cartItems) {
      final itemName = item[0];
      final requestedQuantity = value.getQuantityAtIndex(value.cartItems.indexOf(item));
      final availableQuantity = itemQuantities[itemName] ?? 0;

      if (requestedQuantity > availableQuantity) {
        itemQuantitiesExceeded[itemName] = requestedQuantity - availableQuantity;
      }
    }

    if (itemQuantitiesExceeded.isNotEmpty) {
      _showQuantityExceededDialog(context, itemQuantitiesExceeded);
    } else {
      // Proceed with placing the order
      String orderId = await _sendOrderEmail(context, value);
      await _updateFirestoreQuantities(value);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPlacedPage(orderId: orderId),
        ),
      );
    }
  }

  void _showQuantityExceededDialog(BuildContext context, Map<String, int> itemQuantitiesExceeded) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quantity Exceeded'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: itemQuantitiesExceeded.entries.map((entry) {
              return Text('${entry.key}: Exceeds by ${entry.value}');
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateFirestoreQuantities(CartModel value) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var item in value.cartItems) {
      final itemName = item[0];
      final requestedQuantity = value.getQuantityAtIndex(value.cartItems.indexOf(item));

      // Fetch the document reference
      final querySnapshot = await FirebaseFirestore.instance.collection('items')
          .where('itemName', isEqualTo: itemName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final itemRef = doc.reference;

        final currentQuantity = doc.data()['quantity'] as int;
        final newQuantity = currentQuantity - requestedQuantity;

        if (newQuantity >= 0) {
          batch.update(itemRef, {'quantity': newQuantity});
        }
      }
    }

    await batch.commit();
  }

  Future<String> _sendOrderEmail(BuildContext context, CartModel value) async {
    String orderId = _generateOrderId();
    String items = value.cartItems.map((item) => '${item[0]} (Qty: ${value.getQuantityAtIndex(value.cartItems.indexOf(item))})').join(', ');
    String emailBody = 'Order ID: $orderId\nUsername: <username>\nItems: $items\nTotal Price: \₹${value.calculateTotal()}';

    // Set up the SMTP server
    String usernameEmail = 'dheemanth.g.athreya@gmail.com'; // Your email
    String password = 'mbklslcyrpkfuqte'; // Your App Password
    final smtpServer = gmail(usernameEmail, password); // Use Gmail SMTP server

    // Create the email message
    final message = Message()
      ..from = Address(usernameEmail, 'Complete Cart') // Your name
      ..recipients.add('dheemanthga.cs22@bmsce.ac.in') // Shopkeeper's email
      ..subject = 'Order Confirmation - $orderId'
      ..text = emailBody;

    try {
      // Send the email
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return orderId; // Return the order ID to display it
    } catch (e) {
      print('Message not sent. $e');
      return orderId; // Return the order ID even if the email fails to send
    }
  }

  String _generateOrderId() {
    return DateTime.now().millisecondsSinceEpoch.toString(); // Simple order ID based on timestamp
  }
}
