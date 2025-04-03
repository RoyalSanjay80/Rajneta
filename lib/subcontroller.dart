import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


import 'Pages/List/Address/allAdderss.dart';
import 'Pages/List/ByMobileNumberList/allMobileNo.dart';
import 'Pages/List/society/allSociety.dart';
import 'Pages/List/ByPersonnel/allPersonnel.dart';
import 'Pages/List/ByPosition/allPosition.dart';
import 'Pages/List/ByPartNumber/allPartNO.dart';
import 'Pages/List/AlphabeticalList/alphabeticalList.dart';
import 'Pages/List/By Bluetooth Slip Report By User/bluetoothSlipReportByUser.dart';
import 'Pages/bulkSurvey.dart';

import 'Pages/List/ByAge/allAgeList.dart';
import 'Pages/List/ByCaste/AllCasteList.dart';
import 'Pages/List/ColorCode/allColorCode.dart';
import 'Pages/List/ByDead/allDead.dart';
import 'Pages/List/ByGender/allGender.dart';
import 'Pages/List/By House Number/allHouseNo.dart';
import 'Pages/List/ByNewAddress/allNewAdderss.dart';

import 'Pages/List/BySurname/allSuraname.dart';
import 'Pages/List/By Taluka/allTaluka.dart';
import 'Pages/List/By SurveyTeam/allSurveyTeam.dart';
import 'Pages/List/ByViallage/byVillage.dart';
import 'Pages/List/ByVotingCenter/allvotingCenter.dart';
import 'Pages/List/ByDemands List/allDemandsList.dart';
import 'Pages/exportToPDF.dart';
import 'Pages/exporttoExcel.dart';
import 'Pages/List/By Extra Check-1/allExtraChech1.dart';
import 'Pages/List/ByExtraCheck2/allExtraCheck2.dart';
import 'Pages/List/ExtraInfo1/allExtraInfo1.dart';
import 'Pages/List/ExtraInfo2/allExtraInfo2.dart';
import 'Pages/List/ExtraInfo3/allExtraInfo3.dart';
import 'Pages/List/ExtraInfo4/allExtraInfo4.dart';
import 'Pages/List/ExtraInfo5/allExtraInfo5.dart';
import 'Pages/List/ByRepeated/allRepeated.dart';
import 'Pages/loginPage.dart';
import 'Pages/List/By Slip Printer Report/slipPrintReport.dart';
import 'Pages/List/ByStar Voter/allStareVoter.dart';
import 'Pages/List/By Today Birthday/allTodayBirthday.dart';
import 'Pages/List/By Voted/allVoted.dart';
import 'Pages/voterSlipPdf.dart';
import 'Pages/List/VoterWithoutMobileList/allVoterWithoutMobile.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;


class Subcontroller extends GetxController {

