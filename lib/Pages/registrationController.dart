import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Utils/contss.dart';

class RegistrationController {
  Future<String> registerUser({
    required String firstname,
    required String middlename,
    required String lastname,
    required String mobileNumber,
    required String email,
  }) async {
    try {
      final Uri apiUrl = Uri.parse(BaseUrl + register);
      final Map<String, dynamic> requestData = {
        "first_name": firstname,
        "middle_name": middlename,
        "surname": lastname,
        "phone": mobileNumber,
        "email": email,
      };

      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 200 &&
            responseBody['message'] == "User created successfully") {
          return "success";
          // Ensure this matches your UI condition
        } else {
          return responseBody['message'] ?? 'Unknown error occurred';
        }
      } else {
        return 'Failed to connect to server. Error code: ${response.statusCode}';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }
}
