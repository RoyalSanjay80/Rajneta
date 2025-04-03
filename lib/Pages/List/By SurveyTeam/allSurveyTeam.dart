import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:rajneta/Pages/voterDetailPage.dart';
import '../../../Utils/colors.dart';
import '../../LocalizationService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AllSurveyTeam extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  final List<Map<String, String>> votersData = [
    {
      "name": "हरिराव होळकर",
      "details": "Some data about voter 1",
      "phone": "1234567890"
    },
    {
      "name": "जिजाबाई शिंदे",
      "details": "Some data about voter 2",
      "phone": ""
    },
    {
      "name": "माधवराव पेशवा",
      "details": "Some data about voter 3",
      "phone": "0987654321"
    },
  ];

  AllSurveyTeam({Key? key, required this.itemName, required this.selectedLanguage})
      : super(key: key);

  @override
  _AllSurveyTeamState createState() => _AllSurveyTeamState();
}

class _AllSurveyTeamState extends State<AllSurveyTeam> {
  List<bool> _showMoreIcons = [];
  // BlueThermalPrinter printer = BlueThermalPrinter.instance;
  // List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _showMoreIcons = List.filled(widget.votersData.length, false);
    // _getBluetoothDevices();
  }

  // Future<void> _getBluetoothDevices() async {
  //   devices = await printer.getBondedDevices();
  //   setState(() {});
  // }
  //
  // void _printData(String data) async {
  //   if (devices.isNotEmpty) {
  //     final BluetoothDevice? selectedDevice = await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Select Bluetooth Device"),
  //           content: Container(
  //             width: double.maxFinite,
  //             height: 300,
  //             child: ListView.builder(
  //               itemCount: devices.length,
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   title: Text(devices[index].name ?? ""),
  //                   onTap: () => Navigator.pop(context, devices[index]),
  //                 );
  //               },
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //
  //     if (selectedDevice != null) {
  //       await printer.connect(selectedDevice);
  //       await printer.printCustom(data, 2, 1);
  //       await printer.disconnect();
  //       _showSnackBar('Printing successful!');
  //     }
  //   } else {
  //     _showSnackBar('No Bluetooth devices found!');
  //   }
  // }

  void _exportData() => _showSnackBar('Exporting data...');

  void _reportData() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text('Reporting data...'),
      ),
    ));

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/report.pdf';

    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    _showSnackBar('PDF saved to $filePath');
    await OpenFile.open(filePath);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    LocalizationService().changeLocale(widget.selectedLanguage);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildSearchField(),
            SizedBox(height: 16),
            _buildVotersList(),
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
        ),
      ),
    );
  }

  Widget _buildVotersList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: widget.votersData.length,
        itemBuilder: (context, index) {
          final voter = widget.votersData[index];
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
            builder: (context) => VoterDetailPage(
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
                      voter['phone'] ?? 'No phone number available',
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
                  onPressed: () {}),
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
          onPressed: _exportData,
          icon: Icon(Icons.share),
          label: Text("Export"),
          backgroundColor: AppColors.secondaryColor,
        ),
        SizedBox(height: 8),
        FloatingActionButton.extended(
          heroTag: 'reportFAB',
          onPressed: _reportData,
          icon: Icon(Icons.picture_as_pdf),
          label: Text("Report"),
          backgroundColor: AppColors.secondaryColor,
        ),
      ],
    );
  }
}
