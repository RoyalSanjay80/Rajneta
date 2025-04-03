import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rajneta/Pages/loginPage.dart';
import 'package:rajneta/Pages/setting/settingsPage.dart';
import 'package:rajneta/Pages/survey/surveymain.dart';
import 'package:rajneta/subcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../Utils/colors.dart';
import 'Search/ItemDetailsPage.dart';
import 'LocalizationService.dart';
import 'package:get/get.dart';

import 'advance Screch.dart';
import 'data/datapage.dart';
import 'List/listpage.dart';
import 'package:http/http.dart'as http;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String selectedLanguage = LocalizationService.langs[0];
  Subcontroller controller=Get.put(Subcontroller());
  Map<String, String> userData = {};

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    fetchuser();


  }

  // Load the language preference from SharedPreferences
  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedLanguage = prefs.getString('selectedLanguage');
    if (storedLanguage != null) {
      setState(() {
        selectedLanguage = storedLanguage;
      });
      LocalizationService().changeLocale(selectedLanguage);
    }
  }

  // Save the selected language to SharedPreferences
  Future<void> _saveLanguagePreference(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // AppBar with language selection
              Container(
                height: screenHeight * 0.15,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu icon with onTap functionality
                    InkWell(
                      onTap: (){
                      showFullPageBottomSheet(context);
                      },
                      child: Image.asset(
                        'assets/logo/menuicon.png',
                        color: Colors.white,
                        height: screenHeight * 0.05,
                      ),
                    ),

                    // Title Text
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                        child: Text(
                          "Rajneta",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Language selection dropdown
                    DropdownButton<String>(
                      dropdownColor: AppColors.secondaryColor,
                      icon: ImageIcon(
                        AssetImage('assets/logo/language.png'),
                        size: 30,
                        color: Colors.white,
                      ),
                      underline: SizedBox(), // Removes the underline
                      value: selectedLanguage,
                      items: LocalizationService.langs
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLanguage = newValue!;
                        });
                        // Save the new selected language
                        _saveLanguagePreference(selectedLanguage);
                        LocalizationService().changeLocale(selectedLanguage);
                      },
                    ),
                  ],
                ),
              ),
              // Remaining UI (search images, settings, etc.)
              SizedBox(height: screenHeight * 0.01),
              // Remaining UI (search images, settings, etc.)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to ItemDetailPage on tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailPage(
                              itemName: 'search',
                              selectedLanguage: selectedLanguage, // Pass the selected language
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/search_360.png",
                            width: screenWidth * 0.45,
                          ),
                          Positioned(
                            bottom: 10,
                            child: Text(
                              'search'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to ItemDetailPage on tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Advancescrech(
                              itemName: 'advanced_search',
                              selectedLanguage: selectedLanguage, // Pass the selected language
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/advanced-search_360.png",
                            width: screenWidth * 0.45,
                          ),
                          Positioned(
                            bottom: 10,
                            child: Text(
                              'advanced_search'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to ItemDetailPage on tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListPage(
                              itemName: 'list',
                              selectedLanguage: selectedLanguage, // Pass the selected language
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/lists_360.png",
                            width: screenWidth * 0.45,
                          ),
                          Positioned(
                            bottom: 10,
                            child: Text(
                              'list'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to ItemDetailPage on tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Survey(
                              itemName: 'survey',
                              selectedLanguage: selectedLanguage, // Pass the selected language
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/survey_360.png",
                            width: screenWidth * 0.45,
                          ),
                          Positioned(
                            bottom: 10,
                            child: Text(
                              'survey'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to ItemDetailPage on tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DataPage(
                              itemName: 'data',
                              selectedLanguage: selectedLanguage, // Pass the selected language
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/data_360.png",
                            width: screenWidth * 0.45,
                          ),
                          Positioned(
                            bottom: 10,
                            child: Text(
                              'data'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to ItemDetailPage on tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingPage(
                              itemName: 'setting',
                              selectedLanguage: selectedLanguage, // Pass the selected language
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/setting_360.png",
                            width: screenWidth * 0.45,
                          ),
                          Positioned(
                            bottom: 10,
                            child: Text(
                              'setting'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Center(
                  child: Text("Shirur - Assembly (Applied 166121 v1)For Support - 9921116541",style: TextStyle(
                      color: AppColors.backgroundColor,
                      fontSize: 14
                  ),),
                ),
              ),
              Container(
                height: screenHeight * 0.10,
                width: screenWidth,// 15% of screen height
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30), // Round corners for the container
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(

                  children: [
                    Text("Rajneta Election Software",style: TextStyle(
                        color: AppColors.secondaryColor
                    ),),
                    Text("( rajnetaeclection.com )"),

                  ],
                ),

              )
              // Continue with the rest of the layout...
            ],
          ),
        ),
      ),
    );
  }


  Widget buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.3),
            highlightColor: Colors.grey.withOpacity(0.1),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 10,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 60,
                          height: 10,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  void showFullPageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Enables full-screen behavior
      backgroundColor: Colors.transparent, // Transparent to allow custom design
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height, // Full-screen height
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Background.png'),
              fit: BoxFit.cover, // Ensures the background image covers the screen
            ),
            color: Colors.black.withOpacity(0.8), // Add overlay for better readability
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close ButtonT


                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(); // Close the bottom sheet
                        },
                        child: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // App Logo
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/applogo.png',
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Rajneta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),

                        Text('Name: ${userData.isNotEmpty ? userData['name'] : 'No Name'}', style: TextStyle(fontSize: 18, color: Colors.white)),
                        Text('Email: ${userData.isNotEmpty ? userData['email'] : 'No Email'}', style: TextStyle(fontSize: 18, color: Colors.white)),

                      ],
                    ),
                  ),
                  SizedBox(height: 40),

                  // Menu Options
                  menuOption(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () {
                      // Add logout logic here
                      logoutUser();
                    },
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.white.withOpacity(0.5), thickness: 1),
                  SizedBox(height: 20),
                  menuOption(
                    icon: Icons.delete,
                    text: 'Delete Account',
                    onTap: () {
                      // Add delete account logic here
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                      Text('Successfully Deleted Account')));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Menu Option Widget
  Widget menuOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logoutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token is null. User is not authenticated.');
      }

      final response = await http.post(
        Uri.parse('https://rajneta.fusiontechlab.site/api/logout'), // Corrected URL
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Successfully logged out
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginpage()), // Replace with your actual login page
        );
      } else {
        throw Exception('Logout failed. Server response: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }



  Future<void> fetchuser() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');

      final response = await http.get(
        Uri.parse('https://rajneta.fusiontechlab.site/api/all-login-user-list'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Store the user data directly in the userData map
        userData = {
          'name': data['login_users']['first_name']?.toString() ?? 'null',
          'email': data['login_users']['email']?.toString() ?? 'null',
        };
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

}




