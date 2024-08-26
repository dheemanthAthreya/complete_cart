import 'package:flash_cart/pages/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'categories.dart';
import 'cart_page.dart';
import 'grocery_item_title.dart';
import 'home_page.dart';
import 'package:flash_cart/pages/account_bottom_navigation_bar_item.dart' as AccountItem;

class Fruits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
          title: Text("Fruits",style: TextStyle(fontWeight: FontWeight.bold),),
          // actions: [
          //   IconButton(icon: Icon(Icons.search), onPressed: () {}),
          // ],
          elevation: 20.0,
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.white54,
        //   onPressed: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => CartPage(),
        //     ),
        //   ),
        //   // child: const Icon(Icons.shopping_cart),
        // ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 48),
              //
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 24.0),
              //   child: Text('Good morning,'),
              // ),
              //
              // const SizedBox(height: 4),
              //
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
              //   child: Text(
              //     "Let's order fresh items for you",
              //     style: TextStyle(
              //       fontSize: 36,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 24),
              //
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 24.0),
              //   child: Divider(),
              // ),

              const SizedBox(height: 24),

              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 24.0),
              //   child: Text(
              //     "Fruits",
              //     style: TextStyle(
              //       fontSize: 18,
              //     ),
              //   ),
              // ),

              Consumer<CartModel>(
                builder: (context, value, child) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.2,
                    ),
                    itemCount: value.shopItems.length,
                    itemBuilder: (context, index) {
                      return GroceryItemTile(
                        itemName: value.shopItems[index][0],
                        itemPrice: value.shopItems[index][1],
                        imagePath: value.shopItems[index][2],
                        color: value.shopItems[index][3],
                        onPressed: () =>
                            Provider.of<CartModel>(context, listen: false)
                                .addItemToCart(index),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: AccountItem.AccountBottomNavigationBarItem(), // Use AccountBottomNavigationBarItem
              label: 'Account',
            ),
          ],
          selectedItemColor: Color(0xff6c63ff),
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            switch (index) {
              case 0:
              // Handle home navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                break;
              case 1:
              // Handle explore navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
                break;
              case 3:
              // Handle account navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserDetails()), // Navigate to CartPage
                );
                break;
            }
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String icon;
  final List<ItemCard> items;

  const CategoryCard({required this.title, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SvgPicture.asset(icon, height: 60),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return items[index];
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<String> images;

  const ItemCard({required this.title, required this.items, required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          height: 500,
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items in each row
              childAspectRatio: 1.0, // Aspect ratio of the items
              mainAxisSpacing: 10.0, // Spacing between rows
              crossAxisSpacing: 10.0, // Spacing between items
            ),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(images[index], height: 50),
                    SizedBox(height: 10),
                    Text(items[index]),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}