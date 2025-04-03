import 'package:flutter/material.dart';
import 'package:rajneta/Pages/loginPage.dart';
import 'package:rajneta/Pages/registrationController.dart';
import 'package:rajneta/Utils/colors.dart';
 // Import the controller

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController middlenameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();

  final RegistrationController registrationController = RegistrationController();

  bool _termsAccepted = false;

  @override
  void dispose() {
    firstnameController.dispose();
    middlenameController.dispose();
    lastnameController.dispose();
    mobileNumberController.dispose();
    emailIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenSize.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.1),
            Center(
              child: Text(
                "Fill Your Details",
                style: TextStyle(
                  fontSize: screenSize.width * 0.08,
                  color: AppColors.backgroundColor,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  textFormField(
                      hintText: 'First Name', controller: firstnameController),
                  SizedBox(height: screenSize.height * 0.02),
                  textFormField(
                      hintText: 'Middle Name',
                      controller: middlenameController),
                  SizedBox(height: screenSize.height * 0.02),
                  textFormField(
                      hintText: 'Last Name', controller: lastnameController),
                  SizedBox(height: screenSize.height * 0.02),
                  textFormField(
                      hintText: 'Mobile Number',
                      controller: mobileNumberController),
                  SizedBox(height: screenSize.height * 0.02),
                  textFormField(
                      hintText: 'Email ID', controller: emailIdController),
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
                    width: screenSize.width * 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: AppColors.backgroundColor,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_termsAccepted) {
                            final result = await registrationController.registerUser(
                              firstname: firstnameController.text.trim(),
                              middlename: middlenameController.text.trim(),
                              lastname: lastnameController.text.trim(),
                              mobileNumber: mobileNumberController.text.trim(),
                              email: emailIdController.text.trim(),
                            );

                            // Show the result in a SnackBar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result)),
                            );

                            // Navigate if the result indicates success
                            if (result == "success") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Loginpage()),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please accept the Terms and Conditions')),
                            );
                          }
                        }
                      },

                      child: Text('Submit'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: AppColors.backgroundColor,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Loginpage(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textFormField(
      {required String hintText, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: hintText,
        hintText: "Type your text here",
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}
