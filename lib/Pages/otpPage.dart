import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rajneta/Pages/landingPage.dart';
import 'package:rajneta/Utils/colors.dart';

class OTPVerificationPage extends StatefulWidget {
  final String mobileNumber;
  final String email;

  const OTPVerificationPage({Key? key, required this.mobileNumber,required this.email}) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isResendEnabled = false;
  bool isLoading = false;

  // Function to verify OTP via API
  Future<void> verifyOTP() async {
    final String otp = otpController.text.trim();
    final String phone = widget.mobileNumber;
    final String email = widget.email;

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final Uri apiUrl = Uri.parse("https://rajneta.fusiontechlab.site/api/otp-verification");
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'email': email,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final responseBody = jsonDecode(response.body);

          if (responseBody['status'] == 200) {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LandingPage()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP Verified!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseBody['message'] ?? 'Verification failed.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unexpected response from the server.')),
          );
        }
      } else {
        // Handle non-200 HTTP responses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP. Error code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP Check the OTP')),
      );
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
      ),
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenSize.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Verification Code",
                style: TextStyle(
                  fontSize: screenSize.width * 0.08,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backgroundColor,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                "Enter the OTP sent to:- +91 ${widget.mobileNumber}",
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  color: AppColors.backgroundColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenSize.height * 0.05),
              Form(
                key: _formKey,
                child: PinCodeTextField(
                  controller: otpController,
                  appContext: context,
                  length: 4,
                  onChanged: (value) {},
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.width * 0.05,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    activeColor: AppColors.secondaryColor,
                    inactiveColor: AppColors.backgroundColor.withOpacity(0.3),
                    selectedColor: AppColors.secondaryColor,
                    activeFillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: screenSize.height * 0.05),
              // Verify OTP Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.02, horizontal: screenSize.width * 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: isLoading ? null : verifyOTP,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Verify OTP',
                  style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.white),
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),

              // Resend OTP
              Text(
                "Didn't receive the OTP?",
                style: TextStyle(color: AppColors.backgroundColor, fontSize: 16),
              ),
              TextButton(
                onPressed: isResendEnabled
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('OTP Resent!')),
                  );
                }
                    : null,
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: isResendEnabled
                        ? AppColors.secondaryColor
                        : AppColors.backgroundColor.withOpacity(0.5),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
