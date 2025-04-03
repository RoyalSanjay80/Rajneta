import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/colors.dart';
import 'package:http/http.dart'as http; // Import the controller

class TeramAndCondtionPage extends StatefulWidget {
  const TeramAndCondtionPage({super.key});

  @override
  State<TeramAndCondtionPage> createState() => _TeramAndCondtionPageState();
}

class _TeramAndCondtionPageState extends State<TeramAndCondtionPage> {
  final TermsController termsController = Get.put(TermsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (termsController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(
                      termsController.termsText.value,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}



class TermsController extends GetxController {
  var isLoading = true.obs;
  var termsText = ''.obs;

  @override
  void onInit() {
    fetchTermsConditions();
    super.onInit();
  }

  void fetchTermsConditions() async {
    try {
      final response = await http.get(Uri.parse("https://rajneta.fusiontechlab.site/api/terms-condition"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        termsText.value = data["termsCondition"][0]["terms_condition_text"] ?? "No terms available.";
      } else {
        termsText.value = "Failed to load terms.";
      }
    } catch (e) {
      termsText.value = "An error occurred.";
    } finally {
      isLoading.value = false;
    }
  }
}

