import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/api_constants.dart';
import '../../../Utils/colors.dart';

class AddSocietyPage extends StatefulWidget {
  final int userid;
  final String selectedLanguage;

  const AddSocietyPage({
    Key? key,
    required this.userid,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  State<AddSocietyPage> createState() => _AddSocietyPageState();
}

class _AddSocietyPageState extends State<AddSocietyPage> {
  final TextEditingController _societyNameController = TextEditingController();
  final RxList<Map<String, dynamic>> _societies = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    _fetchSocieties();
  }

  Future<void> _fetchSocieties() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        Get.snackbar("Error", "User not authenticated!",
            backgroundColor: Colors.red);
        return;
      }

      String apiUrl =
          "${ApiConstants.baseUrl}api/society-lists-all-masters?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&user_id=${widget.userid}";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _societies.assignAll(
            List<Map<String, dynamic>>.from(responseData['society']));
      } else {
        Get.snackbar(
            "Error", responseData['message'] ?? "Failed to fetch societies.",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          backgroundColor: Colors.red);
    }
  }

  Future<void> _addSociety(String societyName) async {
    if (societyName.isEmpty) {
      Get.snackbar("Error", "Society name cannot be empty",
          backgroundColor: Colors.red);
      return;
    }

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        Get.snackbar("Error", "User not authenticated!",
            backgroundColor: Colors.red);
        return;
      }

      const String apiUrl =
          "${ApiConstants.baseUrl}api/society-create-by-master";
      Map<String, String> requestBody = {
        "user_id": widget.userid.toString(),
        "lang": widget.selectedLanguage.substring(0, 2).toLowerCase(),

      };
      if (widget.selectedLanguage.toLowerCase().contains('english')) {
        requestBody['society'] = societyName;
      } else if (widget.selectedLanguage.toLowerCase().contains('marathi')) {
        requestBody['society_mr'] = societyName;
      } else if (widget.selectedLanguage.toLowerCase().contains('hindi')) {
        requestBody['society_hi'] = societyName;
      }


      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _fetchSocieties();
        Get.snackbar("Success", "Society added successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.back();
      } else {
        Get.snackbar(
            "Error", responseData['message'] ?? "Failed to add society.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 10),
            Expanded(child: _buildSocietyList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.secondaryColor,
          child: Icon(Icons.add, color: AppColors.backgroundColor),
          onPressed: () => _showBottomSheet(context),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))
        ],
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
              'Add Society',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocietyList() {
    return Obx(() => _societies.isEmpty
        ? Center(
            child: Text("No societies added yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey)))
        : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: _societies.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.home, color: AppColors.secondaryColor),
                  title: Text(_societies[index]['society'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              );
            },
          ));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Create New Society",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor)),
              SizedBox(height: 15),
              TextField(
                controller: _societyNameController,
                decoration: InputDecoration(
                    labelText: 'Society Name',
                    prefixIcon:
                        Icon(Icons.home, color: AppColors.secondaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    _addSociety(_societyNameController.text.trim());
                    Get.back();
                  },
                  child: Text("Add Society")),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
