// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:rajneta/Utils/colors.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'LocalizationService.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart'as http;
//
//
// class Surveypage extends StatefulWidget {
//   final String selectedLanguage;
//
//   Surveypage({super.key, required this.selectedLanguage});
//
//   @override
//   State<Surveypage> createState() => _SurveypageState();
// }
//
// class _SurveypageState extends State<Surveypage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _adderssController = TextEditingController();
//   final TextEditingController _flatController = TextEditingController();
//   final TextEditingController _emailcon = TextEditingController();
//   final TextEditingController _demandscon = TextEditingController();
//   final TextEditingController _ExtraI1con = TextEditingController();
//   final TextEditingController _ExtraI2con = TextEditingController();
//   final TextEditingController _ExtraI3con = TextEditingController();
//   final TextEditingController _ExtraI4con = TextEditingController();
//   final TextEditingController _ExtraI5con = TextEditingController();
//   final String apiUrl = "https://rajneta.fusiontechlab.site/api/survey-details-update";
//   bool _isSwitchOn = false;
//   String _mobileNumber = "123467890";
//   String _adderss = "";
//   String _flat = "";
//   String _email = "";
//   String _demands = "";
//   String _extra1 = "";
//   String _extra2 = "";
//   String _extra3 = "";
//   String _extra4 = "";
//   String _extra5 = "";
//   DateTime selectedDate = DateTime.now();
//   Color selectedColor = AppColors.secondaryColor;
//   String? selectedCast;
//   final List<String> castOptions = ["Select Cast", "Cast 1", "Cast 2", "Cast 3"];
//
//
//   List<Map<String, bool>> _checkboxStates = [
//     {'yes': false, 'no': false},
//     {'yes': false, 'no': false},
//     {'yes': false, 'no': false},
//     {'yes': false, 'no': false}, // For "Voted"
//   ];
//
//   void _onCheckboxChanged(bool? value, int index, String type) {
//     setState(() {
//       if (type == 'yes') {
//         _checkboxStates[index]['yes'] = value ?? false;
//         if (_checkboxStates[index]['yes'] == true) {
//           _checkboxStates[index]['no'] = false;
//         }
//       } else {
//         _checkboxStates[index]['no'] = value ?? false;
//         if (_checkboxStates[index]['no'] == true) {
//           _checkboxStates[index]['yes'] = false;
//         }
//       }
//     });
//   }
//
//   void _iconAction() {
//     // Define the action for the icon button
//     print('Icon pressed!');
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     LocalizationService().changeLocale(widget.selectedLanguage);
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = mediaQuery.size.width;
//     final screenHeight = mediaQuery.size.height;
//
//     return Scaffold(
//       backgroundColor: AppColors.primaryColor,
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: screenWidth * 0.05,
//           vertical: screenHeight * 0.02,
//         ),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 _buildHeader(screenWidth, "Mobile-1".tr, _showNumberDialog),
//                 const SizedBox(height: 10),
//                 _buildHeader(screenWidth, "Mobile-2".tr, _showNumberDialog),
//                 const SizedBox(height: 10),
//                 _buildHeader1(screenWidth, "Colour Code".tr, _openColorPicker),
//                 const SizedBox(height: 10),
//                 _buildHeader2(screenWidth, "Caste".tr, _showCastDialog),
//                 const SizedBox(height: 10),
//                 _buildHeader3(screenWidth, "Position".tr, _showCastDialog),
//                 const SizedBox(height: 10),
//                 _buildHeader4(screenWidth, "New address".tr, _showadderssDialog,_adderss),
//                 const SizedBox(height: 10),
//                 _buildHeader4(screenWidth, "Flate No".tr, _showflatDialog,_flat),
//                 const SizedBox(height: 10),
//                 _buildHeader4(screenWidth, "EmailID".tr, _showemailDialog,_email),
//                 const SizedBox(height: 10),
//                 _buildHeader4(screenWidth, "Demands".tr, _showdemendsDialog,_demands),
//                 const SizedBox(height: 10),
//                 _buildDatePickerHeader(screenWidth),
//                 const SizedBox(height: 10),
//                 _buildHeader4(screenWidth, "Extra Info1".tr, _showextra1Dialog,_extra1),
//                 const SizedBox(height: 10),
//                 _buildHeader4(screenWidth, "Extra Info2".tr, _showextra2Dialog,_extra2),
//                 const SizedBox(height: 10),
//                 _buildHeader4(screenWidth, "Extra Info3".tr, _showextra3Dialog,_extra3),
//                 const SizedBox(height: 10),
//                 _buildHeader4(screenWidth, "Extra Info4".tr, _showextra4Dialog,_extra4),
//                 const SizedBox(height: 10),
//                 _buildHeader4(screenWidth, "Extra Info5".tr, _showextra5Dialog,_extra5),
//                 const SizedBox(height: 10),
//                 _buildHeader6("Extra Ckeck1".tr, 0),
//                 const SizedBox(height: 10),
//                 _buildHeader6("Extra Ckeck2".tr, 1),
//                 const SizedBox(height: 10),
//                 _buildHeader6("Dead".tr, 2),
//                 const SizedBox(height: 10),
//                 _buildHeader6("Voted".tr,3),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   void _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//         selectedDate = pickedDate;
//       });
//     }
//   }
//
//   Widget _buildDatePickerHeader(double screenWidth) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: AppColors.backgroundColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "DOB".tr,
//             style: TextStyle(
//               fontSize: screenWidth * 0.045,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primaryColor,
//             ),
//           ),
//           Text(
//             "${selectedDate.toLocal()}".split(' ')[0], // Displaying selected date
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               color: Colors.grey[600],
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.edit, color: AppColors.secondaryColor),
//             onPressed: () => _selectDate(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(double screenWidth, String text, VoidCallback onEdit) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: AppColors.backgroundColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Row(
//               children: [
//                 Text(
//                   text,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     _mobileNumber,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.04,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.edit, color: AppColors.secondaryColor),
//                 onPressed: onEdit, // Using the passed function
//               ),
//               IconButton(
//                 icon: Icon(Icons.contact_phone, color: AppColors.secondaryColor),
//                 onPressed: _openContactList,
//               ),
//               const SizedBox(width: 10),
//               Icon(Icons.person_2_outlined, color: AppColors.secondaryColor),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildHeader6(String text, int index) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: AppColors.backgroundColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     text,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primaryColor,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: _checkboxStates[index]['yes'],
//                       onChanged: (value) => _onCheckboxChanged(value, index, 'yes'),
//                     ),
//                     Text("Yes"),
//                     SizedBox(width: 10),
//                     Checkbox(
//                       value: _checkboxStates[index]['no'],
//                       onChanged: (value) => _onCheckboxChanged(value, index, 'no'),
//                     ),
//                     Text("No"),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10), // Added spacing between the checkboxes and the icon
//           IconButton(
//             icon: Icon(Icons.person_add_rounded, color: AppColors.secondaryColor),
//             onPressed: _iconAction, // Action for the icon button
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   Widget _buildHeader4(double screenWidth, String text, VoidCallback onEdit,String text1) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: AppColors.backgroundColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Row(
//               children: [
//                 Text(
//                   text,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     text1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.04,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.edit, color: AppColors.secondaryColor),
//                 onPressed: onEdit, // Using the passed function
//               ),
//               // ),
//               // const SizedBox(width: 10),
//               // Icon(Icons.person_2_outlined, color: AppColors.secondaryColor),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader1(double screenWidth, String text, VoidCallback onEdit) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: AppColors.backgroundColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Row(
//               children: [
//                 Text(
//                   text,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: selectedColor,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.edit, color: AppColors.secondaryColor),
//                 onPressed: onEdit, // Using the passed function
//               ),
//               const SizedBox(width: 10),
//               Icon(Icons.person_2_outlined, color: AppColors.secondaryColor),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader2(double screenWidth, String text, VoidCallback onEdit) {
//     return _buildCastSelector(screenWidth, text, onEdit);
//   }
//
//   Widget _buildHeader3(double screenWidth, String text, VoidCallback onEdit) {
//     return _buildCastSelector(screenWidth, text, onEdit);
//   }
//
//   Widget _buildCastSelector(double screenWidth, String text, VoidCallback onEdit) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Row(
//               children: [
//                 Text(
//                   text,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(selectedCast ?? "Select Cast"),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.edit, color: Colors.orange),
//                 onPressed: onEdit, // Using the passed function
//               ),
//               const SizedBox(width: 10),
//               Icon(Icons.person_2_outlined, color: Colors.orange),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showCastDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select a Cast'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: castOptions.map((cast) {
//                 return ListTile(
//                   title: Text(cast),
//                   onTap: () {
//                     setState(() {
//                       selectedCast = cast;
//                     });
//                     Navigator.pop(context);
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showNumberDialog() {
//     _mobileController.text = _mobileNumber; // Set the controller text to current mobile number
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Mobile-1".tr), // Use your translation here
//           content: TextField(
//             controller: _mobileController,
//             keyboardType: TextInputType.phone,
//             decoration: InputDecoration(
//               labelText: "Enter new mobile number",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // Save and update the mobile number
//                 setState(() {
//                   _mobileNumber = _mobileController.text;
//                 });
//
//                 // Call the API to update the number
//                 await _updateMobileNumber();
//
//                 Navigator.of(context).pop(); // Close the dialog after saving
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//
//   Future<void> _updateMobileNumber() async {
//     try {
//       // Retrieve the token from SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('auth_token');  // Replace 'auth_token' with your token key
//
//       if (token == null || token.isEmpty) {
//         // Handle missing token
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Authorization token is missing")),
//         );
//         return;
//       }
//
//       // Send the updated mobile number via POST request
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token", // Pass the token in the Authorization header
//         },
//         body: jsonEncode({
//           "mobile_1": _mobileNumber,
//           // Add any other necessary data here
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         // Successfully updated
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Mobile number updated successfully")),
//         );
//       } else {
//         // API returned an error
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to update mobile number")),
//         );
//       }
//     } catch (e) {
//       print("Error sending data to API: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error updating mobile number")),
//       );
//     }
//   }
//
//
//   void _showadderssDialog() {
//     _adderssController.text = _adderss;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("New address".tr),
//           content: TextField(
//             controller: _adderssController,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               labelText: "Enter new Edit Adderss",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _adderss = _adderssController.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showflatDialog() {
//     _flatController.text = _flat;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Flate No".tr),
//           content: TextField(
//             controller: _flatController,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               labelText: "Enter  Flat No",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _flat = _flatController.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showemailDialog() {
//     _emailcon.text = _email;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("EmailID".tr),
//           content: TextField(
//             controller: _emailcon,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               labelText: "Enter  Email Id",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _email = _emailcon.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showdemendsDialog() {
//     _demandscon.text = _demands;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Demands".tr),
//           content: TextField(
//             controller: _demandscon,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               labelText: "Enter demands",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _demands = _demandscon.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showextra1Dialog() {
//     _ExtraI1con.text = _extra1;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Extra Info1".tr),
//           content: TextField(
//             controller: _ExtraI1con,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               labelText: "Enter Extra info 1",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _extra1 = _ExtraI1con.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showextra2Dialog() {
//     _ExtraI2con.text = _extra2;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Extra Info2".tr),
//           content: TextField(
//             controller: _ExtraI2con,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               labelText: "Enter Extra info 2",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _extra2 = _ExtraI2con.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showextra3Dialog() {
//     _ExtraI3con.text = _extra3;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Extra Info3".tr),
//           content: TextField(
//             controller: _ExtraI3con,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               labelText: "Enter Extra info 3",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _extra3 = _ExtraI3con.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showextra4Dialog() {
//     _ExtraI4con.text = _extra4;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Extra Info4".tr),
//           content: TextField(
//             controller: _ExtraI4con,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               labelText: "Enter Extra info 4",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _extra4 = _ExtraI4con.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showextra5Dialog() {
//     _ExtraI5con.text = _extra5;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Extra Info5".tr),
//           content: TextField(
//             controller: _ExtraI5con,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               labelText: "Enter Extra info 5",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _extra5 = _ExtraI5con.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   Future<void> _openContactList() async {
//     if (await Permission.contacts.request().isGranted) {
//       try {
//         // Fetch contacts using FlutterContacts
//         Iterable<Contact> contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
//
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Text("Select a Contact"),
//               content: Container(
//                 width: double.maxFinite,
//                 height: 400,
//                 child: ListView.builder(
//                   itemCount: contacts.length,
//                   itemBuilder: (context, index) {
//                     Contact contact = contacts.elementAt(index);
//
//                     // Check if the contact has any phone numbers and get the first one
//                     String phoneNumber = "No phone number";
//                     if (contact.phones.isNotEmpty) {
//                       phoneNumber = contact.phones.first.number ?? "No phone number";
//                     }
//
//                     return ListTile(
//                       title: Text(contact.displayName ?? "Unknown"),
//                       subtitle: Text(phoneNumber),
//                       onTap: () {
//                         setState(() {
//                           // Store the phone number
//                           _mobileNumber = phoneNumber;
//                         });
//                         Navigator.of(context).pop();
//                       },
//                     );
//                   },
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("Close"),
//                 ),
//               ],
//             );
//           },
//         );
//       } catch (e) {
//         print("Error fetching contacts: $e");
//       }
//     }
//   }
//
//
//   void _openColorPicker() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Colour Code".tr),
//           content: SingleChildScrollView(
//             child: BlockPicker(
//               pickerColor: selectedColor, // Current color
//               onColorChanged: (Color color) {
//                 setState(() {
//                   selectedColor = color; // Update color on selection
//                 });
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text("Done"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }