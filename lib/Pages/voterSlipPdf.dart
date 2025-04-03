import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utils/colors.dart';

class Voterslippdf extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;
  const Voterslippdf(
      {super.key, required this.itemName, required this.selectedLanguage});

  @override
  State<Voterslippdf> createState() => _VoterslippdfState();
}

class _VoterslippdfState extends State<Voterslippdf> {
  final TextEditingController a3PageController =
  TextEditingController(text: "1"); // Default value 1
  final TextEditingController dataController =
  TextEditingController(text: "1000"); // Default value 1000
  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;

  double imageSize = 100; // Default image size

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(screenWidth),
              const SizedBox(height: 40),

              _buildExportButton("Create Voter Slip"),
              const SizedBox(height: 40),
              _buildInputRow("Records From", a3PageController, "To",
                  dataController, screenWidth),
              const SizedBox(height: 10),
              _bulidChekBox(
                value: isChecked,
                onChanged: (onChanged) {
                  setState(() {
                    isChecked = onChanged!;
                    isChecked1 = false; // Uncheck others
                    isChecked2 = false;
                    imageSize = 200; // Set size for 4 voters on 1 page
                  });
                },
                lable1: "4 voter on 1 page",
              ),
              _bulidChekBox(
                value: isChecked1,
                onChanged: (onChanged) {
                  setState(() {
                    isChecked1 = onChanged!;
                    isChecked = false; // Uncheck others
                    isChecked2 = false;
                    imageSize = 250; // Set size for 6 voters on 1 page
                  });
                },
                lable1: "6 voter on 1 page",
              ),
              _bulidChekBox(
                value: isChecked2,
                onChanged: (onChanged) {
                  setState(() {
                    isChecked2 = onChanged!;
                    isChecked = false; // Uncheck others
                    isChecked1 = false;
                    imageSize = 300; // Set size for 8 voters on 1 page
                  });
                },
                lable1: "8 voter on 1 page",
              ),
              const SizedBox(height: 10),
              Image.asset(
                "assets/voterslip.png",
                width: imageSize,
                height: imageSize,
              ),
              Text(
                "Size:${(imageSize / 37.795).toStringAsFixed(1)} cm x ${(imageSize / 37.795).toStringAsFixed(1)} cm",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              _buildExportButton("CHANGE SIP HEADER")
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      height: screenWidth * 0.2,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.itemName.tr,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(String text) {
    return MaterialButton(
      onPressed: () {
        // Add your export functionality here
      },
      color: AppColors.secondaryColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.white),
          const SizedBox(width: 8),
          Text("$text",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInputRow(
      String label1,
      TextEditingController controller1,
      String label2,
      TextEditingController controller2,
      double screenWidth,
      ) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label1,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildInputField(controller1, "$label1", screenWidth),
          ),
          const SizedBox(width: 20),
          Text(
            label2,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildInputField(controller2, "Enter $label2", screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String hint, double screenWidth) {

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
  }

  Widget _bulidChekBox(
      {required bool value,
        required ValueChanged<bool?> onChanged,
        required String lable1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          checkColor: Colors.white,
          activeColor: Colors.deepOrangeAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        Text(
          lable1,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
