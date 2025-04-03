import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/colors.dart';

class BluetoothSlipSetting extends StatefulWidget {
  const BluetoothSlipSetting({Key? key}) : super(key: key);

  @override
  State<BluetoothSlipSetting> createState() => _BluetoothSlipSettingState();
}

class _BluetoothSlipSettingState extends State<BluetoothSlipSetting> {
  bool descriptionChecked = false;
  bool boothChecked = false;
  bool votingSymbolChecked = false;
  bool partyNameChecked = false;
  bool candidateInfoChecked = false;
  bool address = false;
  bool houseNoChecked = false;
  bool headerimage = false;


  double _sliderValue = 0;
  double _sliderValue1 = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedStates();
  }

  Future<void> _loadSavedStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      descriptionChecked = prefs.getBool('descriptionChecked') ?? false;
      // middleNameChecked = prefs.getBool('middleNameChecked') ?? false;
      boothChecked = prefs.getBool('boothChecked') ?? false;
      votingSymbolChecked = prefs.getBool('votingSymbolChecked') ?? false;
      partyNameChecked = prefs.getBool('partyNameChecked') ?? false;
      candidateInfoChecked = prefs.getBool('candidateInfoChecked') ?? false;
      address = prefs.getBool('addressChecked') ?? false;
      houseNoChecked = prefs.getBool('houseNoChecked') ?? false;
      headerimage = prefs.getBool('headerimage') ?? false;
    });
  }

  Future<void> _saveState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> sendDataToAPI() async {
    final url = Uri.parse("https://rajneta.fusiontechlab.site/api/bluetooth-permission-store");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');

    Map<String, dynamic> body = {
      // "middle_name_check": middleNameChecked ? "1" : "0",
      "description": descriptionChecked ? "1" : "0",
      "booth": boothChecked ? "1" : "0",
      "address": address ? "1" : "0",
      "house_no": houseNoChecked ? "1" : "0",
      // "house_no": houseNoChecked ? "1" : "0",
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
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
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  children: [
                    _buildCheckboxTile('Description', descriptionChecked, 'descriptionChecked', apiUpdate: true),
                    _buildCheckboxTile('Booth', boothChecked, 'boothChecked', apiUpdate: true),
                    _buildCheckboxTile('Voting Symbol', votingSymbolChecked, 'votingSymbolChecked', isDisabled: true),
                    _buildCheckboxTile('Party Name', partyNameChecked, 'partyNameChecked', isDisabled: true),
                    _buildCheckboxTile('Candidate Information', candidateInfoChecked, 'candidateInfoChecked', isDisabled: true),
                    _buildCheckboxTile('Address', address, 'addressChecked', apiUpdate: true),
                    _buildCheckboxTile('House No', houseNoChecked, 'houseNoChecked', apiUpdate: true),
                    _buildCheckboxTile('Header Image', headerimage, 'headerimage', isDisabled: true),
                  ],
                ),
              ),
              _buildSlider("Empty lines After print", _sliderValue, (value) {
                setState(() => _sliderValue = value);
              }),
              _buildSlider("Empty lines Before print", _sliderValue1, (value) {
                setState(() => _sliderValue1 = value);
              }),
              const Text('Header Image', style: TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              const Text('हिंजवडी ग्रामपंचायत  निवडणूक ', style: TextStyle(color: Colors.black, fontSize: 25)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildRow('संजय रामचंद्र कदम', 'assets/tailormachine.png'),
              buildRow('संतोष रावसाहेब पाटिल', 'assets/tailormachine.png'),
              buildRow('रामचंद्र रावसाहेब', 'assets/tv.png'),
            ],
          ),
              SizedBox(height: 50,)

            ],
          ),
        ),
      ),
    );
  }
  Widget buildRow(String name, String imagePath) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        SizedBox(width: 20), // Uniform spacing
        Image.asset(
          imagePath,
          width: 100, // Uniform image size
          height: 100,
          fit: BoxFit.cover,
        ),
      ],
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
          IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Get.back()),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Bluetooth Slip Setting', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
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
        onChanged: (headerimage || isDisabled) ? null : (val) async {
          if (val != null) {
            setState(() {
              switch (key) {
                case 'descriptionChecked':
                  descriptionChecked = val;
                  break;
                case 'boothChecked':
                  boothChecked = val;
                  break;
                case 'votingSymbolChecked':
                  votingSymbolChecked = val;
                  break;
                case 'partyNameChecked':
                  partyNameChecked = val;
                  break;
                case 'candidateInfoChecked':
                  candidateInfoChecked = val;
                  break;
                case 'addressChecked':
                  address = val;
                  break;
                case 'houseNoChecked':
                  houseNoChecked = val;
                  break;
                case 'headerimage':
                  houseNoChecked = val;
                  break;
              }
            });

            await _saveState(key, val);

            if (apiUpdate) {
              await sendDataToAPI();
            }
          }
        },
      ),
    );
  }


  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Text('$label - ${value.toInt()}', style: const TextStyle(color: Colors.red)),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8, // 🔹 Line (track) ki height ko badao

          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 10,
            activeColor: Colors.red,
            inactiveColor: Colors.grey,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
