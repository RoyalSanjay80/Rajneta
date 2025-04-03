import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/colors.dart';

class Bulksurvey extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;
  const Bulksurvey({Key? key, required this.itemName, required this.selectedLanguage}) : super(key: key);


  @override
  State<Bulksurvey> createState() => _BulksurveyState();
}

class _BulksurveyState extends State<Bulksurvey> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(

      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(screenWidth),


          ],
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
}
