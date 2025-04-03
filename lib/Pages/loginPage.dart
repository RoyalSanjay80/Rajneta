import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rajneta/Pages/registrationPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/colors.dart';
import '../Utils/contss.dart';
import 'otpPage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  bool _termsAccepted = false;

  Future<void> loginuesr() async {
    final String phone = mobileNumberController.text.trim();
    final String email = emailIdController.text.trim();
    if (phone.isEmpty && email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter either a phone number or email')),
      );
      return;
    }
    try {
      final Uri apiUrl = Uri.parse(BaseUrl + Login);
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone.isNotEmpty ? phone : null,
          'email': email.isNotEmpty ? email : null,
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('Response Body: $responseBody');
        if (responseBody['status'] == 200) {
          String token = responseBody['token'] ?? ''; // Extract token
          if (token.isNotEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token); // Store token
            print('Token stored: $token'); // Debug message
          } else {
            print('Token is empty or null.');
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(
                mobileNumber: phone,
                email: email,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody['message'] ?? 'Login failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please try again later. Check the details entered.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    emailIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset:
          true, // Allows resizing when the keyboard appears
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenSize.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.1),
            Center(
              child: Text(
                "Authorization",
                style: TextStyle(
                    fontSize: screenSize.width * 0.08,
                    color: AppColors.backgroundColor),
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Mobile Number field
                  textFormField(
                    hintText: 'Mobile Number',
                    controller: mobileNumberController,
                    inputType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    "Or",
                    style: TextStyle(
                        color: AppColors.backgroundColor, fontSize: 20),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  // Email field
                  textFormField(
                    hintText: 'Email ID',
                    controller: emailIdController,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CheckboxListTile(
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    title: const Text(
                      "I accept the Terms and Conditions",
                      style: TextStyle(color: Colors.white),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                  ),

                  SizedBox(height: screenSize.height * 0.04),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: AppColors.backgroundColor,
                      ),
                      onPressed: () {
                        if (_termsAccepted) {
                          loginuesr();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please accept the Terms and Conditions')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: AppColors.backgroundColor,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegistrationPage()),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textFormField({
    required String hintText,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white70),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
      ),
    );
  }
}
