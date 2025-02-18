import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:chatbot/screens/splashscreen.dart';
import 'package:chatbot/screens/dashboard.dart';

const apiKey = 'YOUR_API_KEY_HERE';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  // Initialize Gemini with your API key.
 // Gemini.initialize(apiKey: apiKey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}