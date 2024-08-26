import 'package:flutter/material.dart';

class HomePagex extends StatelessWidget {
  const HomePagex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ClickMart'),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.5,
            children: List.generate(
              data.length,
                  (index) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  child: Card(
                    child: Column(
                      children: [
                        Image.network(data[index]),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Product ${index + 1}'),
                        ),
                        Text('\$${100 * (index + 1)}'),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            child: const Text('Add to Cart'),
                            onPressed: () {
                              // Handle the button press here.
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Sample Data
const data = [
  "https://5.imimg.com/data5/SELLER/Default/2022/9/VK/FQ/EG/17769549/ap0015.jpeg",
  "https://5.imimg.com/data5/SELLER/Default/2022/9/RL/ZT/GR/17769549/bkt001-5347-1000x1000.jpeg",
  "https://5.imimg.com/data5/SELLER/Default/2022/9/TE/IH/KW/17769549/bkt00125-1000x1000.jpeg",
  "https://5.imimg.com/data5/SELLER/Default/2022/9/OZ/MM/UW/17769549/bkt0041--1000x1000.jpg"
];