import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rajneta/printController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Models/allvoterlistModel.dart';
import '../../Utils/colors.dart';
import '../voterDetailPage.dart';
import 'package:http/http.dart' as http;

class ItemDetailPage extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  const ItemDetailPage({
    Key? key,
    required this.itemName,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late VoterController voterController;
  bool isloading = true;
  List<Map<String, String>> votersData = [];
  String query = '';
  int? selectedIndex;
  Printcontroller1 printController1=Get.put(Printcontroller1());

  @override
  void initState() {
    super.initState();
    voterController = Get.put(VoterController());
    // Fetch voters data when the page loads
    voterController.fetchVotersData(widget.selectedLanguage.substring(0, 2).toLowerCase());
    fetchVotersData();
  }

  Future<void> fetchVotersData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token not found');

      setState(() => isloading = true);

      final response = await http.get(
        Uri.parse(
            'https://rajneta.fusiontechlab.site/api/all-voter-list?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isloading = false;
          votersData = List<Map<String, String>>.from(data['voters'].map((dynamic item) {
            return {
              'name': [
                item['first_name']?.toString() ?? '',
                item['middle_name']?.toString() ?? '',
                item['last_name']?.toString() ?? '',
              ].where((namePart) => namePart.isNotEmpty).join(' '),
              'F_name': item['first_name']?.toString() ?? '',
              'M_name': item['middle_name']?.toString() ?? '',
              'details': item['id']?.toString() ?? 'No details available',
              'voterId': item['voter_id']?.toString() ?? 'No voter ID available',
              'number': item['mobile_1']?.toString() ?? 'No voter ID available',
              'partNo': item['voter_address']?['part_no']?.toString() ?? '*',
              'booth': item['voter_address']?['booth']?.toString() ?? '*',
              'srn': item['voter_address']?['srn']?.toString() ?? 'No SRN available',

            };
          }).toList());
        });
      } else {
        throw Exception('Failed to load voters data');
      }
    } catch (e) {
      setState(() => isloading = false);
      print('Error fetching data: $e');
    }
  }

  Future<void> searchVoters(String query) async {
    if (query.isEmpty) {
      await fetchVotersData();
      return;
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token not found');

      setState(() {
        isloading = true;
      });

      final response = await http.get(
        Uri.parse(
          'https://rajneta.fusiontechlab.site/api/search-by-first-name?lang=${widget.selectedLanguage.substring(0, 2).toLowerCase()}&first_name=$query',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['voters'] != null) {
          setState(() {
            votersData = List<Map<String, String>>.from(
              data['voters'].map((voter) {
                return {
                  'name': voter['first_name']?.toString() ?? '',
                  'voterId': voter['voter_id']?.toString() ?? 'No voter ID available',
                  'image': voter['image']?.toString() ?? '',
                  'age': voter['age']?.toString() ?? 'N/A',
                  'gender': voter['gender']?.toString() ?? 'N/A',
                  'number': voter['mobile_1']?.toString() ?? 'No mobile number available',
                };
              }),
            );
            isloading = false;
          });
        } else {
          setState(() {
            votersData = [];
            isloading = false;
          });
        }
      } else {
        throw Exception('Failed to search voters: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print('Error searching voters: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildSearchBox(),
            Expanded(child: _buildVotersList()), // Ensures scrolling works
          ],
        ),
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
            onPressed: () => Get.back(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.itemName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
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
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            query = value;
            searchVoters(query);
          },
          decoration: InputDecoration(
            hintText: 'Search Voters',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: AppColors.secondaryColor),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildVotersList() {
    if (isloading) {
      // Show a loading spinner or skeleton loader
      return _buildSkeletonLoader();
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: votersData.length, // Use state-managed votersData
        itemBuilder: (context, index) {
          final voter = votersData[index];
          return Column(
            children: [
              _buildVotersCard(voter, index),
            ],
          );
        },
      );
    }
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.3),
            highlightColor: Colors.grey.withOpacity(0.1),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 10,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 60,
                          height: 10,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildVotersCard(Map<String, String> voter, int index) {
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  voter['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: AppColors.secondaryColor),
                  onPressed: () {
                    setState(() {
                      selectedIndex = selectedIndex == index ? null : index;
                    });
                  },
                ),
              ],
            ),
            Text(voter['voterId']!),
            if (selectedIndex == index)
              printController1.buildActionRow1(
                  context,
                  voter['number'] ?? 'Unknown',
                  voter['details'] ?? 'Unknown',
                  widget.selectedLanguage.substring(0, 2).toLowerCase()

              ),
          ],
        ),
      ),
    );
  }
}


class VoterController extends GetxController {
  RxList<Voter> voters = <Voter>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  Future<void> fetchVotersData(String langCode) async {
    final apiUrl = "https://rajneta.fusiontechlab.site/api/all-voter-list";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      errorMessage.value = 'Authorization token not found';
      isLoading.value = false;
      return;
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final apiUrlWithLang = "$apiUrl?lang=$langCode";

    try {
      final response = await http.get(Uri.parse(apiUrlWithLang), headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final allVotersList = AllVotersList.fromJson(responseData);
        voters.value = allVotersList.voters ?? [];
      } else {
        errorMessage.value = 'Failed to load voter list';
      }
    } catch (e) {
      errorMessage.value = 'Network Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
