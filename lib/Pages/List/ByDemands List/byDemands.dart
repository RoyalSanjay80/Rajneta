import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rajneta/Pages/VoterDetailPage.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:rajneta/printController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../LocalizationService.dart';

class Bydemands extends StatefulWidget {
  final String voterName;
  final String voterDetails;
  final String selectedLanguage;
  const Bydemands(
      {super.key,
      required this.voterName,
      required this.voterDetails,
      required this.selectedLanguage});

  @override
  State<Bydemands> createState() => _BydemandsState();
}

class _BydemandsState extends State<Bydemands> {
  bool isLoading = true;
  List<Map<String, String>> votersData = [];
  int? selectedIndex;
  Printcontroller1 printController1 =Get.put(Printcontroller1());
  @override
  void initState() {
    super.initState();
    fetchData();
    LocalizationService().changeLocale(widget.selectedLanguage);
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) throw Exception('auth token is not found');
      final responce = await http.get(
        Uri.parse(
            'https://rajneta.fusiontechlab.site/api/voter-details-by-demands?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&demands=${widget.voterName}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        if (data['voters'] is List) {
          setState(() {
            votersData =
                List<Map<String, String>>.from(data['voters'].map((item) {
              final votersDetails = item['voter_details'] ?? {};
              final addressDetails = item['address_details'] ?? {};
              return {
                'name': [
                  votersDetails['first_name']?.toString() ?? '',
                  votersDetails['middle_name']?.toString() ?? '',
                  votersDetails['surname']?.toString() ?? '',
                ].where((namePart) => namePart.isNotEmpty).join(' '),
                'details': votersDetails['id']?.toString() ?? '',
                'voterId': votersDetails['voter_id']?.toString() ?? '',
                'number': item['mobile_1']?.toString() ?? 'No number available',
                'partNo': addressDetails['part_no']?.toString() ?? 'No part number available',
                'booth': addressDetails['booth']?.toString() ?? 'No booth available',
                'srn': addressDetails['srn']?.toString() ?? 'No SRN available',
              };
            }));
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected Api Responce Structure');
        }
      } else {
        throw Exception('faild to load data');
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
          SizedBox(
            height: 10,
          ),
          isLoading
              ? Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      Text(
                        'Please wait loading',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                )
              : Expanded(
                  child: votersData.isEmpty
                      ? Center(
                          child: Text(
                            'No Result founds',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: votersData.length,
                          itemBuilder: (context, index) {
                            final voter = votersData[index];
                            return _buildVotersCard(voter, index);
                          }))
        ],
      ),
    ));
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: Text(
            widget.voterName.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildVotersCard(Map<String, String> voter, int index) {
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  voter['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: AppColors.secondaryColor),
                  onPressed: () {
                    setState(() {
                      selectedIndex = selectedIndex == index ? null : index;
                    });
                  },
                ),
              ],
            ),
            Text(voter['voterId']!),
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
    );
  }
}
