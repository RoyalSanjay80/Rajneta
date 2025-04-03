import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajneta/Models/voterdetails.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:rajneta/printController.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LocalizationService.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:pdf/widgets.dart' as pw;
// import 'package:contacts_service/contacts_service.dart';


class Voterdetailspage extends StatefulWidget {
  final String selectedLanguage;
  final String name;
  final String voterid;

  const Voterdetailspage({Key? key, required this.selectedLanguage, required this.name, required this. voterid}) : super(key: key);

  @override
  State<Voterdetailspage> createState() => _VoterdetailspageState();
}

class _VoterdetailspageState extends State<Voterdetailspage> {
  bool matSwitchValue = false; // Switch value
  bool isStarred = false;
  String _mobileNumber1 = ""; // To manage star color
  Color selectedColor = AppColors.secondaryColor;
  late Future<VotersDetails> _voterDetals;
  final TextEditingController _mobileController1 = TextEditingController();
  final String apiUrl = "https://rajneta.fusiontechlab.site/api/survey-details-update";
  final Printcontroller12 printcontroller12=Get.put(Printcontroller12());


  @override
  void initState() {
    super.initState();
    LocalizationService().changeLocale(widget.selectedLanguage);
    _voterDetals = _fetchIndividualDetails(int.parse(widget.voterid));
  }
   Future<VotersDetails>_fetchIndividualDetails(int id) async{
     final apiUrl = "https://rajneta.fusiontechlab.site/api/individual-voter-details";
     final prefs = await SharedPreferences.getInstance();
     final token = prefs.getString('auth_token');
     if (token == null || token.isEmpty) {
       throw Exception('Authorization token not found');
     }

     final headers = {
       'Authorization': 'Bearer $token',
       'Content-Type': 'application/json',
     };

     final shortLangCode = widget.selectedLanguage.substring(0, 2).toLowerCase();
     final apiUrlWithParams = "$apiUrl?lang=$shortLangCode&id=$id";

     final response = await http.get(Uri.parse(apiUrlWithParams), headers: headers);
     if (response.statusCode == 200) {
       final responseData = json.decode(response.body);
       print(responseData);
       return VotersDetails.fromJson(responseData);
     } else {
       throw Exception('Failed to load voter details: ${response.reasonPhrase}');
     }

   }
  late var voter;
  bool voterInitialized = false;

  @override

  Widget build(BuildContext context) {
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: SingleChildScrollView(
          child: FutureBuilder<VotersDetails>(
            future: _voterDetals,
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No voter details available.'));
              }

              if (snapshot.hasData && !voterInitialized) {
                voter = snapshot.data!.voter;
                voterInitialized = true;
              }

              return voter != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildVoterDetailCard(voter.firstName ?? "N/A"),
                  SizedBox(height: 10,),
                  _buildDetailContainer("Village".tr, voter.voterAddress?.village ?? "N/A"),
                  SizedBox(height: 10,),
                  _buildDetailContainer("Voter ID".tr, voter.voterId ?? "N/A"),
                  SizedBox(height: 10,),
                  _buildDetailContainer("House No".tr, voter.voterAddress?.houseNo ?? "N/A"),
                  SizedBox(height: 10,),
                  _buildDetailContainer("Address".tr, voter.voterAddress?.society ?? "N/A"),
                  SizedBox(height: 10,),
                  _buildDetailContainer("Booth".tr, voter.voterAddress?.booth ?? "N/A"),
                  SizedBox(height: 10,),
                  _buildHeader(screenWidth, "Mobile-1".tr, _showNumberDialog,
                      voter.mobile1 ?? ''),
                  SizedBox(height: 10,),
                  _buildCustomRow(matSwitchValue, (newValue) {
                    setState(() {
                      matSwitchValue = newValue;
                    });
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildElevatedButton("Share", null, () => _shareDetails()),
                      _buildElevatedButton("Print", null, () => _printDetails()),
                      _buildElevatedButton("Call", null, () => _makeCall(voter.mobile1 ?? "Not Available Phone Number")),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildElevatedButton("VOTERS ON SAME ADDRESS", null, () => {}),
                  SizedBox(height: screenHeight * 0.01),
                  _buildElevatedButton("VOTERS ON SAME BOOTH", null, () => {}),
                ],
              )
                  : Center(child: Text('Voter details not available.'));
            },
          ),
        ),
      ),
    );
  }
