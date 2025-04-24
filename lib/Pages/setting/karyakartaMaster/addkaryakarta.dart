import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rajneta/Utils/api_constants.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class Addkaryakarta extends StatefulWidget {
  final int userid;
  final String selectedLanguage;
  const Addkaryakarta({super.key, required this.userid, required this.selectedLanguage});

  @override
  State<Addkaryakarta> createState() => _AddkaryakartaState();
}

class _AddkaryakartaState extends State<Addkaryakarta> {
  final TextEditingController _karyakartaController = TextEditingController();
  // final RxList<String> _karyakarta = <String>[].obs;
  final RxList<Map<String, dynamic>> _karyakarta = <Map<String, dynamic>>[].obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchkaryakarta();
  }
  Future<void> addkaryakart(String addkaryakarta) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');

      if (token == null) {
        Get.snackbar('Error', 'User is not logged in');
        return;
      }

      // ✅ Correct API URL
      String apiUrl = "${ApiConstants.baseUrl}api/karyakarta-create-by-master";


      // 🔁 Request Body Setup
      Map<String, String> requestBody = {
        'user_id': widget.userid.toString(),
        'lang': widget.selectedLanguage.substring(0, 2).toLowerCase(),
      };

      if (widget.selectedLanguage.toLowerCase().contains('english')) {
        requestBody['karyakarta'] = addkaryakarta;
      } else if (widget.selectedLanguage.toLowerCase().contains('marathi')) {
        requestBody['karyakarta_mr'] = addkaryakarta;
      } else if (widget.selectedLanguage.toLowerCase().contains('hindi')) {
        requestBody['karyakarta_hi'] = addkaryakarta;
      }

      // 🪵 Debugging logs
      print('API URL: $apiUrl');
      print('Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _fetchkaryakarta();
        Get.snackbar("Success", "Address added successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.back();
      } else {
        // Try-catch JSON decode safely
        try {
          final responseData = jsonDecode(response.body);
          Get.snackbar('Error', responseData['message'] ?? 'Failed to add karyakarta');
        } catch (_) {
          Get.snackbar('Error', 'Unexpected server response');
        }
      }
    } catch (e) {
      print('Error is $e');
      Get.snackbar('Exception', 'Something went wrong: $e');
    }
  }
  Future<void>_fetchkaryakarta()async{
    try{
      SharedPreferences preferences=await SharedPreferences.getInstance();
      String? token=preferences.getString('auth_token');
      if(token==null){
        Get.snackbar('Error', 'User not Logined');
        return;
      }
      String apiUrl = "${ApiConstants.baseUrl}api/karyakarta-list-all-masters?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&user_id=${widget.userid}";

           final responce=await http.get(Uri.parse('$apiUrl'),
             headers: {
             'Authorization': 'Bearer $token',
               'Content-Type':'application/json',
             },
           );
           final responceData=jsonDecode(responce.body);
           if(responce.statusCode==200){
             if(responceData['karyakarta']!=null && responceData['karyakarta'] is List){
               _karyakarta.assignAll(List<Map<String,dynamic>>.from(responceData['karyakarta']));

             }else{
               _karyakarta.clear();
             }
           } else{
             Get.snackbar('Error', responceData['message'] ?? 'Faild to load data',backgroundColor: Colors.red);
           }
    }catch(e){
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
          Expanded(child: _buildKaryakarta())
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: AppColors.backgroundColor,
          ),
          backgroundColor: AppColors.secondaryColor,
          onPressed: () {

            _showBottomSheet(context);
          }),
    ));
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
            'Add Karyakarta',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ))
        ],
      ),
    );
  }

  Widget _buildKaryakarta() {
    return Obx(() => _karyakarta.isEmpty
        ? Center(
            child: Text(
              'No Karyakarta Yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: _karyakarta.length,
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
                  title: Text(_karyakarta[index]['karyakarta'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                ),
              );
            }));
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
                "Create New karyakarta",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _karyakartaController,
                decoration: InputDecoration(
                  labelText: 'karyakarta Name',
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
                 addkaryakart(_karyakartaController.text.trim());
                 Get.back();
                },
                child: Text(
                  "Add karyakarta",
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
}
