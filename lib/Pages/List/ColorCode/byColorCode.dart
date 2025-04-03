import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rajneta/Pages/VoterDetailPage.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/api_constants.dart';
import '../../../printController.dart';
import '../../LocalizationService.dart';


class Bycolorcode extends StatefulWidget {
  final String voterName;
  final String voterDetails;
  final String selectedLanguage;
  const Bycolorcode(
      {super.key,
      required this.voterName,
      required this.voterDetails,
      required this.selectedLanguage});

  @override
  State<Bycolorcode> createState() => _BycolorcodeState();
}

class _BycolorcodeState extends State<Bycolorcode> {
  bool isLoding = true;
  List<Map<String, String>> votersData = [];
  int? selectedIndex;
  Printcontroller1 printController1=Get.put(Printcontroller1());
  @override
  void initState() {
    super.initState();
    fetchdata();
    LocalizationService().changeLocale(widget.selectedLanguage);
  }

  Future<void> fetchdata() async {
    try {
      SharedPreferences prefes = await SharedPreferences.getInstance();
      String? token = prefes.getString('auth_token');
      if (token == null) throw Exception('token is not found');
      setState(() {
        isLoding = true;
      });
      final responce = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/voter-details-by-colour-code?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&colour_code=${widget.voterName}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        if (data != null && data['voters'] is List) {
          setState(() {
            isLoding = false;
            votersData = List<Map<String, String>>.from(
                data['voters'].map((dynamic item) {
              final voterDetails = item['voter_details'] ?? {};
              return {
                'name': [
                  voterDetails['first_name']?.toString() ?? '',
                  voterDetails['middle_name']?.toString() ?? '',
                  voterDetails['surname']?.toString() ?? ''
                ].where((namepart) => namepart.isNotEmpty).join(' '),
                'id': voterDetails['id']?.toString() ?? 'null',
                'voterId': voterDetails['voter_id']?.toString() ?? 'null',
              };
            }).toList());
          });
        } else {
          throw Exception('Unexpected Api responce structure');
        }
      } else {
        throw Exception('faild to load voter data');
      }
    } catch (e) {
      setState(() {
        isLoding = false;
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
            isLoding
                ? Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        Text(
                          'Palse wait Loading',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: votersData.isEmpty
                        ? Center(
                            child: Text('No result founds'),
                          )
                        : ListView.builder(
                            itemCount: votersData.length,
                            itemBuilder: (context, index) {
                              final voter = votersData[index];
                              return _buildVotersCard(voter,index);
                            }))
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              '${widget.voterName.tr} ${widget.voterDetails.tr}',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
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
                  voter['id'] ?? 'Unknown',
                  widget.selectedLanguage.substring(0, 2).toLowerCase()
              ),
          ],
        ),
      ),
    );
  }
}
