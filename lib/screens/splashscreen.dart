import 'package:chatbot/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // Set background to white
      body: Center(
        child: Image.asset(
          'assets/logo.jpeg',  // Path to your logo image
          width: 250,  // Adjust size as needed
          height: 250,  // Adjust size as needed
        ),
      ),
    );
  }
}
