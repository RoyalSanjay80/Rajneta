import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rajneta/printController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rajneta/Pages/voterDetailPage.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Utils/api_constants.dart';
import '../../../Utils/colors.dart';
import '../../../subcontroller.dart';
import '../../LocalizationService.dart';

class AlphabeticalList extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  const AlphabeticalList({
    Key? key,
    required this.itemName,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  _AlphabeticalListState createState() => _AlphabeticalListState();
}

class _AlphabeticalListState extends State<AlphabeticalList> {
  bool isLoading = true;
  List<Map<String, String>> votersData = [];
  TextEditingController searchController = TextEditingController();
  String query = "";
  int? selectedIndex;
   Printcontroller1 printController1 = Get.put(Printcontroller1());
   Subcontroller subController = Get.put(Subcontroller());

  @override
  void initState() {
    super.initState();
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
          '${ApiConstants.baseUrl}api/voters-list-alphabetically?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isLoading = false;
          votersData = List<Map<String, String>>.from(data['voters'].map((dynamic item) {
            return {
              'name': [
                item['first_name']?.toString() ?? '',
                item['middle_name']?.toString() ?? '',
                item['last_name']?.toString() ?? '',
              ].where((namePart) => namePart.isNotEmpty).join(' '),
              'details': item['id']?.toString() ?? 'No details available',
              'voterId': item['voter_id']?.toString() ?? 'No voter ID available',
              'number': item['mobile_1']?.toString() ?? 'No number available',
              'partNo': item['voter_address']?['part_no']?.toString() ?? 'No part number available',
              'booth': item['voter_address']?['booth']?.toString() ?? 'No booth available',
              'srn': item['voter_address']?['srn']?.toString() ?? 'No SRN available',
            };
          }).toList());
        });
      } else {
        throw Exception('Failed to load voters data');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching data: $e');
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
            _buildSearchBox(),
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? _buildSkeletonLoader()
                  : _buildVotersList(),
            ),
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

  Widget _buildSearchBox() {
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
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search Voters',
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search, color: AppColors.secondaryColor),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          onChanged: (value) {
            setState(() => query = value);
          },
        ),
      ),
    );
  }

  Widget _buildVotersList() {
    final filteredVoters = votersData
        .where((voter) => voter['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: filteredVoters.length,
      itemBuilder: (context, index) {
        final voter = filteredVoters[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoterDetailPage(
                  voterName: voter['name'] ?? 'Unknown',
                  voterDetails: voter['details'] ?? 'No details available',
                  selectedLanguage: widget.selectedLanguage,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
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
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      voter['name'] ?? 'Unknown',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(voter['voterId'] ?? 'No voter ID available'),
                    trailing: IconButton(
                      icon: Icon(Icons.more_horiz, color: AppColors.secondaryColor),
                      onPressed: () {
                        setState(() {
                          selectedIndex = selectedIndex == index ? null : index;
                        });
                      },
                    ),
                  ),
                  if (selectedIndex == index)
                    printController1.buildActionRow1(
                        context,
                        voter['number'] ?? 'Unknown',
                        voter['details'] ?? 'Unknown',
                        widget.selectedLanguage.substring(0, 2).toLowerCase()
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFABs() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: 'exportFAB',
          onPressed: () {
            subController.generateExcel(
              context,
              votersData.map((item) => item['name'] ?? 'null').toList(),
              votersData.map((item) => item['details'] ?? 'null').toList(),
              widget.itemName.tr,
              'Total'.tr,
            );
          },
          icon: Icon(Icons.share),
          label: Text("Export"),
          backgroundColor: AppColors.secondaryColor,
        ),
        SizedBox(height: 8),
        FloatingActionButton.extended(
          heroTag: 'reportFAB',
          onPressed: () {
            subController.generatePDF(
              context,
              votersData.map((voter) => voter['name'] ?? 'Unknown').toList(),
              votersData.map((voter) => voter['details'] ?? '0').toList(),
              widget.itemName.tr,
              'Total'.tr,
            );
          },
          icon: Icon(Icons.picture_as_pdf),
          label: Text("Report"),
          backgroundColor: AppColors.secondaryColor,
        ),
      ],
    );
  }



  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.3),
            highlightColor: Colors.grey.withOpacity(0.1),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 10,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 60,
                          height: 10,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

