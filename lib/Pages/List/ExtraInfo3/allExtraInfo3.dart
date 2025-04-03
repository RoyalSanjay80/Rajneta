import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:rajneta/subcontroller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:rajneta/Pages/voterDetailPage.dart';
import '../../../Utils/api_constants.dart';
import '../../../Utils/colors.dart';
import '../../LocalizationService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart'as http;

import 'ByExtraInfo3.dart';

class AllExtraInfo3 extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;



  AllExtraInfo3({Key? key, required this.itemName, required this.selectedLanguage})
      : super(key: key);

  @override
  _AllExtraInfo3State createState() => _AllExtraInfo3State();
}

class _AllExtraInfo3State extends State<AllExtraInfo3> {
 bool isLoading=true;
 List<Map<String,String>>votersData=[];
 String query='';
 Subcontroller covariant=Get.put(Subcontroller());

  @override
  void initState() {
    super.initState();

    LocalizationService().changeLocale(widget.selectedLanguage);
    // _getBluetoothDevices();
    fetchData();
  }

  Future<void>fetchData()async{
    try{
      SharedPreferences preferences=await SharedPreferences.getInstance();
      String? token=preferences.getString('auth_token');
      if(token==null) throw Exception('auth token is not fount');
      setState(() {
        isLoading=true;
      });
      final responce=await http.get(Uri.parse('${ApiConstants.baseUrl}api/extra-information-three-list?lang=${widget.selectedLanguage.substring(0,2).toLowerCase()}'),
      headers: {'Authorization':'Bearer $token'}
      );
      if(responce.statusCode==200){
        final data=json.decode(responce.body);
        if(data['extra_information_three_details'] is List){
         setState(() {
           votersData=List<Map<String,String>>.from((data['extra_information_three_details'] as List).map((item){
             return {
               'name':item['extra_information_three']?.toString() ?? 'null',
               'details':item['extra_information_three_count']?.toString() ?? 'null',
             };
           }));
           isLoading=false;
         });
        }else{
          throw Exception('Unexpected Api Responce');
        }
      }else{
        throw Exception('faild to load data');
      }
    }catch(e){
     setState(() {
       isLoading=false;
     });
     throw Exception('err is $e');
    }
  }
  Future<void>searchData(String query)async{
    if(query.isEmpty){
      fetchData();
      return;
    }
    try{
      SharedPreferences preferences=await SharedPreferences.getInstance();
      String? token=preferences.getString('auth_token');
      if(token==null)throw Exception('auth token is not found');
      setState(() {
        isLoading=true;
      });
      final responce=await http.get(Uri.parse('${ApiConstants.baseUrl}api/search-extra-information-three?lang=${widget.selectedLanguage.substring(0,2).toLowerCase()}&extra_info_3=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if(responce.statusCode==200){
        final data=json.decode(responce.body);
        if(data['extra_info_three_voters'] is List){
          setState(() {
            votersData=List<Map<String,String>>.from((data['extra_info_three_voters']as List).map((item){
              return {
                'name':item['extra_info_three']?.toString() ?? 'null',
                'details':item['total_voters']?.toString() ?? 'null',
              };
            }));
            isLoading=false;
          });
        } else {
          throw Exception('Unexpected Api responce');
        }
      }else{
        throw Exception('faild to load data');
      }
    }catch(e){
     setState(() {
       isLoading=false;
     });
     throw Exception('err is $e');
    }
  }

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
            isLoading
            ? CircularProgressIndicator(color: Colors.white,)
            :_buildVotersList(),
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
          onChanged: (value){
            query=value;
            searchData(query);
          },
        ),
      ),
    );
  }

  Widget _buildVotersList() {
    return Expanded(
      child: ListView.builder(
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
            builder: (context) => Byextrainfo3(
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
                  onPressed: () {
                    covariant.showOptionsDialog(context,
                        widget.itemName,
                        widget.selectedLanguage);
                  }),
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
            covariant.generateExcel(context,
                votersData.map((item)=>item['name'] ?? 'Null').toList(),
                votersData.map((item)=>item['details'] ?? 'Null').toList(),
                widget.itemName.tr,
                "Total".tr);
          },
          icon: Icon(Icons.share),
          label: Text("Export"),
          backgroundColor: AppColors.secondaryColor,
        ),
        SizedBox(height: 8),
        FloatingActionButton.extended(
          heroTag: 'reportFAB',
          onPressed: (){
            covariant.generatePDF(context,
                votersData.map((item)=>item['name'] ?? 'Null').toList(),
                votersData.map((item)=>item['details'] ?? 'Null').toList(),
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