// Helper method to create an ElevatedButton with icon and label
  ElevatedButton _buildElevatedButton(String label, IconData? icon, VoidCallback onPressed, {String? optionalLabel}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : Container(), // Only show icon if it's provided
      label: Text(label, style: TextStyle(fontSize: 18, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryColor,
      ),
    );
  }

  void _makeCall(String phoneNumber) async {
    final phoneNumber = "5874120369";
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      launch('tel:$phoneNumber');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number is not available')),
      );
    }
  }

  void _shareDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Send Voter Details"),
          content: Text("Select how you want to share:"),
          actions: [
            TextButton(
              onPressed: () {
                printcontroller12.buildActionRow1(
                    context,
                    (voter.mobile1 ?? '').toString(), // Ensure String conversion
                    (voter.id ?? '').toString(), // Ensure String conversion
                    widget.selectedLanguage.substring(0, 2).toLowerCase()
                );
              },
              child: Text("Send SMS"),
            ),
            TextButton(
              onPressed: () {
                printcontroller12.buildActionRow1(
                    context,
                    (voter.mobile1 ?? '').toString(), // Ensure String conversion
                    (voter.id ?? '').toString(), // Ensure String conversion
                    widget.selectedLanguage.substring(0, 2).toLowerCase()
                );

              },
              child: Text("WhatsApp"),
            ),
            TextButton(
              onPressed: () {
                // Share via Email
                _shareEmail();
                Navigator.of(context).pop();
              },
              child: Text("Email"),
            ),
            // TextButton(
            //   onPressed: () {
            //     // Share from Gallery (image)
            //     _shareFromGallery();
            //     Navigator.of(context).pop();
            //   },
            //   child: Text("Send from Gallery"),
            // ),
          ],
        );
      },
    );
  }

  void _sendSMS() async {
    final String name = "John Doe"; // Replace with actual data
    final String phoneNumber = '5874120369';
    if (phoneNumber.isEmpty || name.isEmpty) {
      print('Phone number or name is null');
      return; // Early exit if data is not valid
    }

    // Construct the message
    String message = 'Voter Name: $name, Voter ID: $name';

    // URL encode the message body
    String encodedMessage = Uri.encodeComponent(message);

    // Launch the SMS app with pre-filled details
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': encodedMessage},
    );

    print('Attempting to launch: $smsUri'); // Debugging line

    try {
      // Attempt to launch the SMS app
      if (await canLaunch(smsUri.toString())) {
        await launch(smsUri.toString());
      } else {
        print('Could not launch SMS app');
      }
    } catch (e) {
      print('Error launching SMS app: $e');
    }
  }

  void _shareWhatsApp() {
    Share.share('Check out this voter: ${widget.name}, Voter ID: ${widget.name} via WhatsApp');
  }

  void _shareEmail() {
    Share.share('Check out this voter: ${widget.name}, Voter ID: ${widget.name}', subject: 'Voter Details');
  }

  Future<void> _shareFromGallery() async {
    // Pick an image from the gallery
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Share.shareFiles([image.path], text: 'Voter Details: ${widget.name}, ID: ${widget.name}');
      Share.shareXFiles([XFile(image.path)], text: 'Voter Details: ${widget.name}, ID:{widget.id}');
    }
  }


  // Function to print voter details
  void _printDetails() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Voter Details', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('Name: ${widget.name}', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Voter ID: ${widget.name}', style: pw.TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }

  // Voter Detail Card
  Widget _buildVoterDetailCard(String name) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryColor)),
              CircleAvatar(
                backgroundColor: AppColors.secondaryColor,
                child: Icon(Icons.person, color: Colors.white, size: 24),
              ),
            ],
          ),
          SizedBox(height: 16),
          // _buildDetailRow("part no".tr, voter.voterAddress?.srn ?? "N/A"),
          SizedBox(height: 8),
          _buildDetailRow("srn".tr, voter.voterAddress?.srn ?? "N/A"),
          SizedBox(height: 8),
          _buildDetailRow("age".tr, voter.age.toString() ?? "N/A"),
          SizedBox(height: 8),
          _buildDetailRow("gender".tr, voter.gender ?? "N/A"),
        ],
      ),
    );
  }
  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", ""); // Remove #
    if (hex.length == 8) {
      return Color(int.parse("0x$hex")); // Convert ARGB format
    } else if (hex.length == 6) {
      return Color(int.parse("0xFF$hex")); // Convert RGB to ARGB
    }
    return Colors.transparent; // Default color if invalid
  }

  // Custom Row for Color Code, Stare, Mat
  Widget _buildCustomRow(bool value, ValueChanged<bool> onChanged) {
    return Container(
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Color Code with colored container
          GestureDetector(
            onTap: _openColorPicker,
            child: Row(
              children: [
                Text("Color Code", style: TextStyle(fontSize: 16)),
                SizedBox(width: 8), // Spacing between text and container
                Container(
                  height: 30,
                  width: 50, // Adjust the width as needed
                  decoration: BoxDecoration(
                    color: _hexToColor(voter.colourCode), // Set the selected color
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
          // Stare with star icon and tap to change color
          GestureDetector(
            onTap: () {
              setState(() {
                isStarred = !isStarred; // Toggle star color
              });
            },
            child: Row(
              children: [
                Text("Stare", style: TextStyle(fontSize: 16)),
                SizedBox(width: 5),
                Icon(
                  Icons.star,
                  color: isStarred ? Colors.orange : Colors.grey, // Yellow if starred, grey otherwise
                ),
              ],
            ),
          ),
          // Mat with Switch
          Row(
            children: [
              Text("Mat", style: TextStyle(fontSize: 16)),
              SizedBox(width: 5),
              Switch(
                value: value,
                onChanged: onChanged, // Pass function to handle switch state
                activeColor: AppColors.secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Detail Container
  Widget _buildDetailContainer(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildDetailRow(label, value)],
      ),
    );
  }

  // Detail Row
  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text("$label:- ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        Text(
          value.length > 30 // Adjust this number based on your UI needs
              ? '${value.substring(0, 10)}...' // Show truncated text with ellipsis
              : value, // Show full text if it's short enough
          style: TextStyle(color: Colors.black87),
          overflow: TextOverflow.visible, // Allow overflow to be visible
        ),
      ],
    );
  }




  Widget _buildHeader(
      double screenWidth, String text, VoidCallback onEdit, String text1) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    text1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.secondaryColor),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.contact_phone, color: AppColors.secondaryColor),
                onPressed: _showContactListAndSetNumber,
              ),
              const SizedBox(width: 10),
              Icon(Icons.person_2_outlined, color: AppColors.secondaryColor),
            ],
          ),
        ],
      ),
    );
  }

  void _showNumberDialog() async {
    _mobileController1.text = _mobileNumber1; // Pehle se saved number set karega

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Mobile-1".tr),
          content: TextField(
            controller: _mobileController1,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Enter new mobile number",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newNumber = _mobileController1.text;

                if (newNumber.isNotEmpty) {
                  setState(() {
                    _mobileNumber1 = newNumber; // Pehle number update hoga
                  });

                  await _updateMobileNumber(newNumber); // API call karega

                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showContactListAndSetNumber() async {
    try {
      bool permission = await FlutterContacts.requestPermission();
      if (!permission) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission not granted! Please allow contacts access.")),
        );
        return;
      }

      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      if (contacts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No contacts found!")),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select a Contact'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = contacts[index];
                  return ListTile(
                    title: Text(contact.displayName),
                    onTap: () async {
                      if (contact.phones.isNotEmpty) {
                        String phoneNumber = contact.phones.first.number;
                        setState(() {
                          _mobileNumber1 = phoneNumber;
                          _mobileController1.text = phoneNumber; // Yeh line fix karti hai
                        });

                        await _updateMobileNumber(phoneNumber);
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error picking contact: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick contact: $e")),
      );
    }
  }
  Future<void> _updateMobileNumber(String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "id": widget.voterid,
          "mobile_1": value,
          'lang': widget.selectedLanguage.substring(0, 2).toLowerCase(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mobile number updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update mobile number")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating mobile number")),
      );
    }
  }
  // Future<void> _showContactListAndSetNumber() async {
  //   try {
  //     bool permission = await FlutterContacts.requestPermission();
  //     if (!permission) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Permission not granted! Please allow contacts access.")),
  //       );
  //       return;
  //     }
  //
  //     List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
  //     if (contacts.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("No contacts found!")),
  //       );
  //       return;
  //     }
  //
  //     print("Total contacts: ${contacts.length}");
  //
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Select a Contact'),
  //           content: Container(
  //             width: double.maxFinite,
  //             child: ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: contacts.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 Contact contact = contacts[index];
  //                 return ListTile(
  //                   title: Text(contact.displayName),
  //                   onTap: () async {
  //                     if (contact.phones.isNotEmpty) {
  //                       String phoneNumber = contact.phones.first.number;
  //                       setState(() {
  //                         _mobileNumber1 = phoneNumber;
  //                         _mobileController1.text = phoneNumber;
  //                       });
  //                       await _updateMobileNumber(phoneNumber);
  //                       Navigator.of(context).pop();
  //                     }
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text('Cancel'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     print("Error picking contact: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to pick contact: $e")),
  //     );
  //   }
  // }
  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pick a Color"),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor, // Current color
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color; // Update color locally
                });
                _updateColorCode(color); // Send update to the server
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text("Done"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _updateColorCode(Color color) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Convert color to hex code (including alpha)
      String colorCodeHex =
          '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

      // Print the color code being sent
      print("Sending color code to API: $colorCodeHex");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "id": widget.voterid,
          "colour_code": colorCodeHex,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Send the hex color code with leading #
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Color code updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update color code")),
        );
      }
    } catch (e) {
      print("Error updating color code: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating color code")),
      );
    }
  }


}