  void _showSnackBar(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void showOptionsDialog(
      BuildContext context, String itemname, String selectedLanguage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select an Option"),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: ImageIcon(AssetImage('assets/logo/more_analysis.png'),size: 40,),
                title: Text("More Analysis"),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _showSnackBar('More Analysis selected');
                  _showOptionsDialog1(context,selectedLanguage); // Assuming this is another dialog function
                },
              ),
              ListTile(
                leading: ImageIcon(AssetImage('assets/logo/export_to_pdf.png'),size: 40,),
                title: Text("Export to PDF"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Exporttopdf(
                          itemName: itemname,
                          selectedLanguage: selectedLanguage,
                        ),
                      ));
                },
              ),
              ListTile(
                leading: ImageIcon(AssetImage('assets/logo/export_to_exceldowloand.png'),size: 40,),
                title: Text("Export to Excel"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExportToExcel(
                          itemName: itemname,
                          selectedLanguage: selectedLanguage,
                        ),
                      ));
                },
              ),
              ListTile(
                leading: ImageIcon(AssetImage('assets/logo/export_to_pdf.png'),size: 40,),
                title: Text("Voter Slip PDF"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Voterslippdf(
                          itemName: itemname,
                          selectedLanguage: selectedLanguage,
                        ),
                      ));
                },
              ),
              ListTile(
                leading: ImageIcon(AssetImage('assets/logo/bulk_survey.png'),size: 40,),
                title: Text("Bulk Survey"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bulksurvey(
                          itemName: itemname,
                          selectedLanguage: selectedLanguage,
                        ),
                      ));
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _showOptionsDialog1(BuildContext context,String selectedLanguage ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("More Analysis "),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(thickness: 2,),
                ListTile(
                  leading: SizedBox(
                    height: 30, // Set the height of the image
                    width: 30,  // Set the width of the image
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black, // Set the color you want
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        "assets/logo/ALPHABETICAL LIST.png",
                      ),
                    ),
                  ),
                  title: Text("alphabetical list".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlphabeticalList(
                          itemName: 'alphabetical list',
                          selectedLanguage: selectedLanguage,
                        ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading: ImageIcon(
                    AssetImage('assets/logo/logo 3.png'),
                    size: 30.0, // Adjust the size of the icon
                    color: Colors.black, // Set the desired color
                  ),
                  title: Text("By Village".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ByVillageList(
                              itemName: 'By Village',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/logo 2.png'),size: 30,color: Colors.black,),
                  title: Text("By Part No".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllPartNo(
                              itemName: 'By Part No',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/by voting center.png'),size: 25,color: Colors.black,),
                  title: Text("By voiting center".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllVotingCenter(
                              itemName: 'By voiting center',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/by personnel.png'),size: 30,color: Colors.black,),
                  title: Text("By Personnel".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllPersonnel(
                              itemName: 'By Personnel',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra info all.png'),size: 30,color: Colors.black,),
                  title: Text("By Surname".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllSuraname(
                              itemName: 'By Surname',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/by colour code.png'),size: 30,color: Colors.black,),
                  title: Text("By Colour Code".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllColorCode(
                              itemName: 'By Colour Code',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/mobile.png'),size: 25,color: Colors.black,),
                  title: Text("Mobile No List".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllMobileNoList(
                              itemName: 'Mobile No List',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/mobile.png'),size: 25,color: Colors.black,),
                  title: Text("VotercWithout Mobile".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllVoterWithoutMobile(
                              itemName: 'VotercWithout Mobile',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/logo.png'),size: 30,color: Colors.black,),
                  title: Text("By Adderss".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllAdderss(
                              itemName: 'By Adderss',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/logo.png'),size: 30,color: Colors.black,),
                  title: Text("By New Adderss".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllNewAdderss(
                              itemName: 'By New Adderss',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/logo 3.png'),size: 30,color: Colors.black,),
                  title: Text("By Society".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllSociety(
                              itemName: 'By Society',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/human_prev_ui (1).png'),size: 30,color: Colors.black,),
                  title: Text("By Gender".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllGender(
                              itemName: 'By Gender',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/by age.png'),size: 30,color: Colors.black,),
                  title: Text("By Age".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ByAge(
                              itemName: 'By Age',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/by cast.png'),size: 30,color: Colors.black,),
                  title: Text("By Caste".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ByCast(
                              itemName: 'By Caste',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/by position.png'),size: 30,color: Colors.black,),
                  title: Text("By Position".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllPosition(
                              itemName: 'By Position',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/dead.png'),size: 30,color: Colors.black,),
                  title: Text("By Dead".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllDead(
                              itemName: 'By Dead',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/human_prev_ui (1).png'),size: 30,color: Colors.black,),
                  title: Text("Repeated".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Repeated(
                              itemName: 'Repeated',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/star voter.png'),size: 30,color: Colors.black,),
                  title: Text("Star Voter".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllStareVoter(
                              itemName: 'Star Voter',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra check all.png'),size: 30,color: Colors.black,),
                  title: Text("Extra Ckeck 1".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllExtraCheck1(
                              itemName: 'Extra Ckeck 1',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra check all.png'),size: 30,color: Colors.black,),
                  title: Text("Extra Ckeck 2".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExtraCheck2(
                              itemName: 'Extra Ckeck 2',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra info all.png'),size: 30,color: Colors.black,),
                  title: Text("Extra Info 1".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllExtraInfo1(
                              itemName: 'Extra Info 1',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra info all.png'),size: 30,color: Colors.black,),
                  title: Text("Extra Info 2".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllExtraInfo2(
                              itemName: 'Extra Info 2',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra info all.png'),size: 30,color: Colors.black,),
                  title: Text("Extra Info 3".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllExtraInfo3(
                              itemName: 'Extra Info 3',
                              selectedLanguage:selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra info all.png'),size: 30,color: Colors.black,),
                  title: Text("Extra Info 4".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllExtraInfo4(
                              itemName: 'Extra Info 4',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra info all.png'),size: 30,color: Colors.black,),
                  title: Text("Extra Info 5".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllExtraInfo5(
                              itemName: 'Extra Info 5',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/by house number.png'),size: 30,color: Colors.black,),
                  title: Text("By House No".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllHouseNo(
                              itemName: 'By House No',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra info all.png'),size: 30,color: Colors.black,),
                  title: Text("Demands List".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllDemandsList(
                              itemName: 'Demands List',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/voted.png'),size: 30,color: Colors.black,),
                  title: Text("voted".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllVoted(
                              itemName: 'voted',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/by survey team.png'),size: 30,color: Colors.black,),
                  title: Text("By Survey Team".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllTaluka(
                              itemName: 'By Survey Team',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/logo 3.png'),size: 30,color: Colors.black,),
                  title: Text("By Taluka".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllSurveyTeam(
                              itemName: 'By Taluka',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/extra info all.png'),size: 30,color: Colors.black,),
                  title: Text("Today BirthDay".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TodayBirthDay(
                              itemName: 'Today BirthDay',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/pinter_s.png'),size: 30,color: Colors.black,),
                  title: Text("Slip Printer Report".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SlipPrinterReport(
                              itemName: 'Slip Printer Report',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
                ListTile(
                  leading:ImageIcon(AssetImage('assets/logo/pinter_s.png'),size: 25,color: Colors.black,),
                  title: Text("Bluetooth Slip Report By User".tr),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BluetoothSlipReportByUser(
                              itemName: 'Bluetooth Slip Report By User',
                              selectedLanguage: selectedLanguage,
                            ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 2,),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> generatePDF(
      BuildContext context,
      List<String> names, // List of names
      List<String> details, // List of details
      String text1,
      String text2,
      ) async {
    final permissionUrl = 'https://rajneta.fusiontechlab.site/api/user-permission';
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      final response = await http.get(Uri.parse(permissionUrl), headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final permissions = responseData['permission'];
        if (permissions != null && permissions is List && permissions.isNotEmpty) {
          final userPermission = permissions[0];
          if (userPermission['pdf_download'] == 1) {
            final pdf = pw.Document();

            // Load the custom font for Hindi/Marathi
            final hindiFont = await pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSansDevanagari-Regular.ttf'));
            // Default font (for English or fallback font)
            final englishFont = await pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));

            final headers = [text1.tr, text2.tr];  // Localized headers
            List<List<String>> tableData = [];
            for (int i = 0; i < names.length; i++) {
              tableData.add([names[i], details[i]]);
            }

            // Helper function to determine the language and select the appropriate font
            pw.Font getFontForText(String text) {
              if (RegExp(r'[A-Za-z]').hasMatch(text)) {
                // If the text contains English characters, use English font
                return englishFont;
              } else {
                return hindiFont;
              }
            }

            pdf.addPage(
              pw.Page(
                build: (context) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Add the required text at the top (localized)
                    pw.Text(
                      'Shirur - Assembly - Maharashtra Assembly Election'.tr,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        font: getFontForText(text1.tr), // Dynamically set font
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      '${text1.tr}'.tr,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        font: getFontForText(text1.tr), // Dynamically set font
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      'Rajyog Demo'.tr,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        font: getFontForText(text1.tr), // Dynamically set font
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 20), // Add some spacing
                    // Add the table with dynamic font selection
                    pw.Table.fromTextArray(
                      headers: headers,
                      data: tableData,
                      border: pw.TableBorder.all(),
                      cellAlignment: pw.Alignment.centerLeft,
                      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: getFontForText(text1.tr)),
                      cellStyle: pw.TextStyle(fontSize: 12, font: getFontForText(names[0])), // Dynamically set font based on the first name
                      cellHeight: 30,
                    ),
                  ],
                ),
              ),
            );

            // Save PDF to local storage
            final directory = await getApplicationDocumentsDirectory();
            final file = File('${directory.path}/voter_list.pdf');
            await file.writeAsBytes(await pdf.save());

            // Share the PDF
            await Share.shareXFiles(
              [XFile(file.path)],
              text: 'Voter List PDF',
            );
          } else {
            print('PDF download not allowed.');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Permission Denied'.tr),
                  content: Text(
                    'You do not have permission to download the PDF. Please contact the administrator.'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok'.tr),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          print('No valid permissions found.');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Permission Denied'.tr),
                content: Text(
                  'You do not have permission to download the PDF. Please contact the administrator.'.tr,
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'.tr),
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('Failed to fetch permissions. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking permissions: $error');
    }
  }




  Future<void> generateExcel(
      BuildContext context,
      List<String> names,  // List of names
      List<String> details,
      String text1, // Column title for 'Part No'
      String text2, // Column title for 'Details'
      ) async {
        const permissionUrl = 'https://rajneta.fusiontechlab.site/api/user-permission';
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      final response = await http.get(Uri.parse(permissionUrl), headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final permissions = responseData['permission'];
        if (permissions != null && permissions is List && permissions.isNotEmpty) {
          final userPermission = permissions[0];
          if (userPermission['excelsheet_download'] == 1) {
            var excel = Excel.createExcel();
            Sheet sheet = excel['Sheet1']; // Create a new sheet

            // Add headers to the sheet
            sheet.appendRow([
              'Shirur - Assembly - Maharashtra Assembly Election'.tr,
            ]);

            sheet.appendRow([text1.tr]);
            sheet.appendRow(['Rajyog Demo'.tr]);
            sheet.appendRow([text1, text2]);

            // Add rows of data
            for (int i = 0; i < names.length; i++) {
              sheet.appendRow([names[i], details[i]]);
            }


            final directory = await getApplicationDocumentsDirectory();
            final file = File('${directory.path}/voter_list.xlsx');
            final excelBytes = await excel.encode();
            if (excelBytes != null) {
              await file.writeAsBytes(excelBytes);
            } else {
              throw Exception('Failed to generate Excel data');
            }

            // Share the Excel file
            await Share.shareXFiles(
              [XFile(file.path)],
              text: 'Voter List Excel',
            );
          } else {
            print('Excel download not allowed.');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Permission Denied'.tr),
                  content: Text(
                    'You do not have permission to download the PDF. Please contact the administrator.'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok'.tr),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          print('No valid permissions found.');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Permission Denied'.tr),
                content: Text(
                  'You do not have permission to download the PDF. Please contact the administrator.'.tr,
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'.tr),
                  ),
                ],
              );
            },
          );

        }
      } else {
        print('Failed to fetch permissions. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking permissions: $error');
    }
  }

}
