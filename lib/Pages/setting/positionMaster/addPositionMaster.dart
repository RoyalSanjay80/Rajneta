import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:rajneta/Utils/api_constants.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Addposition extends StatefulWidget {
  final int userId;
  final String selectedlanguage;
  const Addposition(
      {super.key, required this.userId, required this.selectedlanguage});

  @override
  State<Addposition> createState() => _AddpositionState();
}

class _AddpositionState extends State<Addposition> {
  final TextEditingController _positionMasterController =
      TextEditingController();
  final RxList<Map<String, dynamic>> _position = <Map<String, dynamic>>[].obs;
  @override
  void initState() {
    super.initState();
    _fetchkaryakarta();
  }

  Future<void> addpostion(String addpostion) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        Get.snackbar('Message', 'User is Not Login');
      }
      String apiUrl = "${ApiConstants.baseUrl}api/position-create-by-master";
      Map<String, String> requestBody = {
        'user_id': widget.userId.toString(),
        'lang': widget.selectedlanguage.substring(0, 2).toLowerCase()
      };
      if (widget.selectedlanguage.toLowerCase().contains('english')) {
        requestBody['position'] = addpostion;
      } else if (widget.selectedlanguage.toLowerCase().contains('marathi')) {
        requestBody['position_mr'] = addpostion;
      } else if (widget.selectedlanguage.toLowerCase().contains('hindi')) {
        requestBody['position_hi'] = addpostion;
      }
      print('API URL $apiUrl');
      print('Request Body: ${jsonEncode(requestBody)}');
      final responce = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      print('Responce Code: ${responce.statusCode}');
      print('Responce Body: ${responce.body}');

      if (responce.statusCode == 200) {
        _fetchkaryakarta();
        Get.snackbar('Success', 'Address added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.back();
      } else {
        try {
          final responseData = jsonDecode(responce.body);
          Get.snackbar(
              'Error', responseData['message'] ?? 'faild to add Postion');
        } catch (e) {
          Get.snackbar('Error', 'Unexpected server response');
        }
      }
    } catch (e) {
      print('Error is $e');
    }
  }

  Future<void> _fetchkaryakarta() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        Get.snackbar('Error', 'User not Logined');
        return;
      }
      String apiUrl =
          "${ApiConstants.baseUrl}api/position-list-all-masters?lang=${widget.selectedlanguage.substring(0, 2).toLowerCase()}&user_id=${widget.userId}";

      final responce = await http.get(
        Uri.parse('$apiUrl'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final responceData = jsonDecode(responce.body);
      if (responce.statusCode == 200) {
        if (responceData['position'] != null &&
            responceData['position'] is List) {
          _position.assignAll(
              List<Map<String, dynamic>>.from(responceData['position']));
        } else {
          _position.clear();
        }
      } else {
        Get.snackbar('Error', responceData['message'] ?? 'Faild to load data',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(
              height: 10,
            ),
            Expanded(child: _buildPosition())
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.secondaryColor,
            child: Icon(
              Icons.add,
              color: AppColors.backgroundColor,
            ),
            onPressed: () {
              _showBottomSheet(context);
            }),
      ),
    );
  }

  Widget _buildHeader() {
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
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            'Position Master',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
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
                "Create New Position",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _positionMasterController,
                decoration: InputDecoration(
                  labelText: 'Position Name',
                  prefixIcon: Icon(Icons.home, color: AppColors.secondaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.secondaryColor, width: 2),
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
                  String societyName = _positionMasterController.text.trim();
                  addpostion(societyName);
                  Get.back();
                },
                child: Text(
                  "Add Position",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPosition() {
    return Obx(() => _position.isEmpty
        ? Center(
            child: Text(
              'No Position yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: _position.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: AppColors.secondaryColor,
                  ),
                  title: Text(
                    _position[index]['position'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }));
  }
}
