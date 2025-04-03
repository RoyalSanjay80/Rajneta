import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:rajneta/Pages/voterDetailPage.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:rajneta/printController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/api_constants.dart';
import '../../LocalizationService.dart';

class Bysociety extends StatefulWidget {
  final String voterName;
  final String voterDetails;
  final String selectedLanguage;
  const Bysociety(
      {super.key,
      required this.voterName,
      required this.voterDetails,
      required this.selectedLanguage});

  @override
  State<Bysociety> createState() => _BysocietyState();
}

class _BysocietyState extends State<Bysociety> {
  bool isLoading = true;
  List<Map<String, String>> votersdata = [];
  int? selectedIndex;
  Printcontroller1 printController1=Get.put(Printcontroller1());
  Future<void> fetchData() async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? token = preference.getString('auth_token');
      if (token == null) throw Exception('auth token is not found');
      setState(() {
        isLoading = true;
      });
      final responce = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/voter-details-by-society?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&society=${widget.voterName}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        if (data != null && data['voters'] is List) {
          setState(() {
            isLoading = false;
            votersdata = List<Map<String, String>>.from(
                data['voters'].map((dynamic item) {
              final voterDetails = item['voter_details'] ?? {};
              final addressDetails = item['address_details'] ?? {};
              return {
                'name': [
                  voterDetails['first_name']?.toString() ?? '',
                  voterDetails['middle_name']?.toString() ?? '',
                  voterDetails['surname']?.toString() ?? '',
                ].where((namepart) => namepart.isNotEmpty).join(' '),
                'details': voterDetails['id']?.toString() ?? 'null',
                'voterId': voterDetails['voter_id']?.toString() ?? 'null',
                'number': item['mobile_1']?.toString() ?? 'No number available',
                'partNo': addressDetails['part_no']?.toString() ?? 'No part number available',
                'booth': addressDetails['booth']?.toString() ?? 'No booth available',
                'srn': addressDetails['srn']?.toString() ?? 'No SRN available',
              };
            }).toList());
          });
        } else {
          throw Exception('Unexpected Api responce Stucture');
        }
      } else {
        throw Exception('faild to load voter data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('err is $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    LocalizationService().changeLocale(widget.selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          children: [
            _buildheader(),
            const SizedBox(
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
                          'Palse wait loading',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: votersdata.isEmpty
                        ? Center(
                            child: Text(
                              'No result found',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            itemCount: votersdata.length,
                            itemBuilder: (context, index) {
                              final voter = votersdata[index];
                              return _buildVotersCard(voter, index);
                            }))
          ],
        ),
      ),
    );
  }

  Widget _buildheader() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              '${widget.voterName?.tr} ${widget.voterDetails}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24),
            ))
          ],
        ),
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
