import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/colors.dart';
import 'package:http/http.dart' as http;
import 'LocalizationService.dart';
import 'advanceSearchlist.dart';

class Advancescrech extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  const Advancescrech({super.key, required this.itemName, required this.selectedLanguage});

  @override
  _AdvancescrechState createState() => _AdvancescrechState();
}

class _AdvancescrechState extends State<Advancescrech> {
  late final SearchController searchController;

  @override
  void initState() {
    super.initState();
    LocalizationService().changeLocale(widget.selectedLanguage);
    searchController = Get.put(SearchController());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Obx(() {
          return Column(
            children: [
              // Header Container
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.itemName.tr,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        textFormFieldCard(hintText: 'Surname'.tr, onChanged: (value) {
                          searchController.updateFormData(surname: value);
                        }),
                        SizedBox(height: screenSize.height * 0.01),
                        textFormFieldCard(hintText: 'First Name'.tr, onChanged: (value) {
                          searchController.updateFormData(firstName: value);
                        }),
                        SizedBox(height: screenSize.height * 0.01),
                        textFormFieldCard(hintText: 'Middle Name'.tr, onChanged: (value) {
                          searchController.updateFormData(middleName: value);
                        }),
                        SizedBox(height: screenSize.height * 0.01),
                        textFormFieldCard(hintText: 'From Age'.tr, onChanged: (value) {
                          searchController.updateFormData(fromAge: value);
                        }),
                        SizedBox(height: screenSize.height * 0.01),
                        textFormFieldCard(hintText: 'To Age'.tr, onChanged: (value) {
                          searchController.updateFormData(toAge: value);
                        }),
                        SizedBox(height: screenSize.height * 0.01),
                        textFormFieldCard(hintText: 'Mobile No'.tr, onChanged: (value) {
                          searchController.updateFormData(mobileNo: value);
                        }),
                        SizedBox(height: screenSize.height * 0.01),
                        textFormFieldCard(hintText: 'Part No'.tr, onChanged: (value) {
                          searchController.updateFormData(partNo: value);
                        }),
                        SizedBox(height: screenSize.height * 0.01),
                        textFormFieldCard(hintText: 'Voter Id'.tr, onChanged: (value) {
                          searchController.updateFormData(voterId: value);
                        }),
                        SizedBox(height: screenSize.height * 0.01),
                        textFormFieldCard(hintText: 'House No'.tr, onChanged: (value) {
                          searchController.updateFormData(houseNo: value);
                        }),
                        SizedBox(height: screenSize.height * 0.01),
                        // Save Button
                        ElevatedButton(
                          onPressed: () async {
                            if (searchController.formData.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please enter at least one value",
                                snackPosition: SnackPosition.TOP,
                              );
                              return;
                            }

                            searchController.setLoading(true);

                            final lang = widget.selectedLanguage.substring(0, 2).toLowerCase();
                            final response = await fetchData(searchController.formData, lang);

                            searchController.setLoading(false);

                            if (response != null && response.isNotEmpty) {
                              // Navigate to the result screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Advancesearchlist(
                                    itemName: 'advanced_search',
                                    selectedLanguage: widget.selectedLanguage,
                                    formData: searchController.formData,
                                    apiResponse: response,
                                  ),
                                ),
                              );
                            } else {
                              // If response is empty, reset form data
                              searchController.formData.clear();
                              // Get.snackbar(
                              //   "No Results",
                              //   "No data found for the given search criteria. Form has been reset.",
                              //   snackPosition: SnackPosition.TOP,
                              // );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: AppColors.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save'.tr,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),

                        SizedBox(height: 10),
                        // Reset Button

                      ],
                    ),
                  ),
                ),
              ),
              if (searchController.isLoading.value)
                Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget textFormFieldCard({
    required String hintText,
    required Function(String) onChanged,
  }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: TextFormField(
          onChanged: onChanged,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: TextStyle(color: Colors.black),
            hintText: "Type your text here".tr,
            hintStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> fetchData(Map<String, String> formData, String lang) async {
    String url = 'https://rajneta.fusiontechlab.site/api/advance-search?lang=$lang';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    formData.forEach((key, value) {
      url += '&$key=${Uri.encodeComponent(value)}';
    });

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        Get.snackbar("Error", "Not found data", snackPosition: SnackPosition.TOP,colorText: Colors.white);
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please check your internet connection.", snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }
}

class SearchController extends GetxController {
  var isLoading = false.obs;
  var formData = <String, String>{}.obs;

  void updateFormData({
    String? surname,
    String? firstName,
    String? middleName,
    String? fromAge,
    String? toAge,
    String? mobileNo,
    String? partNo,
    String? voterId,
    String? houseNo,
  }) {
    formData.clear(); // Clear existing data

    if (surname != null && surname.isNotEmpty) formData['surname'] = surname;
    if (firstName != null && firstName.isNotEmpty) formData['first_name'] = firstName;
    if (middleName != null && middleName.isNotEmpty) formData['middle_name'] = middleName;
    if (fromAge != null && fromAge.isNotEmpty) formData['from_age'] = fromAge;
    if (toAge != null && toAge.isNotEmpty) formData['to_age'] = toAge;
    if (mobileNo != null && mobileNo.isNotEmpty) formData['mobile_1'] = mobileNo;
    if (partNo != null && partNo.isNotEmpty) formData['part_no'] = partNo;
    if (voterId != null && voterId.isNotEmpty) formData['voter_id'] = voterId;
    if (houseNo != null && houseNo.isNotEmpty) formData['house_no'] = houseNo;
  }

  void setLoading(bool loading) {
    isLoading.value = loading;
  }
}
