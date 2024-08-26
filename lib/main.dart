import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flash_cart/pages/cart_page.dart';
// import 'package:flash_cart/pages/fruit_model.dart';
import 'package:flash_cart/pages/fruits.dart';
import 'package:flash_cart/pages/home.dart';
import 'package:flash_cart/pages/home_page.dart';
import 'package:flash_cart/pages/payment.dart';
import 'package:flash_cart/pages/splash_screen.dart';
import 'package:flash_cart/pages/user_profile_photo_provider.dart';
import 'package:flash_cart/pages/vegetable.dart';
// import 'package:flash_cart/pages/enterotp.dart';
import 'package:flash_cart/pages/categories.dart';
// import 'package:flash_cart/pages/fruits.dart';
import 'package:flutter/material.dart';
import 'package:flash_cart/pages/getotp.dart';
import 'models/fruit_model.dart';
import 'pages/cart_model.dart';
import 'pages/vege_model.dart';
import 'package:provider/provider.dart';
// import 'pages/splash_screen.dart';
import 'pages/user_details.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => VegeModel()),
        ChangeNotifierProvider(create: (context) => UserProfilePhotoProvider()),
        // ChangeNotifierProvider(create: (context) => FruitModel()),
      ],
        child: MaterialApp(
        title: 'Flutter OTP Verification',
        debugShowCheckedModeBanner: false,
        home: Splash(),
        // home: PaymentInit(
        //   passedVals: {},
        // ),
        //   home:UserDetails(),
        // home: HomePagex(),
      // home: Register(),
      // home: Otp(),
      // home: Categories(),
      // home: Fruits(),
      // home: HomePage(),
      // home:CartPage(),
      //     home: Vegetables(),
        ),
    );
  }
}


// import 'package:flutter/material.dart'; upi_india: ^3.0.1
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Null Check Operator Error')),
//         body: MyList(),
//       ),
//     );
//   }
// }
//
// class MyList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//                 (BuildContext context, int index) {
//               return ListTile(
//                 title: Text('Item $index'),
//               );
//             },
//             childCount: 10,
//           ),
//         ),
//       ],
//     );
//   }
// }