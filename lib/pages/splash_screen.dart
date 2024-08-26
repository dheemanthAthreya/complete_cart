import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'getotp.dart'; // Import your get_opt.dart file

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds before navigating to the home page
    Timer(Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Register()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
          'https://lottie.host/d64020a9-15b2-4deb-8ced-cfcba261db85/hSgsr2eDTk.json',
          onLoaded: (composition) {
            // Lottie animation has been loaded, start the animation
            // This function will be called once the animation is loaded
            // You can add additional logic here if needed
          },
        ),
      ),
    );
  }
}
