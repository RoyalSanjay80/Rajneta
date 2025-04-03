import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Utils/colors.dart';
import 'Search/ItemDetailsPage.dart';
import 'LocalizationService.dart';
import 'VoterDetailPage.dart';
 // Assuming you have a VoterController that manages the API call

class Advancesearchlist extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;
  final Map<String, String> formData;
  final Map<String, dynamic>? apiResponse; // New parameter for API response

  const Advancesearchlist({
    Key? key,
    required this.itemName,
    required this.selectedLanguage,
    required this.formData,
    this.apiResponse,
  }) : super(key: key);

  @override
  State<Advancesearchlist> createState() => _AdvancesearchlistState();
}

class _AdvancesearchlistState extends State<Advancesearchlist> {
  final VoterController voterController = Get.put(VoterController());

  @override
  void initState() {
    super.initState();
    // Fetch the initial voters data if no API response is passed
    if (widget.apiResponse == null) {
      voterController.fetchVotersData(widget.selectedLanguage.substring(0, 2).toLowerCase());
      // LocalizationService().changeLocale(widget.selectedLanguage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildSearchBox(),
            SizedBox(height: 20),
            if (widget.apiResponse != null)
              _buildApiResponseData()
            else
              _buildLoadingIndicator(), // Loading indicator while fetching

          ],
        ),
      ),
    );
  }

  Widget _buildApiResponseData() {
    // Ensure the 'voters' key is accessed
    if (widget.apiResponse?['voters'] == null || (widget.apiResponse?['voters'] as List).isEmpty) {
      return Center(child: Text('No voters found.'));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: widget.apiResponse!['voters'].length, // Access 'voters' instead of 'data'
        itemBuilder: (context, index) {
          var item = widget.apiResponse!['voters'][index];
           var name='${item['surname']} ${item['first_name']} ${item['middle_name'] ?? ''}';
           var id= '${item['id']}';
          return Card(
            child: ListTile(
              title: Text(name),
              subtitle: Text(item['voter_id'] ?? 'No Voter ID'),
              onTap: () {
                // Handle item click (e.g., navigate to another page)
                Navigator.push(context, MaterialPageRoute(builder: (context) => VoterDetailPage(
                  voterName: name,
                  voterDetails: id,
                  selectedLanguage: widget.selectedLanguage,

                ),));
              },
            ),
          );
        },
      ),
    );
  }


  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
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
}
