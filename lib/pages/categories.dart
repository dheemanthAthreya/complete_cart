import 'package:flash_cart/pages/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'fruits.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'package:flash_cart/pages/account_bottom_navigation_bar_item.dart' as AccountItem; // Import AccountBottomNavigationBarItem from account_bottom_navigation_bar_item.dart with a prefix





class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){},),
          title: Text("Categories",style: TextStyle(fontWeight: FontWeight.bold),),

          // actions: [
          //   IconButton(icon: Icon(Icons.search), onPressed: (){},),
          // ],
          elevation: 20.0,
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 3,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Fruits()), // Navigate to fruits.dart
                  );
                },
                child: CategoryCard(title: 'Vegetables', imagePath: 'categories/vegetables.svg'),
              ),

              // CategoryCard(title: 'Fruits', imagePath: 'categories/fruits.svg'),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Fruits()), // Navigate to fruits.dart
                  );
                },
                child: CategoryCard(title: 'Fruits', imagePath: 'categories/fruits.svg'),
              ),
              CategoryCard(title: 'Edible oil', imagePath: 'categories/oil.svg'),
              CategoryCard(title: 'Beverages', imagePath: 'categories/beverages.svg'),
              CategoryCard(title: 'Grocery', imagePath: 'categories/grocery.svg'),
              CategoryCard(title: 'Babycare', imagePath: 'categories/babycare.svg'),
              CategoryCard(title: 'Hygiene', imagePath: 'categories/hygiene.svg'),
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
            switch(index) {
              case 0:
              // Handle home navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to CartPage
                );
                break;
              case 1:
              // Handle explore navigation
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()), // Navigate to CartPage
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
      // debugShowCheckedModeBanner: false,
      );

  }
}

Future<String> getImageUrl(String imagePath) async {
  final ref = firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
  final url = await ref.getDownloadURL();
  return url;
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath; // Replace 'icon' with 'imagePath'

  const CategoryCard({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageUrl(imagePath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AspectRatio(
            aspectRatio: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.network(snapshot.data as String, height: 60),
                SizedBox(height: 10),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        } else {
          return AspectRatio(
            aspectRatio: 1,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
