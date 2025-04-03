import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../../../Utils/api_constants.dart';
import '../../../Utils/colors.dart';
import '../../../subcontroller.dart';
import '../../LocalizationService.dart';
import 'package:http/http.dart' as http;
import 'byPartNo.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';

class AllPartNo extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  AllPartNo({Key? key, required this.itemName, required this.selectedLanguage})
      : super(key: key);

  @override
  _AllPartNoState createState() => _AllPartNoState();
}

class _AllPartNoState extends State<AllPartNo> {
  final Subcontroller controller = Get.put(Subcontroller());
  List<Map<String, String>> votersData = [];
  bool isLoading = true;
  String query = "";

  @override
  void initState() {
    super.initState();
    _getBluetoothDevices();
    fetchVotersData();
    LocalizationService().changeLocale(widget.selectedLanguage);


  }

  Future<void> fetchVotersData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token not found');

      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}api/partno-list?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['part_nos'] is List) {
          setState(() {
            votersData = List<Map<String, String>>.from(
              data['part_nos'].map((item) => {
                    'name': item['part_no']?.toString() ?? 'No name available',
                    'details': item['total_voters']?.toString() ??
                        'No voters available',
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
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> searchVoters(String query) async {
    if (query.isEmpty) {
      fetchVotersData();
      return;
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token not found');

      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}api/search-partno?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&part_no=$query',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          votersData = List<Map<String, String>>.from(
            data['part_nos'].map((item) => {
                  'name': item['part_no']?.toString() ?? 'No name available',
                  'details':
                      item['total_voters']?.toString() ?? 'No voters available',
                }),
          );
          isLoading = false;
        });
      } else {
        throw Exception('Failed to search voters');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> _getBluetoothDevices() async {
    // devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 10),
            _buildSearchField(),
            SizedBox(height: 4),
            isLoading ? CircularProgressIndicator() : _buildVotersList(),
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
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Voters',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.secondaryColor),
        ),
        onChanged: (value) {
          query = value;
          searchVoters(query);
        },
      ),
    );
  }

  Widget _buildVotersList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: votersData.length, // Use state-managed votersData
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
            builder: (context) => Bypartno(
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
                      voter['details']!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.menu, color: AppColors.secondaryColor),
                onPressed: () {
                  // _showOptionsDialog();
                  controller.showOptionsDialog(
                      context, widget.itemName, widget.selectedLanguage);
                }, // Add functionality as needed
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
          onPressed: () {
            Get.snackbar('Export', 'Data export initiated!');
            controller.generateExcel(
                context,
                votersData.map((voter) => voter['name'] ?? 'null').toList(),
                votersData.map((voter) => voter['details'] ?? 'null').toList(),
                widget.itemName.tr,
                'Total'.tr);
          },
          icon: Icon(Icons.share),
          label: Text("Excle"),
          backgroundColor: AppColors.secondaryColor,
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
          onPressed: () async {
            Get.snackbar('Report', 'Report generation initiated!');
            print('sanjay$votersData');
            // await _generatePDF();
            controller.generatePDF(
              context,
              votersData.map((voter) => voter['name'] ?? 'Unknown').toList(),
              votersData.map((voter) => voter['details'] ?? '0').toList(),
             widget.itemName.tr,
              ' Total'.tr,
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
