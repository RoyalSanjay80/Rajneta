import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:rajneta/Pages/voterDetailPage.dart';
import '../../../Utils/api_constants.dart';
import '../../../Utils/colors.dart';
import '../../../subcontroller.dart';
import '../../LocalizationService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;

import 'byMobileNo.dart';

class AllMobileNoList extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  AllMobileNoList(
      {Key? key, required this.itemName, required this.selectedLanguage})
      : super(key: key);

  @override
  _AllMobileNoListState createState() => _AllMobileNoListState();
}

class _AllMobileNoListState extends State<AllMobileNoList> {
  final Subcontroller contrller = Get.put(Subcontroller());
  List<Map<String, String>> votersData = [];
  bool isLoading = true;
  String query = '';

  @override
  void initState() {
    super.initState();
    fetchdata();
    LocalizationService().changeLocale(widget.selectedLanguage);
  }

  Future<void> fetchdata() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token is not found');

      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/mobile-no-list?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['mobile_no'] is List) {
          setState(() {
            votersData = List<Map<String, String>>.from(
              data['mobile_no'].map((item) => {
                    'name': item['mobile_no']?.toString() ??
                        'null', // If mobile_no is null, display 'null'
                    'details': item['voter_count']?.toString() ??
                        '0', // If voter_count is null, display '0'
                  }),
            );
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected API response structure');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> serachvoters(String query) async {
    if (query.isEmpty) {
      fetchdata();
      return;
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('auth token is not found');
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/search-mobile-no?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&mobile_1=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          votersData = List<Map<String, String>>.from(
            data['mobilenos'].map((item) => {
                  'name': item['mobile_1']?.toString() ??
                      'null', // If mobile_no is null, display 'null'
                  'details': item['voter_count']?.toString() ??
                      '0', // If voter_count is null, display '0'
                }),
          );
          isLoading = false;
        });
      } else {
        throw Exception('faild to serach voters');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('err is $e');
    }
  }

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
          onChanged: (value) {
            query = value;
            serachvoters(query);
          },
        ),
      ),
    );
  }

  Widget _buildVotersList() {
    return Expanded(
      child: votersData.isEmpty
        ? Center(
        child: Text('Data is Not Available'),
      )
      
      :ListView.builder(
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
            builder: (context) => Bymobileno(
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
          height: 70, // Adjusted height to accommodate the phone number
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
                      voter['details'] ?? 'No phone number available',
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
                  onPressed: () {
                    contrller.showOptionsDialog(context,
                        widget.itemName,
                        widget.selectedLanguage);
                  }),

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
          onPressed: (){
            contrller.generateExcel(context,
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
          onPressed: (){
            contrller.generatePDF(context,
                votersData.map((item)=>item['name']?? 'null').toList(),
                votersData.map((item)=>item['details'] ?? 'null').toList(),
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
