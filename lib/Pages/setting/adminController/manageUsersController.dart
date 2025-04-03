import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/api_constants.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var userList = <dynamic>[].obs;
  var userList1 = <dynamic>[].obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
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
        Uri.parse("${ApiConstants.baseUrl}api/app-user-list"), // Ensure the correct URL
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['appusers'] != null && data['appusers'].isNotEmpty) {
          userList.value = data['appusers'];
        }
        else {
          print("No users found in API response");
          userList.value = [];
        }
      } else {
        print("Failed to fetch users. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserPermission(String userId, int value) async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        Get.snackbar("Error", "User token not found. Please login again.");
        return;
      }

      String apiUrl = "${ApiConstants.baseUrl}api/give-user-master-permission";

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "user_id": userId,
          "society_master": value,
        }),
      );


      if (response.statusCode == 200) {
        Get.snackbar("Success", "Permission updated successfully");
        print(response.body);
      } else {
        Get.snackbar("Error", "Failed to update permission");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }


}
