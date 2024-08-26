import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'order_placed_page.dart'; // Import OrderPlacedPage

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
                          String username = await _showUsernameDialog(context);
                          if (username.isNotEmpty) {
                            String orderId = await _sendOrderEmail(context, value, username);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderPlacedPage(orderId: orderId),
                              ),
                            );
                          }
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

  Future<String> _sendOrderEmail(BuildContext context, CartModel value, String username) async {
    String orderId = _generateOrderId();
    String items = value.cartItems.map((item) => '${item[0]} (Qty: ${value.getQuantityAtIndex(value.cartItems.indexOf(item))})').join(', ');
    String emailBody = 'Order ID: $orderId\nUsername: $username\nItems: $items\nTotal Price: \₹${value.calculateTotal()}';

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

  Future<String> _showUsernameDialog(BuildContext context) async {
    String username = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Enter your username'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Username"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                username = controller.text;
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
    return username;
  }

  String _generateOrderId() {
    return DateTime.now().millisecondsSinceEpoch.toString(); // Simple order ID based on timestamp
  }
}
