// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:open_file/open_file.dart';
// import 'package:rajneta/Pages/allPersonnel.dart';
// import 'package:rajneta/Pages/allPosition.dart';
// import 'package:rajneta/Pages/bluetoothSlipReportByUser.dart';
// import 'package:rajneta/Pages/allAdderss.dart';
// import 'package:rajneta/Pages/allAgeList.dart';
// import 'package:rajneta/Pages/AllCasteList.dart';
// import 'package:rajneta/Pages/allColorCode.dart';
// import 'package:rajneta/Pages/allDead.dart';
// import 'package:rajneta/Pages/allGender.dart';
// import 'package:rajneta/Pages/allHouseNo.dart';
// import 'package:rajneta/Pages/allNewAdderss.dart';
// import 'package:rajneta/Pages/allPartNO.dart';
// import 'package:rajneta/Pages/allSociety.dart';
// import 'package:rajneta/Pages/allSuraname.dart';
// import 'package:rajneta/Pages/allTaluka.dart';
// import 'package:rajneta/Pages/allTaluka.dart';
// import 'package:rajneta/Pages/allvotingCenter.dart';
// import 'package:rajneta/Pages/allDemandsList.dart';
// import 'package:rajneta/Pages/allExtraChech1.dart';
// import 'package:rajneta/Pages/allExtraCheck2.dart';
// import 'package:rajneta/Pages/allExtraInfo1.dart';
// import 'package:rajneta/Pages/allExtraInfo2.dart';
// import 'package:rajneta/Pages/allExtraInfo3.dart';
// import 'package:rajneta/Pages/allExtraInfo4.dart';
// import 'package:rajneta/Pages/allExtraInfo5.dart';
// import 'package:rajneta/Pages/allMobileNo.dart';
// import 'package:rajneta/Pages/allRepeated.dart';
// import 'package:rajneta/Pages/slipPrintReport.dart';
// import 'package:rajneta/Pages/allStareVoter.dart';
// import 'package:rajneta/Pages/allTodayBirthday.dart';
// import 'package:rajneta/Pages/allVoted.dart';
// import 'package:rajneta/Pages/voterSlipPdf.dart';
// import 'package:rajneta/Pages/allVoterWithoutMobile.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:rajneta/Pages/voterDetailPage.dart';
// import '../../Utils/colors.dart';
// import '../LocalizationService.dart';
// import '../Utils/colors.dart';
// import '../alphabeticalList.dart';
// import '../exportToPDF.dart';
// import '../exporttoExcel.dart';
// import 'LocalizationService.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// import 'alphabeticalList.dart';
// import 'exportToPDF.dart';
// import 'exporttoExcel.dart';
//
// class ByVillageList extends StatefulWidget {
//
//   final String itemName;
//   final String selectedLanguage;
//
//   final List<Map<String, String>> votersData = [
//     {
//       "name": "हरिराव होळकर",
//       "details": "Some data about voter 1",
//       "phone": "1234567890"
//     },
//     {
//       "name": "जिजाबाई शिंदे",
//       "details": "Some data about voter 2",
//       "phone": ""
//     },
//     {
//       "name": "माधवराव पेशवा",
//       "details": "Some data about voter 3",
//       "phone": "0987654321"
//     },
//   ];
//
//   ByVillageList(
//       {Key? key, required this.itemName, required this.selectedLanguage}) : super(key: key);
//
//   @override
//   _ByVillageListState createState() => _ByVillageListState();
// }
//
// class _ByVillageListState extends State<ByVillageList> {
//   List<bool> _showMoreIcons = [];
//   BlueThermalPrinter printer = BlueThermalPrinter.instance;
//   List<BluetoothDevice> devices = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _showMoreIcons = List.filled(widget.votersData.length, false);
//     _getBluetoothDevices();
//   }
//
//   Future<void> _getBluetoothDevices() async {
//     devices = await printer.getBondedDevices();
//     setState(() {});
//   }
//
//   void _printData(String data) async {
//     if (devices.isNotEmpty) {
//       final BluetoothDevice? selectedDevice = await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Select Bluetooth Device"),
//             content: Container(
//               width: double.maxFinite,
//               height: 300,
//               child: ListView.builder(
//                 itemCount: devices.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(devices[index].name ?? ""),
//                     onTap: () => Navigator.pop(context, devices[index]),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       );
//
//       if (selectedDevice != null) {
//         await printer.connect(selectedDevice);
//         await printer.printCustom(data, 2, 1);
//         await printer.disconnect();
//         _showSnackBar('Printing successful!');
//       }
//     } else {
//       _showSnackBar('No Bluetooth devices found!');
//     }
//   }
//
//   void _exportData() => _showSnackBar('Exporting data...');
//
//   void _reportData() async {
//     final pdf = pw.Document();
//
//     pdf.addPage(pw.Page(
//       build: (pw.Context context) => pw.Center(
//         child: pw.Text('Reporting data...'),
//       ),
//     ));
//
//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = '${directory.path}/report.pdf';
//
//     final File file = File(filePath);
//     await file.writeAsBytes(await pdf.save());
//
//     _showSnackBar('PDF saved to $filePath');
//     await OpenFile.open(filePath);
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: Duration(seconds: 2)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     LocalizationService().changeLocale(widget.selectedLanguage);
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.primaryColor,
//         body: Column(
//           children: [
//             _buildHeader(),
//             SizedBox(height: 16),
//             _buildSearchField(),
//             SizedBox(height: 16),
//             _buildVotersList(),
//           ],
//         ),
//         floatingActionButton: _buildFABs(),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(
//         color: AppColors.secondaryColor,
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               widget.itemName.tr,
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: Offset(0, 3))
//           ],
//         ),
//         child: TextField(
//           decoration: InputDecoration(
//             hintText: 'Search Voters',
//             border: InputBorder.none,
//             suffixIcon: Icon(Icons.mic, color: AppColors.secondaryColor),
//             contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildVotersList() {
//     return Expanded(
//       child: ListView.builder(
//         padding: EdgeInsets.all(8.0),
//         itemCount: widget.votersData.length,
//         itemBuilder: (context, index) {
//           final voter = widget.votersData[index];
//           return Column(
//             children: [
//               _buildVoterCard(voter, index),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildVoterCard(Map<String, String> voter, int index) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => VoterDetailPage(
//               voterName: voter['name']!,
//               voterDetails: voter['details']!,
//               selectedLanguage: widget.selectedLanguage,
//             ),
//           ),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Container(
//           height: 70,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       voter['name']!,
//                       style:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       voter['phone'] ?? 'No phone number available',
//                       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.menu, color: AppColors.secondaryColor),
//                 onPressed: _showOptionsDialog,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showOptionsDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Select an Option"),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.analytics),
//                 title: Text("More Analysis"),
//                 onTap: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                   _showSnackBar('More Analysis selected');
//                   _showOptionsDialog1(); // Assuming this is another dialog function
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.picture_as_pdf),
//                 title: Text("Export to PDF"),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Exporttopdf(
//                           itemName: widget.itemName,
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ));
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.table_chart),
//                 title: Text("Export to Excel"),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ExportToExcel(
//                           itemName: widget.itemName,
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ));
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.picture_as_pdf),
//                 title: Text("Voter Slip PDF"),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Voterslippdf(
//                           itemName: widget.itemName,
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ));
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.group),
//                 title: Text("Bulk Survey"),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _showSnackBar('Bulk Survey started...');
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   void _showOptionsDialog1() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("More Analysis "),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("alphabetical list".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AlphabeticalList(
//                           itemName: 'alphabetical list',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Village".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByVillageList(
//                           itemName: 'By Village',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Part No".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByPartNo(
//                           itemName: 'By Part No',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By voiting center".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByVotingCenter(
//                           itemName: 'By voiting center',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Personnel".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByPersonnel(
//                           itemName: 'By Personnel',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Surname".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BySuraname(
//                           itemName: 'By Surname',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Colour Code".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByColorCode(
//                           itemName: 'By Colour Code',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Mobile No List".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MobileNoList(
//                           itemName: 'Mobile No List',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("VotercWithout Mobile".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => VoterWithoutMobile(
//                           itemName: 'VotercWithout Mobile',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Adderss".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByAdderss(
//                           itemName: 'By Adderss',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By New Adderss".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByNewAdderss(
//                           itemName: 'By New Adderss',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Society".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BySociety(
//                           itemName: 'By Society',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Gender".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByGender(
//                           itemName: 'By Gender',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Age".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByAge(
//                           itemName: 'By Age',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Caste".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByCast(
//                           itemName: 'By Caste',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Position".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByPosition(
//                           itemName: 'By Position',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Dead".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByDead(
//                           itemName: 'By Dead',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Repeated".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Repeated(
//                           itemName: 'Repeated',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Star Voter".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => StareVoter(
//                           itemName: 'Star Voter',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Extra Ckeck 1".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ExtraCheck1(
//                           itemName: 'Extra Ckeck 1',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Extra Ckeck 2".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ExtraCheck2(
//                           itemName: 'Extra Ckeck 2',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Extra Info 1".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ExtraInfo1(
//                           itemName: 'Extra Info 1',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Extra Info 2".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ExtraInfo2(
//                           itemName: 'Extra Info 2',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Extra Info 3".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ExtraInfo3(
//                           itemName: 'Extra Info 3',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Extra Info 4".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ExtraInfo4(
//                           itemName: 'Extra Info 4',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Extra Info 5".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ExtraInfo5(
//                           itemName: 'Extra Info 5',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By House No".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByHouseNo(
//                           itemName: 'By House No',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Demands List".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DemandsList(
//                           itemName: 'Demands List',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("voted".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Voted(
//                           itemName: 'voted',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Survey Team".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BySurveyTeam(
//                           itemName: 'By Survey Team',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("By Taluka".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ByTaluka(
//                           itemName: 'By Taluka',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Today BirthDay".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TodayBirthDay(
//                           itemName: 'Today BirthDay',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Slip Printer Report".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SlipPrinterReport(
//                           itemName: 'Slip Printer Report',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.analytics),
//                   title: Text("Bluetooth Slip Report By User".tr),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BluetoothSlipReportByUser(
//                           itemName: 'Bluetooth Slip Report By User',
//                           selectedLanguage: widget.selectedLanguage,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//   Widget _buildFABs() {
//     return FloatingActionButton(
//       onPressed: _exportData,
//       child: Icon(Icons.save),
//       backgroundColor: AppColors.secondaryColor,
//     );
//   }
// }
