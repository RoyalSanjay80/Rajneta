import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rajneta/Utils/api_constants.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

class Addaddress extends StatefulWidget {
  final int userid;
  final String selectedLanguage;
  const Addaddress({super.key, required this.userid, required this. selectedLanguage});

  @override
  State<Addaddress> createState() => _AddaddressState();
}

class _AddaddressState extends State<Addaddress> {
  final TextEditingController _societyNameController = TextEditingController();
  final RxList<Map<String, dynamic>> _societies = <Map<String, dynamic>>[].obs;
  @override
  void initState() {
    super.initState();
    _fetchSocieties();
  }
  Future<void> _addAddress(String addressName) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      const String apiUrl = "${ApiConstants.baseUrl}api/address-create-by-master";

      // Determine the correct key based on the selected language
      Map<String, String> requestBody = {
        'user_id': widget.userid.toString(),
        'lang': widget.selectedLanguage.substring(0, 2).toLowerCase(),
      };

      if (widget.selectedLanguage.toLowerCase().contains('english')) {
        requestBody['address'] = addressName;
      } else if (widget.selectedLanguage.toLowerCase().contains('marathi')) {
        requestBody['address_mr'] = addressName;
      } else if (widget.selectedLanguage.toLowerCase().contains('hindi')) {
        requestBody['address_hi'] = addressName;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": 'application/json',
        },
        body: jsonEncode(requestBody),

      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _fetchSocieties();
        Get.snackbar("Success", "Address added successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.back();

      } else {
        Get.snackbar("Error", responseData['message'] ?? "Failed to add address.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('Error: $e');
    }
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
          "${ApiConstants.baseUrl}api/address-list-all-masters?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&user_id=${widget.userid}";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['address'] != null && responseData['address'] is List) {
          _societies.assignAll(List<Map<String, dynamic>>.from(responseData['address']));
        } else {
          _societies.clear();
        }
      } else {
        Get.snackbar("Error", responseData['message'] ?? "Failed to fetch societies.",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", backgroundColor: Colors.red);
      print(e);
    }
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        children: [
          _buildHeade(),
          SizedBox(height: 10,),
          Expanded(child: _buildAddress())

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor,
          child: Icon(Icons.add,color: AppColors.backgroundColor,),
          onPressed: (){
            _showBottomSheet(context);
      }),
    ));
  }

  Widget _buildHeade() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            'Add Address',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ))
        ],
      ),
    );
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Create New Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _societyNameController,
                decoration: InputDecoration(
                  labelText: 'Address Name',
                  prefixIcon: Icon(Icons.home, color: AppColors.secondaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.secondaryColor, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _addAddress(_societyNameController.text.trim());
                  Get.back();

                },
                child: Text(
                  "Add Address",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
  Widget _buildAddress(){
    return Obx(()=> _societies.isEmpty
    ? Center(
      child: Text('No Address added yet',style: TextStyle(
        fontSize: 16,color: Colors.grey
      ),),
    )
        : ListView.builder(
          itemCount: _societies.length,
        itemBuilder: (context ,index){
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               elevation: 3,
              child: ListTile(
                leading: Icon(Icons.home,color: AppColors.secondaryColor,),
                title: Text(_societies[index]['address'],style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                // trailing: IconButton(onPressed: (){
                //   _societies.removeAt(index);
                //   Get.snackbar('Deleted', 'Address Delete Successfully',
                //   backgroundColor: Colors.red,
                //     snackPosition: SnackPosition.BOTTOM
                //   );
                // },
                //     icon: Icon(Icons.delete,color: Colors.red,)),
              ),
            );

    })
    );
  }
}
