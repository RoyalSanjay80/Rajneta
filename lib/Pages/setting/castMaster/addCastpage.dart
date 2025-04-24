import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../../../Utils/api_constants.dart';

class AddCast extends StatefulWidget {
  final int userid;
  final String selectedLanguage;
  const AddCast({super.key, required this.userid, required this. selectedLanguage});

  @override
  State<AddCast> createState() => _AddCastState();
}

class _AddCastState extends State<AddCast> {
  final TextEditingController castController = TextEditingController();
  // final RxList<String> _Cast = <String>[].obs;
  final RxList<Map<String, dynamic>> _Cast = <Map<String, dynamic>>[].obs;
  @override
  void initState() {
    super.initState();
    fetchData();
  }
 Future<void>addCast(String addcast)async{
    try{
      SharedPreferences preferences= await SharedPreferences.getInstance();
      String? token=preferences.getString('auth_token');
      if(token==null){
        Get.snackbar('Error', 'User is not Logged in');
        return;
      }

      String apiUrl = "${ApiConstants.baseUrl}api/caste-create-by-master";
       Map<String,String> requestBody={
         'user_id':widget.userid.toString(),
         'lang':widget.selectedLanguage.substring(0,2).toLowerCase(),
       };
       if(widget.selectedLanguage.toLowerCase().contains('english')){
         requestBody['caste']=addcast;
       }else if(widget.selectedLanguage.toLowerCase().contains('marathi')){
         requestBody['caste_mr']=addcast;
       }else if(widget.selectedLanguage.toLowerCase().contains('hindi')){
         requestBody['caste_hi']=addcast;
       }
       print('Api URl: $apiUrl');
       print('Request Body: ${jsonEncode(requestBody)}');

       final responce=await http.post(Uri.parse(apiUrl),
         headers: {
         'Authorization':'Bearer $token',
           'Content-Type': 'application/json',
         },
         body: jsonEncode(requestBody),
       );
       print('Responce Code ${responce.statusCode}');
       print('Response Body: ${responce.body}');
       if(responce.statusCode==200){
         fetchData();
         Get.snackbar('Success', 'Address Added successfully!',
         backgroundColor: Colors.green,colorText: Colors.white
         );
         Get.back();
       } else {
         try{
          final responceData=jsonDecode(responce.body);
          Get.snackbar('error', responceData['message']?? 'faild to addCast');
         }catch(_){
           Get.snackbar('error', 'Unexpected server responce');
         }
       }
    }catch(e){
      print('Error is $e');
      Get.snackbar('Exception', 'Something wente worng: $e');
    }
 }
 Future<void>fetchData()async{
    try{
      SharedPreferences preferences=await SharedPreferences.getInstance();
      String? token=preferences.getString('auth_token');
      if(token==null){
        Get.snackbar('Error', 'User not Logined');
        return;
      }
      String apiUrl='${ApiConstants.baseUrl}api/caste-list-all-masters?lang=${widget.selectedLanguage.substring(0,2).toLowerCase()}&user_id=${widget.userid}';
      final responce=await http.get(Uri.parse('$apiUrl'),
        headers: {
          'Authorization':'Bearer $token',
          'Content-Type':'application/json',
        },
      );
      final responceData=jsonDecode(responce.body);
      if(responce.statusCode==200){
        if(responceData['caste']!=null && responceData['caste']is List){
          _Cast.assignAll(List<Map<String,dynamic>>.from(responceData['caste']));
        }else{
          _Cast.clear();
        }
      }else{
        Get.snackbar('Error', 'Faild to load Data');
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
              Expanded(child: _buildCast())
            ],
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: AppColors.secondaryColor,
              ),
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
                'Add Cast',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
              ))
        ],
      ),
    );
  }

  Widget _buildCast() {
    return Obx(() => _Cast.isEmpty
        ? Center(
      child: Text(
        'No Cast Yet',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    )
        : ListView.builder(
        itemCount: _Cast.length,
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
                _Cast[index]['caste'],
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
                "Create New Cast",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: castController,
                decoration: InputDecoration(
                  labelText: 'Cast Name',
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
                 addCast(castController.text.trim());
                 Get.back();
                },
                child: Text(
                  "Add Cast",
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
