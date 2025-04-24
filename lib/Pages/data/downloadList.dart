import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/colors.dart';

class DownloadListScreen extends StatefulWidget {
  final String selectedLanguage;

  DownloadListScreen({super.key, required this.selectedLanguage});

  @override
  State<DownloadListScreen> createState() => _DownloadListScreenState();
}

class _DownloadListScreenState extends State<DownloadListScreen> {
  List<dynamic> items1 = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    fetchDownload();
  }

  Future<void> fetchDownload() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      final langCode = widget.selectedLanguage.substring(0, 2).toLowerCase();

      final response = await http.get(
        Uri.parse('https://rajneta.fusiontechlab.site/api/all-partno-download-list?lang=$langCode'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 200 && data['voters'] != null && data['voters'] is List) {
          setState(() {
            items1 = (data['voters'] as List).map((item) {
              item['downloaded'] = false; // Default downloaded status
              return item;
            }).toList();
            isloading = false;
          });
        } else {
          Get.snackbar('Error', 'Invalid response format or empty list');
          setState(() => isloading = false);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch data from server');
        setState(() => isloading = false);
      }
    } catch (e) {
      print('Exception while fetching data: $e');
      Get.snackbar('Error', 'Something went wrong');
      setState(() => isloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black54,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text('START DOWNLOAD'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Text(
                'Your Service Has Been Expired, Please Contact Us For Update',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: 'All',
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(),
                        labelText: 'Assembly',
                      ),
                      items: ['All'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: 'All',
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(),
                        labelText: 'Village',
                      ),
                      items: ['All'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isloading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: EdgeInsets.only(top: 16),
                itemCount: items1.length,
                itemBuilder: (context, index) {
                  var item = items1[index];
                  return ListTile(
                    leading: Icon(Icons.play_arrow, color: Colors.deepOrange),
                    title: Text(item['part_no'].toString().trim()),
                    trailing: (item['downloaded'] ?? false)
                        ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Downloaded',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Download',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
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
              "Download List",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
