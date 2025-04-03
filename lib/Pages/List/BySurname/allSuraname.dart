import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
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
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart'as http;

import 'bySurname.dart';

class AllSuraname extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;


  AllSuraname({Key? key, required this.itemName, required this.selectedLanguage})
      : super(key: key);

  @override
  _AllSuranameState createState() => _AllSuranameState();
}

class _AllSuranameState extends State<AllSuraname> {
  final Subcontroller contrller=Get.put(Subcontroller());


  List<Map<String,String>> votersdata=[];
  bool isLoading = true;
  String query = "";
  @override
  void initState() {
    super.initState();
    fetchdata();
    LocalizationService().changeLocale(widget.selectedLanguage);
  }

  Future<void>fetchdata()async{
    try{
      SharedPreferences prefs= await SharedPreferences.getInstance();
      String? token=prefs.getString('auth_token');
      if(token==null) throw Exception('auth token is not fount');
      setState(() {
        isLoading=true;
      });
      final responce=await http.get(Uri.parse('${ApiConstants.baseUrl}api/surname-list?lang=${widget.selectedLanguage.substring(0,2).toLowerCase()}'),
      headers: {'Authorization':'Bearer $token'},
      );
      if(responce.statusCode==200){
        final data=json.decode(responce.body);
        if(data['surnames']is List){
          setState(() {
            votersdata=List<Map<String,String>>.from(
              data['surnames'].map((item)=>{
                'name':item['surname']?.toString() ?? 'null'.tr,
                'details':item['voter_count']?.toString() ?? 'null'.tr
              })
            );
            isLoading=false;
          });

        }else{
          throw Exception('Unexpected Api reponce strucuter');
        }
      } else{
        throw Exception('faild to load data');
      }

    }catch(e){
      setState(() {
        isLoading=false;
      });
      print('err is $e');

    }
  }
  Future<void>searchvoters(String query) async{
    if(query.isEmpty){
      fetchdata();
      return;
    }
    try{
      SharedPreferences prefs=await SharedPreferences.getInstance();
      String? token=prefs.getString('auth_token');
      if(token==null)throw Exception('auth token is not found');
      setState(() {
        isLoading=true;
      });
      final response= await http.get(Uri.parse('${ApiConstants.baseUrl}api/search-surname?lang=${widget.selectedLanguage.substring(0,2).toLowerCase()}&surname=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if(response.statusCode==200){
        final data=json.decode(response.body);
        setState(() {
          votersdata=List<Map<String,String>>.from(
              data['surnames'].map((item)=>{
                'name':item['surname']?.toString() ?? 'null',
                'details':item['total_voters']?.toString() ?? 'null'
              })
          );
          isLoading=false;
        });
      }else{
        throw Exception('faild to serach voters');
      }

    }catch(e){
      setState(() {
        isLoading=false;
      });
      print('err is $e');
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
            searchvoters(query);
          },
        ),
      ),
    );
  }

  Widget _buildVotersList() {
    return Expanded(
      child:
        votersdata.isEmpty
        ? Center(child: Text('Data is Not Available',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white
        ),),)
      :ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: votersdata.length,
        itemBuilder: (context, index) {
          final voter = votersdata[index];
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
            builder: (context) => Bysurname(
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
                      voter['details'] ?? 'No details available',
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
                    contrller.showOptionsDialog(context, widget.itemName, widget.selectedLanguage);
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
          contrller.generateExcel(context,
              votersdata.map((item)=>item['name']?? 'null').toList(),
              votersdata.map((item)=>item['details']?? 'null').toList(),
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
            contrller.generatePDF(context,
                votersdata.map((item)=>item['name']?? 'null').toList(),
                votersdata.map((item)=>item['details']?? 'null').toList(),
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
