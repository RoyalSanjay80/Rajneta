import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rajneta/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LocalizationService.dart';
import 'VoterDetailPage.dart';
import 'package:http/http.dart' as http;
import 'allvoterdata.dart';

class Familypage extends StatefulWidget {
  final String selectedLanguage;
  final String name;
  final String voterid;

  Familypage({
    super.key,
    required this.selectedLanguage,
    required this.name,
    required this.voterid,
  });

  @override
  State<Familypage> createState() => _FamilypageState();
}

class _FamilypageState extends State<Familypage> {
  bool _isSelected = false; // State variable for selection
  late Future<List<Map<String, String>>> _voterData;

  @override
  void initState() {
    super.initState();
    LocalizationService().changeLocale(widget.selectedLanguage);
    _voterData = fetchVoterData();

  }

  Future<List<Map<String, String>>> fetchVoterData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('No authentication token found. Please log in again.');
      }

      final shortLangCode = widget.selectedLanguage.substring(0, 2).toLowerCase();
      final url =
          'https://rajneta.fusiontechlab.site/api/family-member-list?id=${widget.voterid}&lang=$shortLangCode';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['voters'] != null) {
          return List<Map<String, String>>.from(data['voters'].map((voter) {
            return {
              "name": voter['first_name']?.toString() ?? "N/A",
              "details": voter['voter_id']?.toString() ?? "N/A",
              "id": voter['id']?.toString() ?? "N/A",
            };
          }));
        } else {
          return [];
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Unexpected HTTP Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching voter data: $e');
    }
  }

  Future<void> removeFamilyMember(String idWhoRemove, String idWhomRemove) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('No authentication token found. Please log in again.');
      }

      final url = 'https://rajneta.fusiontechlab.site/api/family-member-remove';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id_who_remove': idWhoRemove,
          'id_whom_remove': idWhomRemove,
        },
      );

      if (response.statusCode == 200) {
        print('Family member removed successfully');
      } else {
        throw Exception('Failed to remove family member');
      }
    } catch (e) {
      print('Error removing family member: $e');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    // LocalizationService().changeLocale(widget.selectedLanguage);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: FutureBuilder<List<Map<String, String>>>(
        future: _voterData,  // Data load karne ke liye Future call
        builder: (context, snapshot) {
          // Jab tak data load ho raha ho
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Yahan pe placeholder ya loading indicator dikhaye
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),  // Loading indicator
                  SizedBox(height: 20),
                  Text("Loading data... Please wait.", style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            );
          }

          // Agar error aayi ho data fetch karte waqt
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          // Agar data nahi milta (empty list)
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Column(
              children: [
                Expanded(child: Center(child: Text('No family members found.'))),
                _buildFooter(),
              ],
            );
          }

          // Jab data successfully aa jaata hai
          final votersData = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: votersData.length,
                  itemBuilder: (context, index) {
                    final voter = votersData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VoterDetailPage(
                                voterName: voter['name']!,
                                voterDetails: voter['id']!,
                                selectedLanguage: widget.selectedLanguage,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 11.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      voter['name']!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      voter['details']!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_forever, color: Colors.red),
                                onPressed: () {
                                  String idWhoRemove = widget.voterid;
                                  String idWhomRemove = voter['id']!;

                                  // Family member remove karne ka API call
                                  removeFamilyMember(idWhoRemove, idWhomRemove);

                                  setState(() {
                                    votersData.removeAt(index);  // UI update after removal
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildFooter(),
            ],
          );
        },
      ),
    );
  }


  Widget _buildFooter() {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Family By Name", style: TextStyle(fontSize: 15)),
                Row(
                  children: [
                    Switch(
                      value: _isSelected,
                      onChanged: (bool value) {
                        setState(() {
                          _isSelected = value;
                        });
                      },
                      activeColor: Colors.orange,
                      inactiveThumbColor: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    MaterialButton(
                      color: Colors.orange,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllVotersData(
                              itemName: widget.name,
                              selectedLanguage: widget.selectedLanguage,
                              voterid: widget.voterid,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "ADD MEMBER TO FAMILY",
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFooterButton("Print", () {}),
              _buildFooterButton("Share", (){}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton(String label, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 20, color: AppColors.backgroundColor),
      ),
      color: AppColors.secondaryColor,
    );
  }

  // void _shareDetails() {
  //   Share.share(
  //     'Voter Name: ${widget.name}, Voter ID: ${widget.voterid}',
  //   );
  // }
}
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:rajneta/Utils/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'LocalizationService.dart';
// import 'VoterDetailPage.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';
// import 'allvoterdata.dart';
//
// class Familypage extends StatefulWidget {
//   final String selectedLanguage;
//   final String name;
//   final String voterid;
//
//   Familypage({
//     super.key,
//     required this.selectedLanguage,
//     required this.name,
//     required this.voterid,
//   });
//
//   @override
//   State<Familypage> createState() => _FamilypageState();
// }
//
// class _FamilypageState extends State<Familypage> {
//   bool _isSelected = false; // State variable for selection
//   late Future<List<Map<String, String>>> _voterData;
//
//   @override
//   void initState() {
//     super.initState();
//     _voterData = fetchVoterData();
//   }
//
//   Future<List<Map<String, String>>> fetchVoterData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       if (token == null) {
//         throw Exception('No authentication token found. Please log in again.');
//       }
//
//       final shortLangCode = widget.selectedLanguage.substring(0, 2).toLowerCase();
//       final url =
//           'https://rajneta.fusiontechlab.site/api/family-member-list?id=${widget.voterid}&lang=$shortLangCode';
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['voters'] != null) {
//           return List<Map<String, String>>.from(data['voters'].map((voter) {
//             return {
//               "name": voter['first_name']?.toString() ?? "N/A",
//               "details": voter['voter_id']?.toString() ?? "N/A",
//               "id": voter['id']?.toString() ?? "N/A",
//             };
//           }));
//         } else {
//           return [];
//         }
//       } else if (response.statusCode == 404) {
//         return [];
//       } else {
//         throw Exception(
//             'Unexpected HTTP Status Code: ${response.statusCode}, Body: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching voter data: $e');
//     }
//   }
//
//   Future<void> removeFamilyMember(String idWhoRemove, String idWhomRemove) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       if (token == null) {
//         throw Exception('No authentication token found. Please log in again.');
//       }
//
//       final url = 'https://rajneta.fusiontechlab.site/api/family-member-remove';
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Authorization': 'Bearer $token'},
//         body: {
//           'id_who_remove': idWhoRemove,
//           'id_whom_remove': idWhomRemove,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print('Family member removed successfully');
//       } else {
//         throw Exception('Failed to remove family member');
//       }
//     } catch (e) {
//       print('Error removing family member: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     LocalizationService().changeLocale(widget.selectedLanguage);
//
//     return Scaffold(
//       backgroundColor: AppColors.primaryColor,
//       body: FutureBuilder<List<Map<String, String>>>(
//         future: _voterData,
//         builder: (context, snapshot) {
//           // Placeholder data
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             List<Map<String, String>> dummyData = [
//               {"name": "Loading...", "details": "Please wait", "id": "N/A"},
//             ];
//
//             return Stack(
//               children: [
//                 // Placeholder UI
//                 Column(
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: dummyData.length,
//                         itemBuilder: (context, index) {
//                           final voter = dummyData[index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Container(
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(15),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.4),
//                                     spreadRadius: 2,
//                                     blurRadius: 10,
//                                     offset: Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(1.0),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           voter['name']!,
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         SizedBox(height: 4),
//                                         Text(
//                                           voter['details']!,
//                                           style: TextStyle(
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     _buildFooter(),
//                   ],
//                 ),
//
//                 // Loader overlay
//                 Positioned.fill(
//                   child: Container(
//                     color: Colors.black.withOpacity(0.5), // Background dimming
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.orange,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//
//           // Error handling
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: TextStyle(color: Colors.red),
//               ),
//             );
//           }
//
//           // No data found
//           if (snapshot.hasData && snapshot.data!.isEmpty) {
//             return Column(
//               children: [
//                 Expanded(child: Center(child: Text('No family members found.'))),
//                 _buildFooter(),
//               ],
//             );
//           }
//
//           // Real data after successful load
//           final votersData = snapshot.data!;
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: votersData.length,
//                   itemBuilder: (context, index) {
//                     final voter = votersData[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => VoterDetailPage(
//                                 voterName: voter['name']!,
//                                 voterDetails: voter['id']!,
//                                 selectedLanguage: widget.selectedLanguage,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.4),
//                                 spreadRadius: 2,
//                                 blurRadius: 10,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(1.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       voter['name']!,
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           voter['details']!,
//                                           style: TextStyle(
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               _buildFooter(),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//
//
//
//
//   Widget _buildFooter() {
//     return Container(
//       color: AppColors.backgroundColor,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Family By Name", style: TextStyle(fontSize: 15)),
//                 Row(
//                   children: [
//                     Switch(
//                       value: _isSelected,
//                       onChanged: (bool value) {
//                         setState(() {
//                           _isSelected = value;
//                         });
//                       },
//                       activeColor: Colors.orange,
//                       inactiveThumbColor: Colors.grey,
//                     ),
//                     SizedBox(width: 8),
//                     MaterialButton(
//                       color: Colors.orange,
//                       textColor: Colors.white,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AllVotersData(
//                               itemName: widget.name,
//                               selectedLanguage: widget.selectedLanguage,
//                               voterid: widget.voterid,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "ADD MEMBER TO FAMILY",
//                         style: TextStyle(fontSize: 10),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildFooterButton("Print", () {}),
//               _buildFooterButton("Share", _shareDetails),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFooterButton(String label, VoidCallback onPressed) {
//     return MaterialButton(
//       onPressed: onPressed,
//       child: Text(
//         label,
//         style: TextStyle(fontSize: 20, color: AppColors.backgroundColor),
//       ),
//       color: AppColors.secondaryColor,
//     );
//   }
//
//   void _shareDetails() {
//     Share.share(
//       'Voter Name: ${widget.name}, Voter ID: ${widget.voterid}',
//     );
//   }
// }
