import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/voterdetails.dart';
import 'LocalizationService.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Surveypage extends StatefulWidget {
  final String selectedLanguage;
  final String voterid;

  Surveypage(
      {super.key, required this.selectedLanguage, required this.voterid});

  @override
  State<Surveypage> createState() => _SurveypageState();
}

class _SurveypageState extends State<Surveypage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController1 = TextEditingController();
  final TextEditingController _mobileController2 = TextEditingController();
  final TextEditingController _adderssController = TextEditingController();
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _emailcon = TextEditingController();
  final TextEditingController _demandscon = TextEditingController();
  final TextEditingController _ExtraI1con = TextEditingController();
  final TextEditingController _ExtraI2con = TextEditingController();
  final TextEditingController _ExtraI3con = TextEditingController();
  final TextEditingController _ExtraI4con = TextEditingController();
  final TextEditingController _ExtraI5con = TextEditingController();
  final String apiUrl =
      "https://rajneta.fusiontechlab.site/api/survey-details-update";
  bool _isSwitchOn = false;
  String _mobileNumber1 = "123467890";
  String _mobileNumber2 = "123467890";
  String _adderss = "";
  String _flat = "";
  String _email = "";
  String _demands = "";
  String _extra1 = "";
  String _extra2 = "";
  String _extra3 = "";
  String _extra4 = "";
  String _extra5 = "";
  DateTime selectedDate = DateTime.now();

  TextEditingController _dateController = TextEditingController();
  Color selectedColor = AppColors.secondaryColor;
  String? selectedCast;
  // final List<String> castOptions = ["Select Cast", "Cast 1", "Cast 2", "Cast 3"];
  List<String> castOptions = [];
  bool isLoadingCast = true;

  Future<void> _fetchCastList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      final response = await http.get(
        Uri.parse("https://rajneta.fusiontechlab.site/api/caste-list?lang=en"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        setState(() {
          castOptions = (data['castes'] as List)
              .map((item) => item['cast']?.toString() ?? "Unknown") // Null-safe
              .toList();
          isLoadingCast = false;
        });
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch cast list")),
        );
      }
    } catch (e) {
      print("Error fetching cast list: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching cast list")),
      );
    }
  }

  List<bool> _userUpdated = [false, false, false, false];

  String? selectedpos;
  final List<String> posOptions = [
    "Corporator",
    "Sarpanch",
  ];

  bool isYesChecked = false;
  bool isNoChecked = false;
  bool isExtraChecked = false;
  bool isYesChecked1 = false;
  bool isNoChecked1 = false;
  bool isExtraChecked1 = false;
  bool isYesChecked2 = false;
  bool isNoChecked2 = false;
  bool isExtraChecked2 = false;

  bool isYesChecked3 = false;
  bool isNoChecked3 = false;
  bool isExtraChecked3 = false;
  bool isYesChecked4 = false;
  bool isNoChecked4 = false;
  bool isExtraChecked4 = false;

  void _iconAction() {
    // Define the action for the icon button
    print('Icon pressed!');
  }

  @override
  void initState() {
    super.initState();
    _fetchMobileNumberFromAPI();
    LocalizationService().changeLocale(widget.selectedLanguage);
    // _fetchColorCodeFromAPI(); Fetch the current mobile number from API
  }

  @override
  Widget build(BuildContext context) {
    // LocalizationService().changeLocale(widget.selectedLanguage);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(screenWidth, "Mobile-1".tr, _showNumberDialog, _mobileNumber1),
                const SizedBox(height: 10),
                _buildHeaders(screenWidth, "Mobile-2".tr, _showNumberDialog1, _mobileNumber2),
                const SizedBox(height: 10),
                _buildHeader1(
                  screenWidth,
                ),
                const SizedBox(height: 10),
                _buildHeader2(screenWidth, "Caste".tr, _showCastDialog),
                const SizedBox(height: 10),
                _buildHeader3(screenWidth, "Position".tr, _showposDialog),
                const SizedBox(height: 10),
                _buildHeader4(screenWidth, "New address".tr, _showadderssDialog,
                    _adderss),
                const SizedBox(height: 10),
                _buildHeader4(
                    screenWidth, "Flate No".tr, _showflatDialog, _flat),
                const SizedBox(height: 10),
                _buildHeader4(
                    screenWidth, "EmailID".tr, _showemailDialog, _email),
                const SizedBox(height: 10),
                _buildHeader4(
                    screenWidth, "Demands".tr, _showdemendsDialog, _demands),
                const SizedBox(height: 10),
                _buildDatePickerHeader(screenWidth),
                const SizedBox(height: 10),
                _buildHeader4(
                    screenWidth, "Extra Info1".tr, _showextra1Dialog, _extra1),
                const SizedBox(height: 10),
                _buildHeader4(
                    screenWidth, "Extra Info2".tr, _showextra2Dialog, _extra2),
                const SizedBox(height: 10),
                _buildHeader4(
                    screenWidth, "Extra Info3".tr, _showextra3Dialog, _extra3),
                const SizedBox(height: 10),
                _buildHeader4(
                    screenWidth, "Extra Info4".tr, _showextra4Dialog, _extra4),
                const SizedBox(height: 10),
                _buildHeader4(
                    screenWidth, "Extra Info5".tr, _showextra5Dialog, _extra5),
                const SizedBox(height: 10),
                _buildHeader6(
                  "Extra Check-1",
                  isYesChecked,
                  isNoChecked,
                  isExtraChecked, // Pass the Extra Check1 state
                  (value) {
                    setState(() {
                      // Update the state when "Yes" is selected
                      isYesChecked = value ?? false;
                      if (isYesChecked) {
                        isNoChecked =
                            false; // Uncheck "No" when "Yes" is checked
                        isExtraChecked =
                            true; // Set isExtraChecked to true when "Yes" is selected
                      }
                      _updateExtraCheck1(
                          isExtraChecked); // Send the updated state to the API
                    });
                  },
                  (value) {
                    setState(() {
                      // Update the state when "No" is selected
                      isNoChecked = value ?? false;
                      if (isNoChecked) {
                        isYesChecked =
                            false; // Uncheck "Yes" when "No" is checked
                        isExtraChecked =
                            false; // Set isExtraChecked to false when "No" is selected
                      }
                      _updateExtraCheck1(
                          isExtraChecked); // Send the updated state to the API
                    });
                  },
                  () {
                    print("Icon button pressed!"); // Action for icon button
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _buildHeader6(
                  "Extra Check-1",
                  isYesChecked1,
                  isNoChecked1,
                  isExtraChecked1, // Pass the Extra Check1 state
                  (value) {
                    setState(() {
                      // Update the state when "Yes" is selected
                      isYesChecked1 = value ?? false;
                      if (isYesChecked1) {
                        isNoChecked1 =
                            false; // Uncheck "No" when "Yes" is checked
                        isExtraChecked1 =
                            true; // Set isExtraChecked to true when "Yes" is selected
                      }
                      _updateExtraCheck2(
                          isExtraChecked1); // Send the updated state to the API
                    });
                  },
                  (value) {
                    setState(() {
                      // Update the state when "No" is selected
                      isNoChecked1 = value ?? false;
                      if (isNoChecked1) {
                        isYesChecked1 =
                            false; // Uncheck "Yes" when "No" is checked
                        isExtraChecked1 =
                            false; // Set isExtraChecked to false when "No" is selected
                      }
                      _updateExtraCheck2(
                          isExtraChecked1); // Send the updated state to the API
                    });
                  },
                  () {
                    print("Icon button pressed!"); // Action for icon button
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _buildHeader6(
                  "Dead",
                  isYesChecked2,
                  isNoChecked2,
                  isExtraChecked2, // Pass the Extra Check1 state
                  (value) {
                    setState(() {
                      // Update the state when "Yes" is selected
                      isYesChecked2 = value ?? false;
                      if (isYesChecked2) {
                        isNoChecked2 =
                            false; // Uncheck "No" when "Yes" is checked
                        isExtraChecked2 =
                            true; // Set isExtraChecked to true when "Yes" is selected
                      }
                      _dead(
                          isExtraChecked2); // Send the updated state to the API
                    });
                  },
                  (value) {
                    setState(() {
                      // Update the state when "No" is selected
                      isNoChecked2 = value ?? false;
                      if (isNoChecked2) {
                        isYesChecked2 =
                            false; // Uncheck "Yes" when "No" is checked
                        isExtraChecked2 =
                            false; // Set isExtraChecked to false when "No" is selected
                      }
                      _dead(
                          isExtraChecked2); // Send the updated state to the API
                    });
                  },
                  () {
                    print("Icon button pressed!"); // Action for icon button
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _buildHeader6(
                  "star_voter",
                  isYesChecked3,
                  isNoChecked3,
                  isExtraChecked3, // Pass the Extra Check1 state
                  (value) {
                    setState(() {
                      // Update the state when "Yes" is selected
                      isYesChecked3 = value ?? false;
                      if (isYesChecked3) {
                        isNoChecked3 =
                            false; // Uncheck "No" when "Yes" is checked
                        isExtraChecked3 =
                            true; // Set isExtraChecked to true when "Yes" is selected
                      }
                      _saterVoter(
                          isExtraChecked3); // Send the updated state to the API
                    });
                  },
                  (value) {
                    setState(() {
                      // Update the state when "No" is selected
                      isNoChecked3 = value ?? false;
                      if (isNoChecked3) {
                        isYesChecked3 =
                            false; // Uncheck "Yes" when "No" is checked
                        isExtraChecked3 =
                            false; // Set isExtraChecked to false when "No" is selected
                      }
                      _saterVoter(
                          isExtraChecked3); // Send the updated state to the API
                    });
                  },
                  () {
                    print("Icon button pressed!"); // Action for icon button
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _buildHeader6(
                  "Voted",
                  isYesChecked4,
                  isNoChecked4,
                  isExtraChecked4, // Pass the Extra Check1 state
                  (value) {
                    setState(() {
                      // Update the state when "Yes" is selected
                      isYesChecked4 = value ?? false;
                      if (isYesChecked4) {
                        isNoChecked4 =
                            false; // Uncheck "No" when "Yes" is checked
                        isExtraChecked4 =
                            true; // Set isExtraChecked to true when "Yes" is selected
                      }
                      _voted(
                          isExtraChecked4); // Send the updated state to the API
                    });
                  },
                  (value) {
                    setState(() {
                      // Update the state when "No" is selected
                      isNoChecked4 = value ?? false;
                      if (isNoChecked4) {
                        isYesChecked4 =
                            false; // Uncheck "Yes" when "No" is checked
                        isExtraChecked4 =
                            false; // Set isExtraChecked to false when "No" is selected
                      }
                      _voted(
                          isExtraChecked4); // Send the updated state to the API
                    });
                  },
                  () {
                    print("Icon button pressed!"); // Action for icon button
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerHeader(double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "DOB".tr,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          Text(
            "${selectedDate.toLocal()}"
                .split(' ')[0], // Displaying selected date
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[600],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.secondaryColor),
            onPressed: () => selectDate(context),
          ),
        ],
      ),
    );
  }



  Widget _buildHeader6(
    String text,
    bool isYesChecked,
    bool isNoChecked,
    bool isExtraChecked, // For Extra Check1
    ValueChanged<bool?> onYesChanged,
    ValueChanged<bool?> onNoChanged,
    VoidCallback onIconPressed,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Checkbox(
                      value: isYesChecked,
                      onChanged: onYesChanged, // Yes checkbox
                    ),
                    const Text("Yes"),
                    const SizedBox(width: 10),
                    Checkbox(
                      value: isNoChecked,
                      onChanged: onNoChanged, // No checkbox
                    ),
                    const Text("No"),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon:
                Icon(Icons.person_add_rounded, color: AppColors.secondaryColor),
            onPressed: onIconPressed, // Action for the icon button
          ),
        ],
      ),
    );
  }

  Widget _buildHeader4(
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
                onPressed: onEdit, // Using the passed function
              ),
              // ),
              // const SizedBox(width: 10),
              // Icon(Icons.person_2_outlined, color: AppColors.secondaryColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader1(double screenWidth) {
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
                  "Color Code",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _openColorPicker,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader2(double screenWidth, String text, VoidCallback onEdit) {
    return _buildCastSelector(screenWidth, text, onEdit);
  }

  Widget _buildHeader3(double screenWidth, String text, VoidCallback onEdit) {
    return _buildPosSelector(screenWidth, text, onEdit);
  }

  Widget _buildCastSelector(
      double screenWidth, String text, VoidCallback onEdit) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Text(selectedCast ?? "Select Cast"),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: onEdit, // Using the passed function
              ),
              const SizedBox(width: 10),
              Icon(Icons.person_2_outlined, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPosSelector(
      double screenWidth, String text, VoidCallback onEdit) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Text(selectedpos ?? "Select Postion"),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: onEdit, // Using the passed function
              ),
              const SizedBox(width: 10),
              Icon(Icons.person_2_outlined, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  void _showCastDialog() async {
    await _fetchCastList(); // Fetch cast list before showing dialog

    if (castOptions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No cast options available")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Cast'),
          content: isLoadingCast
              ? Center(
                  child:
                      CircularProgressIndicator()) // Show loader while fetching
              : SingleChildScrollView(
                  child: ListBody(
                    children: castOptions.map((cast) {
                      return ListTile(
                        title: Text(cast),
                        onTap: () {
                          setState(() {
                            selectedCast = cast;
                          });
                          _updatecast(selectedCast!);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showposDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Cast'),
          content: SingleChildScrollView(
            child: ListBody(
              children: posOptions.map((postion) {
                return ListTile(
                  title: Text(postion),
                  onTap: () {
                    setState(() {
                      selectedpos = postion;
                    });
                    _updatepos(selectedpos!);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }






  Future<void> _fetchMobileNumberFromAPI() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      final response = await http.get(
        Uri.parse(
            "https://rajneta.fusiontechlab.site/api/individual-voter-details?lang=en&id=${widget.voterid}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final votersDetails = votersDetailsFromJson(response.body);
        print(votersDetails);

        setState(() {
          _mobileNumber1 = votersDetails.voter?.mobile1 ?? "";
          _mobileNumber2 = votersDetails.voter?.mobile2 ?? "";
          _flat = votersDetails.voter?.voterAddress?.flatNo ?? "";
          _flatController.text = _flat;
          _adderss = votersDetails.voter?.voterAddress?.address ?? "";
          _adderssController.text = _adderss;
          _email = votersDetails.voter?.email ?? "";
          _emailcon.text = _email;
          _mobileController1.text = _mobileNumber1;
          _mobileController2.text = _mobileNumber2;
          _extra1 = votersDetails.voter?.voterInformation?.extraInfo1 ?? "";
          _ExtraI1con.text = _extra1;
          _extra2 = votersDetails.voter?.voterInformation?.extraInfo2 ?? "";
          _ExtraI2con.text = _extra2;
          _extra3 = votersDetails.voter?.voterInformation?.extraInfo3 ?? "";
          _ExtraI3con.text = _extra3;
          _extra4 = votersDetails.voter?.voterInformation?.extraInfo4 ?? "";
          _ExtraI4con.text = _extra4;
          _extra5 = votersDetails.voter?.voterInformation?.extraInfo5 ?? "";
          _ExtraI5con.text = _extra5;

          final dob = votersDetails.voter?.dob?.toString() ??
              DateTime.now().toIso8601String();
          selectedDate = DateTime.parse(dob);
          _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];

          _demands = votersDetails.voter?.demands ?? "";
          _demandscon.text = _demands;
          selectedCast = votersDetails.voter?.cast ?? "";
          selectedpos = votersDetails.voter?.position ?? "";

          // Set isExtraChecked to true if extraCheck1 is 1 (Yes), and false if extraCheck1 is 0 (No)
          // Check if extraCheck1 is 1, set isExtraChecked to true. If it's 0, set isExtraChecked to false.
          isExtraChecked =
              (votersDetails.voter?.voterInformation?.extraCheck1 ?? 0) == 1;
          isYesChecked =
              isExtraChecked; // Set isYesChecked to true if extraCheck1 is 1
          isNoChecked = !isExtraChecked;
          isExtraChecked1 =
              (votersDetails.voter?.voterInformation?.extraCheck2 ?? 0) == 1;
          isYesChecked1 =
              isExtraChecked1; // Set isYesChecked to true if extraCheck1 is 1
          isNoChecked1 = !isExtraChecked1;
          isExtraChecked2 = (votersDetails.voter?.dead ?? 0) == 1;
          isYesChecked2 =
              isExtraChecked2; // Set isYesChecked to true if extraCheck1 is 1
          isNoChecked2 = !isExtraChecked2;
          isExtraChecked3 = (votersDetails.voter?.starVoter ?? 0) == 1;
          isYesChecked3 =
              isExtraChecked3; // Set isYesChecked to true if extraCheck1 is 1
          isNoChecked3 = !isExtraChecked3;

          isExtraChecked4 = (votersDetails.voter?.voted ?? 0) == 1;
          isYesChecked4 =
              isExtraChecked4; // Set isYesChecked to true if extraCheck1 is 1
          isNoChecked4 = !isExtraChecked4;

          // Handle color code parsing safely
          final colorCodeString = votersDetails.voter?.colourCode ?? "";
          if (colorCodeString.isNotEmpty) {
            if (colorCodeString.startsWith("#") &&
                colorCodeString.length == 9) {
              selectedColor =
                  Color(int.parse(colorCodeString.substring(1), radix: 16));
            } else if (colorCodeString.startsWith("#") &&
                colorCodeString.length == 7) {
              selectedColor = Color(int.parse(
                  "FF${colorCodeString.substring(1)}",
                  radix: 16)); // Add alpha if missing
            } else {
              selectedColor = Colors.transparent; // Default if invalid
              print("Invalid color code format: $colorCodeString");
            }
          } else {
            selectedColor =
                Colors.transparent; // Default when color is missing or empty
          }

          print("Fetched color: $selectedColor");
        });
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch mobile number")),
        );
      }
    } catch (e) {
      print("Error fetching data from API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching mobile number")),
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

  Future<void> _updateMobileNumber2(String value) async {
    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs
          .getString('auth_token'); // Replace 'auth_token' with your token key

      if (token == null || token.isEmpty) {
        // Handle missing token
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated mobile number via POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "mobile_2": value,
          'lang': widget.selectedLanguage.substring(0, 2).toLowerCase(),
        }),
      );

      if (response.statusCode == 200) {
        // Successfully updated
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mobile number updated successfully")),
        );
      } else {
        // API returned an error
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

  Future<void> _updateflatNo(String newAddress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "flat_no": newAddress,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("FlatNo updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateemail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "email": email,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("FlatNo updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateaddress(String address) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "address": address,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("FlatNo updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateExtra(String Extra1) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "extra_info_1": Extra1,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("extra_info_1 updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateExtra2(String Extra2) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "extra_info_2": Extra2,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("extra_info_2 updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateExtra3(String Extra3) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "extra_info_3": Extra3,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("extra_info_3 updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateExtra4(String Extra4) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "extra_info_4": Extra4,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("extra_info_4 updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateExtra5(String Extra5) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "extra_info_4": Extra5,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("extra_info_5 updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateDate(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "dob": date.toIso8601String(),
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("extra_info_5 updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateDemends(String demends) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "demands": demends,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("_updateDemends updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updatecast(String cast) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "cast": cast,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("_updateDemends updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updatepos(String pos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token =
          prefs.getString('auth_token'); // Replace with your token key

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Send the updated address via POST request
      final response = await http.post(
        Uri.parse(
            apiUrl), // Ensure the API URL is correct for updating the address
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
        body: jsonEncode({
          "id": widget.voterid,
          "position": pos,
          'lang': widget.selectedLanguage
              .substring(0, 2)
              .toLowerCase(), // Use the correct key for the address field
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("position updated successfully")),
        );
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update address")),
        );
      }
    } catch (e) {
      print("Error sending data to API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating address")),
      );
    }
  }

  Future<void> _updateExtraCheck1(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Convert boolean to int (1 for Yes, 0 for No)
      final int extraCheckValue = value ? 1 : 0;
      final int extraCheckValue1 = value ? 1 : 0;

      final requestBody = {
        "id": widget.voterid,
        "extra_check_1": extraCheckValue,
        "extra_check_2": extraCheckValue1,
        'lang': widget.selectedLanguage.substring(0, 2).toLowerCase(),
      };

      print("Sending payload: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      print("Response status: ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Extra Check1 updated successfully")),
        );
        print(
            "Response status: ${response.statusCode}, Body: ${response.body}");

        // Fetch updated data to verify changes
        await _fetchMobileNumberFromAPI();
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update Extra Check1")),
        );
      }
    } catch (e) {
      print("Error updating Extra Check1: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating Extra Check1")),
      );
    }
  }

  Future<void> _updateExtraCheck2(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Convert boolean to int (1 for Yes, 0 for No)

      final int extraCheckValue1 = value ? 1 : 0;

      final requestBody = {
        "id": widget.voterid,
        // "extra_check_1": extraCheckValue,
        "extra_check_2": extraCheckValue1,
        'lang': widget.selectedLanguage.substring(0, 2).toLowerCase(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" updated successfully")),
        );

        await _fetchMobileNumberFromAPI();
      } else {}
    } catch (e) {}
  }

  Future<void> _dead(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Convert boolean to int (1 for Yes, 0 for No)

      final int extraCheckValue1 = value ? 1 : 0;

      final requestBody = {
        "id": widget.voterid,
        // "extra_check_1": extraCheckValue,
        "dead": extraCheckValue1,
        'lang': widget.selectedLanguage.substring(0, 2).toLowerCase(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" updated successfully")),
        );

        await _fetchMobileNumberFromAPI();
      } else {}
    } catch (e) {}
  }

  Future<void> _saterVoter(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Convert boolean to int (1 for Yes, 0 for No)

      final int extraCheckValue1 = value ? 1 : 0;

      final requestBody = {
        "id": widget.voterid,
        // "extra_check_1": extraCheckValue,
        "star_voter": extraCheckValue1,
        'lang': widget.selectedLanguage.substring(0, 2).toLowerCase(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" updated successfully")),
        );

        await _fetchMobileNumberFromAPI();
      } else {}
    } catch (e) {}
  }

  Future<void> _voted(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authorization token is missing")),
        );
        return;
      }

      // Convert boolean to int (1 for Yes, 0 for No)

      final int extraCheckValue1 = value ? 1 : 0;

      final requestBody = {
        "id": widget.voterid,
        // "extra_check_1": extraCheckValue,
        "voted": extraCheckValue1,
        'lang': widget.selectedLanguage.substring(0, 2).toLowerCase(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" updated successfully")),
        );

        await _fetchMobileNumberFromAPI();
      } else {}
    } catch (e) {}
  }

  void _showadderssDialog() {
    _adderssController.text = _adderss;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("New address".tr),
          content: TextField(
            controller: _adderssController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Enter new Edit Adderss",
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
                setState(() {
                  _adderss = _adderssController.text;
                });
                await _updateaddress(_adderss);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showflatDialog() {
    _flatController.text = _flat;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Flate No".tr),
          content: TextField(
            controller: _flatController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Enter  Flat No",
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
                setState(() {
                  _flat = _flatController.text;
                });
                await _updateflatNo(_flat);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showemailDialog() {
    _emailcon.text = _email;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("EmailID".tr),
          content: TextField(
            controller: _emailcon,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Enter  Email Id",
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
                setState(() {
                  _email = _emailcon.text;
                });
                await _updateemail(_email);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showdemendsDialog() {
    _demandscon.text = _demands;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Demands".tr),
          content: TextField(
            controller: _demandscon,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Enter demands",
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
                setState(() {
                  _demands = _demandscon.text;
                });
                await _updateDemends(_demands);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showextra1Dialog() {
    _ExtraI1con.text = _extra1;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Extra Info1".tr),
          content: TextField(
            controller: _ExtraI1con,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Enter Extra info 1",
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
                setState(() {
                  _extra1 = _ExtraI1con.text;
                });
                await _updateExtra(_extra1);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showextra2Dialog() {
    _ExtraI2con.text = _extra2;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Extra Info2".tr),
          content: TextField(
            controller: _ExtraI2con,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Enter Extra info 2",
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
                setState(() {
                  _extra2 = _ExtraI2con.text;
                });
                await _updateExtra2(_extra2);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showextra3Dialog() {
    _ExtraI3con.text = _extra3;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Extra Info3".tr),
          content: TextField(
            controller: _ExtraI3con,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Enter Extra info 3",
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
                setState(() {
                  _extra3 = _ExtraI3con.text;
                });
                await _updateExtra3(_extra3);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showextra4Dialog() {
    _ExtraI4con.text = _extra4;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Extra Info4".tr),
          content: TextField(
            controller: _ExtraI4con,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Enter Extra info 4",
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
                setState(() {
                  _extra4 = _ExtraI4con.text;
                });
                await _updateExtra4(_extra4);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showextra5Dialog() {
    _ExtraI5con.text = _extra5;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Extra Info5".tr),
          content: TextField(
            controller: _ExtraI5con,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Enter Extra info 5",
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
                setState(() {
                  _extra5 = _ExtraI5con.text;
                });
                await _updateExtra5(_extra5);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2500),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text =
            "${selectedDate.toLocal()}".split(' ')[0]; // कंट्रोलर अपडेट करें
      });
      _updateDate(selectedDate); // नई डेट को API पर भेजें
    }
  }

  // Future<void> _openContactList() async {
  //   if (await Permission.contacts.request().isGranted) {
  //     try {
  //       // Fetch contacts using FlutterContacts
  //       Iterable<Contact> contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
  //
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text("Select a Contact"),
  //             content: Container(
  //               width: double.maxFinite,
  //               height: 400,
  //               child: ListView.builder(
  //                 itemCount: contacts.length,
  //                 itemBuilder: (context, index) {
  //                   Contact contact = contacts.elementAt(index);
  //
  //                   // Check if the contact has any phone numbers and get the first one
  //                   String phoneNumber = "No phone number";
  //                   if (contact.phones.isNotEmpty) {
  //                     phoneNumber = contact.phones.first.number ?? "No phone number";
  //                   }
  //
  //                   return ListTile(
  //                     title: Text(contact.displayName ?? "Unknown"),
  //                     subtitle: Text(phoneNumber),
  //                     onTap: () {
  //                       setState(() {
  //                         // Store the phone number
  //                         _mobileNumber1 = phoneNumber;
  //                       });
  //                       Navigator.of(context).pop();
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text("Close"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } catch (e) {
  //       print("Error fetching contacts: $e");
  //     }
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
                onPressed: onEdit, // Using the passed function
              ),
              IconButton(
                icon:
                Icon(Icons.contact_phone, color: AppColors.secondaryColor),
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
  Widget _buildHeaders(
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
                onPressed: onEdit, // Using the passed function
              ),
              IconButton(
                icon:
                Icon(Icons.contact_phone, color: AppColors.secondaryColor),
                onPressed: _showContactListAndSetNumber1,
              ),
              const SizedBox(width: 10),
              Icon(Icons.person_2_outlined, color: AppColors.secondaryColor),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> _showContactListAndSetNumber() async {
    try {
      bool permission = await FlutterContacts.requestPermission();
      if (!permission) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Permission not granted! Please allow contacts access.")),
        );
        return;
      }

      List<Contact> contacts =
      await FlutterContacts.getContacts(withProperties: true);
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
                          _mobileController1.text =
                              phoneNumber; // Yeh line fix karti hai
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

  Future<void> _showContactListAndSetNumber1() async {
    try {
      bool permission = await FlutterContacts.requestPermission();
      if (!permission) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Permission not granted! Please allow contacts access.")),
        );
        return;
      }

      List<Contact> contacts =
      await FlutterContacts.getContacts(withProperties: true);
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
                          _mobileNumber2 = phoneNumber;
                          _mobileController2.text =
                              phoneNumber; // Yeh line fix karti hai
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

  void _showNumberDialog() async {
    _mobileController1.text =
        _mobileNumber1; // Pehle se saved number set karega

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
  void _showNumberDialog1() {
    _mobileController2.text =
        _mobileNumber2; // Pehle se saved number set karega

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Mobile-2".tr),
          content: TextField(
            controller: _mobileController2,
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
                String newNumber = _mobileController2.text;

                if (newNumber.isNotEmpty) {
                  setState(() {
                    _mobileNumber2 = newNumber; // Pehle number update hoga
                  });

                  await _updateMobileNumber2(newNumber); // API call karega

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
}
