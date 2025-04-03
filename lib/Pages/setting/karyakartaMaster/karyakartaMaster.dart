import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/api_constants.dart';
import '../../../Utils/colors.dart';
import '../addressMaster/addAddress.dart';
import '../adminController/manageUsersController.dart';
import '../societyMaster/addSocietypage.dart';
import 'addkaryakarta.dart';



class Karyakartamaster extends StatefulWidget {
  final String selectedLanguage;
  Karyakartamaster({Key? key, required this.selectedLanguage}) : super(key: key);
  @override
  _KaryakartamasterState createState() => _KaryakartamasterState();
}


class _KaryakartamasterState extends State<Karyakartamaster> {
  final UserController userController = Get.put(UserController());
  // var userList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  List<dynamic> userList=[];

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch user list on screen load
  }
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        print("No token found in SharedPreferences");
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}api/app-user-list"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userList = data['appusers'] ?? [];
      }
      else if (response.statusCode == 403) {
        Navigator.pop(context);
        Get.snackbar(
          "You are not an admin",
          "Access Denied",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Navigator.pop(context);
      }
      else {
        print("Failed to fetch users: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (userList.isEmpty) {
                  return Center(
                    child: Text(
                      "No users found",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    var user = userList[index];
                    return _buildUserCard(user);
                  },
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
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'karyakarta Master',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          "${user['first_name'] ?? ''} ${user['middle_name'] ?? ''} ${user['surname'] ?? ''}".trim(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email'] ?? 'No Email', style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 4),
            Text(user['phone'] ?? 'No Mobile Number', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondaryColor,
          radius: 24,
          child: Text(
            user['first_name']?[0]?.toUpperCase() ?? '?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            _assignPermission(user['id'], value);
          },
          itemBuilder: (context) => [
            _buildMenuItem('Karyakarta Master', 'karyakarta_master'),
          ],
          icon: Icon(Icons.more_vert, color: Colors.grey[700]),

        ),
        onTap: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context) => Addkaryakarta(),));
          if (user['master_permission']?['karyakarta_master'] == 1) {
            Get.to(() => Addkaryakarta());
          } else {
            Get.snackbar(
              "Access Denied",
              "This user does not have karyakarta_master permission",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String title, String key) {
    return PopupMenuItem(
      value: key,
      child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  void _assignPermission(int userId, String permissionKey) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        Get.snackbar("Error", "User token not found. Please login again.");
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}api/give-user-master-permission'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "user_id": userId,
          permissionKey: 1,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Permission assigned successfully",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.secondaryColor, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to assign permission",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
