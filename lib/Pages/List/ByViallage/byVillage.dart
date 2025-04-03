import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:rajneta/Pages/List/ByPersonnel/allPersonnel.dart';
import 'package:rajneta/Pages/List/ByPosition/allPosition.dart';
import 'package:rajneta/Pages/List/By%20Bluetooth%20Slip%20Report%20By%20User/bluetoothSlipReportByUser.dart';
import 'package:rajneta/Pages/bulkSurvey.dart';

import 'package:rajneta/Pages/List/ByAge/allAgeList.dart';
import 'package:rajneta/Pages/List/ByCaste/AllCasteList.dart';
import 'package:rajneta/Pages/List/ColorCode/allColorCode.dart';
import 'package:rajneta/Pages/List/ByDead/allDead.dart';
import 'package:rajneta/Pages/List/ByGender/allGender.dart';
import 'package:rajneta/Pages/List/By%20House%20Number/allHouseNo.dart';
import 'package:rajneta/Pages/List/ByNewAddress/allNewAdderss.dart';
import 'package:rajneta/Pages/List/ByPartNumber/allPartNO.dart';

import 'package:rajneta/Pages/List/BySurname/allSuraname.dart';
import 'package:rajneta/Pages/List/By%20Taluka/allTaluka.dart';
import 'package:rajneta/Pages/List/By%20SurveyTeam/allSurveyTeam.dart';
import 'package:rajneta/Pages/List/ByVotingCenter/allvotingCenter.dart';
import 'package:rajneta/Pages/List/ByDemands%20List/allDemandsList.dart';
import 'package:rajneta/Pages/List/By%20Extra%20Check-1/allExtraChech1.dart';
import 'package:rajneta/Pages/List/ByExtraCheck2/allExtraCheck2.dart';
import 'package:rajneta/Pages/List/ExtraInfo1/allExtraInfo1.dart';
import 'package:rajneta/Pages/List/ExtraInfo2/allExtraInfo2.dart';
import 'package:rajneta/Pages/List/ExtraInfo3/allExtraInfo3.dart';
import 'package:rajneta/Pages/List/ExtraInfo4/allExtraInfo4.dart';
import 'package:rajneta/Pages/List/ExtraInfo5/allExtraInfo5.dart';

import 'package:rajneta/Pages/List/ByRepeated/allRepeated.dart';
import 'package:rajneta/Pages/List/By%20Slip%20Printer%20Report/slipPrintReport.dart';
import 'package:rajneta/Pages/List/ByStar%20Voter/allStareVoter.dart';
import 'package:rajneta/Pages/List/By%20Today%20Birthday/allTodayBirthday.dart';
import 'package:rajneta/Pages/List/By%20Voted/allVoted.dart';
import 'package:rajneta/Pages/voterSlipPdf.dart';
import 'package:rajneta/Pages/List/VoterWithoutMobileList/allVoterWithoutMobile.dart';
import 'package:rajneta/printController.dart';
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

import 'allVillageList.dart';
import '../AlphabeticalList/alphabeticalList.dart';
import '../../exportToPDF.dart';
import '../../exporttoExcel.dart';

class ByVillageList extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  ByVillageList({
    Key? key,
    required this.itemName,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  _ByVillageListState createState() => _ByVillageListState();
}

class _ByVillageListState extends State<ByVillageList> {
  final Subcontroller controller = Get.put(Subcontroller());
  List<bool> _showMoreIcons = [];
  // BlueThermalPrinter printer = BlueThermalPrinter.instance;
  // List<BluetoothDevice> devices = [];
  List<Map<String, String>> votersData = [];
  bool isLoading = true;
  String query = "";
  int? selectedIndexd;
  Printcontroller1 printController1=Get.put(Printcontroller1());

  @override
  void initState() {
    super.initState();
    // _getBluetoothDevices();
    LocalizationService().changeLocale(widget.selectedLanguage);
    fetchVotersData();
  }

  Future<void> fetchVotersData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token not found');

      setState(() => isLoading = true);

      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/village-list?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['villages'] is List) {
          setState(() {
            isLoading = false;
            votersData = List<Map<String, String>>.from(
                data['villages'].map((dynamic item) {
              return {
                'name': item['village']?.toString() ?? 'No name available',
                'details': item['total_villagers']?.toString() ?? 'No details available',
              };
            }).toList());
            _showMoreIcons =
                List.filled(votersData.length, false); // Initialize icons
          });
        } else {
          throw Exception('Unexpected API response structure');
        }
      } else {
        throw Exception('Failed to load voters data');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching data: $e');
    }
  }

  Future<void> searchVoters(String query) async {
    if (query.isEmpty) {
      fetchVotersData(); // Load all voters if query is empty
      return;
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token not found');

      setState(() => isLoading = true);

      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/search-village?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&village=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isLoading = false;
          votersData = List<Map<String, String>>.from(
              data['villages'].map((dynamic item) {
            return {
              'name': item['village']?.toString() ?? 'No name available',
              'details':
                  item['total_villagers']?.toString() ?? 'No details available',
            };
          }).toList());
        });
      } else {
        throw Exception('Failed to search voters');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error searching voters: $e');
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
                ? CircularProgressIndicator()
                : _buildVotersList(), // Show loading indicator
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
            setState(() => query = value);
            searchVoters(query); // Search API on query change
          },
        ),
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
            builder: (context) => Allvillagelist(
              villagename: voter['name']!,
              totlevillage: voter['details']!,
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
