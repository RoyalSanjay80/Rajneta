import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:rajneta/subcontroller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:rajneta/Pages/voterDetailPage.dart';
import '../../../Utils/api_constants.dart';
import '../../../Utils/colors.dart';
import '../../LocalizationService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class ByAge extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  ByAge({Key? key, required this.itemName, required this.selectedLanguage})
      : super(key: key);

  @override
  _ByAgeState createState() => _ByAgeState();
}

class _ByAgeState extends State<ByAge> {
  List<bool> _showMoreIcons = [];
  // BlueThermalPrinter printer = BlueThermalPrinter.instance;
  // List<BluetoothDevice> devices = [];
  List<Map<String, String>> votersData = [];
  bool isLoading = true;
  String query = '';
  Subcontroller controller=Get.put(Subcontroller());

  @override
  void initState() {
    super.initState();
    LocalizationService().changeLocale(widget.selectedLanguage);
    // _getBluetoothDevices();
    // Automatically show the dialog on page load
    Future.delayed(Duration.zero, () {
      _showAgeRangeDialog();
    });
  }

  void _showAgeRangeDialog() {
    TextEditingController fromAgeController = TextEditingController();
    TextEditingController toAgeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Age Range"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fromAgeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "From Age"),
              ),
              TextField(
                controller: toAgeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "To Age"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                int fromAge = int.tryParse(fromAgeController.text) ?? 0;
                int toAge = int.tryParse(toAgeController.text) ?? 100;
                if (fromAge <= 0 || toAge <= 0) {
                  print('Invalid age input'); // Debug print
                  return;
                }
                fetchData(fromAge, toAge);
                Navigator.pop(context); // Close dialog after fetching data
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchData(int fromAge, int toAge) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) throw Exception('auth token is not found');

      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/search-age-group?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&from_age=$fromAge&to_age=$toAge'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("API Response: $data"); // Debug print

        if (data['voters'] is List) {
          setState(() {

            votersData =
                List<Map<String, String>>.from(data['voters'].map((item) {
              return {
                'name': item['voter_details']['first_name']?.toString() ?? 'null', // Ensure it's a String
                'details': item['voter_details']['id']?.toString() ?? 'null', // Ensure it's a String
              };
            }));
            isLoading = false;
          });
        } else {
          print("Data format issue");
          throw Exception('Unexpected API response structure');
        }
      } else {
        print("API Error: ${response.statusCode}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Future<void> _getBluetoothDevices() async {
  //   devices = await printer.getBondedDevices();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildSearchField(),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : _buildVotersList(),
          ],
        ),
        floatingActionButton: _buildFABs(),
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
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.itemName.tr,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3))
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search Voters',
            border: InputBorder.none,
            suffixIcon: Icon(Icons.mic, color: AppColors.secondaryColor),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildVotersList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: votersData.length,
        itemBuilder: (context, index) {
          final voter = votersData[index];
          return Column(
            children: [
              _buildVoterCard(voter, index),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVoterCard(Map<String, String> voter, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoterDetailPage(
              voterName: voter['name']!,
              voterDetails: voter['details']!,
              selectedLanguage: widget.selectedLanguage,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voter['name']!,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text(
                      voter['details'] ?? 'No details available',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: AppColors.secondaryColor,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildFABs() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: 'exportFAB',
          onPressed: () {
            controller.generateExcel(context,
                votersData.map((item)=>item['name']?? 'null').toList(),
                votersData.map((item)=>item['details']?? 'null').toList(),
                widget.itemName.tr,
                'Total'.tr);
          },
          icon: Icon(Icons.share),
          label: Text("Export"),
          backgroundColor: AppColors.secondaryColor,
        ),
        SizedBox(height: 8),
        FloatingActionButton.extended(
          heroTag: 'reportFAB',
          onPressed: () {
            controller.generatePDF(context,
                votersData.map((item)=>item['name']?? 'null').toList(),
                votersData.map((item)=>item['details']?? 'null').toList(),
                widget.itemName.tr,
                'Total'.tr);
          },
          icon: Icon(Icons.picture_as_pdf),
          label: Text("Report"),
          backgroundColor: AppColors.secondaryColor,
        ),
      ],
    );
  }
}
