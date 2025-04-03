import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/colors.dart';

class SmsSetting extends StatefulWidget {
  const SmsSetting({Key? key}) : super(key: key);

  @override
  State<SmsSetting> createState() => _SmsSettingState();
}

class _SmsSettingState extends State<SmsSetting> {
  bool descriptionChecked = false;
  bool middleNameChecked = false;
  bool boothChecked = false;
  bool votingSymbolChecked = false;
  bool partyNameChecked = false;
  bool candidateInfoChecked = false;
  bool assemblyChecked = false;
  bool splitSmsChecked = false;
  bool codeOfConductActive = false;

  @override
  void initState() {
    super.initState();
    _loadSavedStates();
  }

  Future<void> _loadSavedStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      descriptionChecked = prefs.getBool('descriptionChecked') ?? false;
      middleNameChecked = prefs.getBool('middleNameChecked') ?? false;
      boothChecked = prefs.getBool('boothChecked') ?? false;
      votingSymbolChecked = prefs.getBool('votingSymbolChecked') ?? false;
      partyNameChecked = prefs.getBool('partyNameChecked') ?? false;
      candidateInfoChecked = prefs.getBool('candidateInfoChecked') ?? false;
      assemblyChecked = prefs.getBool('assemblyChecked') ?? false;
      splitSmsChecked = prefs.getBool('splitSmsChecked') ?? false;
    });
  }

  Future<void> _saveState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> sendDataToAPI() async {
    final url = Uri.parse("https://rajneta.fusiontechlab.site/api/sms-permission-store");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');

    Map<String, dynamic> body = {
      "middle_name_check": middleNameChecked ? "1" : "0",
      "description": descriptionChecked ? "1" : "0",
      "booth_check": boothChecked ? "1" : "0",
      "assembly_name_check": assemblyChecked ? "1" : "0",
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Settings saved successfully");
      } else {
        Get.snackbar("Error", "Failed to save settings. Status: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    _buildCheckboxTile('Description', descriptionChecked, 'descriptionChecked',apiUpdate: true),
                    _buildCheckboxTile('Middle Name', middleNameChecked, 'middleNameChecked', apiUpdate: true),
                    _buildCheckboxTile('Booth', boothChecked, 'boothChecked', apiUpdate: true),
                    _buildCheckboxTile('Voting Symbol', votingSymbolChecked, 'votingSymbolChecked', isDisabled: true),
                    _buildCheckboxTile('Party Name', partyNameChecked, 'partyNameChecked', isDisabled: true),
                    _buildCheckboxTile('Candidate Information', candidateInfoChecked, 'candidateInfoChecked', isDisabled: true),
                    _buildCheckboxTile('Assembly', assemblyChecked, 'assemblyChecked', apiUpdate: true),
                    _buildCheckboxTile('Split SMS if more than 3 pages', splitSmsChecked, 'splitSmsChecked'),
                  ],
                ),
              ),
            ),
              Container(
                width: double.infinity,
                color: Colors.orange[200],
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Warning - आचार संहिता / Modal Of Conduct is active, some settings cannot change.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Sms Setting',
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

  Widget _buildCheckboxTile(String title, bool value, String key, {bool isDisabled = false, bool apiUpdate = false}) {
    return ListTile(
      title: Text(title),
      trailing: Checkbox(
        value: value,
        activeColor: AppColors.secondaryColor,
        onChanged: (codeOfConductActive || isDisabled) ? null : (val) {
          setState(() {
            value = val ?? false;
            switch (key) {
              case 'descriptionChecked':
                descriptionChecked = value;
                break;
              case 'middleNameChecked':
                middleNameChecked = value;
                break;
              case 'boothChecked':
                boothChecked = value;
                break;
              case 'votingSymbolChecked':
                votingSymbolChecked = value;
                break;
              case 'partyNameChecked':
                partyNameChecked = value;
                break;
              case 'candidateInfoChecked':
                candidateInfoChecked = value;
                break;
              case 'assemblyChecked':
                assemblyChecked = value;
                break;
              case 'splitSmsChecked':
                splitSmsChecked = value;
                break;
            }
          });

          _saveState(key, value);
          if (apiUpdate) sendDataToAPI();
        },
      ),
    );
  }
}
