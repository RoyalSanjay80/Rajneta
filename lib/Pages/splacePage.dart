import 'package:flutter/material.dart';
import 'package:rajneta/Pages/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'landingPage.dart';
 // Replace with your actual login page

class Splacepage extends StatefulWidget {
  const Splacepage({super.key});

  @override
  State<Splacepage> createState() => _SplacepageState();
}

class _SplacepageState extends State<Splacepage> {

  // Function to check if user is logged in
  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');  // Retrieve the token

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()), // Replace with your actual landing page
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()), // Replace with your actual login page
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery se screen size le rahe hain
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Full screen image
          Image.asset(
            'assets/Election_app_banner.png', // Yahan apne image ka path daalein
            fit: BoxFit.cover,
            width: screenWidth, // MediaQuery ka istemal
            height: screenHeight, // MediaQuery ka istemal
          ),

        ],
      ),
    );
  }
}
