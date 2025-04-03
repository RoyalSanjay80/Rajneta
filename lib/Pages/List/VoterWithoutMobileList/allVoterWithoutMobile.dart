import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:rajneta/subcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:rajneta/Pages/voterDetailPage.dart';
import '../../../Utils/api_constants.dart';
import '../../../Utils/colors.dart';
import '../../LocalizationService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;

class AllVoterWithoutMobile extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  AllVoterWithoutMobile({Key? key, required this.itemName, required this.selectedLanguage}) : super(key: key);

  @override
  _AllVoterWithoutMobileState createState() => _AllVoterWithoutMobileState();
}

class _AllVoterWithoutMobileState extends State<AllVoterWithoutMobile> {
  List<Map<String, String>> votersData = [];
  bool isLoding = true;
  Subcontroller controller =Get.put(Subcontroller());

  @override
  void initState() {
    super.initState();
    fetchdata();
    LocalizationService().changeLocale(widget.selectedLanguage);
  }

  Future<void> fetchdata() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('Auth token is not found');

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}api/voter-details-without-mobile-no?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['voters'] is List) {
          setState(() {
            votersData = List<Map<String, String>>.from(
              data['voters'].map((item) => {
                'name': item['voter_details']['first_name']?.toString() ?? 'N/A',
                'details': item['voter_details']['id']?.toString() ?? 'N/A',
              }),
            );
            isLoding = false;
          });
        } else {
          throw Exception('Unexpected API response structure');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoding = false;
      });
      print('Error: $e');
    }
  }

  // Future<void> _getBluetoothDevices() async {
  //   devices = await printer.getBondedDevices();
  //   setState(() {});
  // }

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


    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildSearchField(),
            SizedBox(height: 16),
            isLoding
                ? CircularProgressIndicator(color: Colors.white)
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
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
      child: votersData.isEmpty
          ? Center(
        child: Text(
          'Data is not available',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      )
          : ListView.builder(
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
          onPressed: (){
          controller.generateExcel(context,
              votersData. map((item)=>item['name']?? 'null').toList(),
              votersData.map((item)=>item['details']?? 'null').toList(),
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
          onPressed: (){
            controller.generatePDF(context,
                votersData.map((item)=>item['name']?? 'null').toList(),
                votersData.map((item)=>item['details']?? 'null').toList(),
                widget.itemName.tr,
                'Total'.tr);
          },
          icon: Icon(Icons.picture_as_pdf),
          label: Text("Report"),
          backgroundColor: AppColors.secondaryColor,
        ),
      ],
    );
  }
}
