import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rajneta/subcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/api_constants.dart';
import '../../../Utils/colors.dart';
import '../../LocalizationService.dart';
import 'package:http/http.dart' as http;
import 'byExtraInfo1.dart';

class AllExtraInfo1 extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  AllExtraInfo1(
      {Key? key, required this.itemName, required this.selectedLanguage})
      : super(key: key);

  @override
  _AllExtraInfo1State createState() => _AllExtraInfo1State();
}

class _AllExtraInfo1State extends State<AllExtraInfo1> {
  bool isLoading = true;
  List<Map<String, String>> votersData = [];
  Subcontroller controller = Get.put(Subcontroller());
  String query = '';

  @override
  void initState() {
    super.initState();
    LocalizationService().changeLocale(widget.selectedLanguage);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) throw Exception('auth token is not found');
      setState(() {
        isLoading = true;
      });
      final responce = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/extra-information-one-list?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        if (data['extra_information_ones_details'] is List) {
          setState(() {
            votersData = List<Map<String, String>>.from(
                (data['extra_information_ones_details'].map((item) => {
                      'name':
                          item['extra_information_one']?.toString() ?? 'null',
                      'details':
                          item['extra_information_one_count']?.toString() ??
                              'null',
                    })));
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected Api Responce');
        }
      } else {
        throw Exception('faild to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('err is $e');
    }
  }

  Future<void> searchData(String query) async {
    if (query.isEmpty) {
      fetchData();
      return;
    }
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) throw Exception('Auth token is not found');

      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/search-extra-information-one?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&extra_info_1=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['extra_info_one_voters'] is List) {
          setState(() {
            votersData = List<Map<String, String>>.from(
              (data['extra_info_one_voters'] as List).map((item) {
                return {
                  'name': item['extra_info_one']?.toString() ?? 'Unknown',
                  'details': item['total_voters']?.toString() ?? '0',
                };
              }),
            );
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected API Response');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
            searchData(query);
          },
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
            builder: (context) => Byextrainfo1(
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
                    controller.showOptionsDialog(
                        context, widget.itemName, widget.selectedLanguage);
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
          onPressed: () {
            controller.generateExcel(
                context,
                votersData.map((item) => item['name'] ?? 'Null').toList(),
                votersData.map((item) => item['details'] ?? 'Null').toList(),
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
              votersData.map((item)=>item['name']?? 'Null').toList(),
              votersData.map((item)=>item['details'] ?? 'Null').toList(),
              widget.itemName.tr,
              "Total".tr
          );
          },
          icon: Icon(Icons.picture_as_pdf),
          label: Text("Report"),
          backgroundColor: AppColors.secondaryColor,
        ),
      ],
    );
  }
}
