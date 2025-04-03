import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Models/allvoterlistModel.dart';
import '../Utils/colors.dart';

class AllVotersData extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;
  final String voterid;

  const AllVotersData({
    Key? key,
    required this.itemName,
    required this.selectedLanguage,
    required this.voterid,
  }) : super(key: key);

  @override
  _AllVotersDataState createState() => _AllVotersDataState();
}

class _AllVotersDataState extends State<AllVotersData> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<int, bool> _isMoreOptionsVisible = {}; // Track visibility of options for each item

  // Fetch voters data stream with automatic retries
  Stream<List<Voter>> _fetchVotersDataStream() async* {
    final apiUrl = "https://rajneta.fusiontechlab.site/api/all-voter-list";
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
    final apiUrlWithLang = "$apiUrl?lang=$shortLangCode";

    try {
      while (true) {
        final response = await http.get(Uri.parse(apiUrlWithLang), headers: headers);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final allVotersList = AllVotersList.fromJson(responseData);
          yield allVotersList.voters ?? [];
        } else {
          throw Exception('Failed to load voter list');
        }
        await Future.delayed(Duration(seconds: 10)); // Auto-fetch every 10 seconds
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
   final voterDetails="";

  // Function to fetch search results
  Future<List<Voter>> _fetchSearchResults(String query) async {
    final apiUrl = "https://rajneta.fusiontechlab.site/api/search-by-first-name";
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
    final apiUrlWithParams = "$apiUrl?lang=$shortLangCode&first_name=$query";

    try {
      final response = await http.get(Uri.parse(apiUrlWithParams), headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final allVotersList = AllVotersList.fromJson(responseData);
        return allVotersList.voters ?? [];
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Not Found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildSearchBox(),
              _buildVoterList(),
            ],
          ),
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
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.itemName.tr,
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
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value.trim();
            });
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

  Widget _buildVoterList() {
    return FutureBuilder<List<Voter>>(
      future: _searchQuery.isNotEmpty
          ? _fetchSearchResults(_searchQuery) // Fetch search results
          : _fetchVotersDataStream().first, // Fetch full voter list
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No voters found"));
        } else {
          final votersData = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            shrinkWrap: true,
            itemCount: votersData.length,
            itemBuilder: (context, index) {
              final voter = votersData[index];
              final voterName = "${voter.firstName} ${voter.middleName} ${voter.surname}";
              final voterDetails = voter.id != null ? voter.id.toString() : 'No details available';
              return _buildVoterCard(voter, voterName, voterDetails, index);
            },
          );
        }
      },
    );
  }

  Widget _buildVoterCard(Voter voter, String voterName, String voterDetails, int index) {
    return GestureDetector(
      onTap: () {
        // Show a dialog when a voter is tapped
        _showAddFamilyDialog(voter);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 3))],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVoterRow(voterName, index),
                SizedBox(height: 4),
                Text("Voter ID: $voterDetails", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoterRow(String voterName, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(voterName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showAddFamilyDialog(Voter voter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Family Member'),
          content: Text('Do you want to add ${voter.firstName} ${voter.middleName} ${voter.surname} to your family?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addFamilyMember(voter.id!.toInt()); // Pass only voter.id
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Add', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }


  Future<void> _addFamilyMember(int voterId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final idWhoAdd = widget.voterid; // The ID of the person who is adding the member

    if (token == null || token.isEmpty) {
      // Handle the error if the token is not found
      print("Token not found");
      return;
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final apiUrl = "https://rajneta.fusiontechlab.site/api/family-member-add";

    final body = json.encode({
      'id_who_add': idWhoAdd, // The ID of the person adding the member
      'id_whom_add': voterId, // The ID of the voter to add as a family member
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voter with ID $voterId added to your family successfully!')));
        // Handle success response
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${voter.firstName} added to your family successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add voter with ID $voterId to your family')));
        // Handle failure response
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add ${voter.firstName} to your family')));
      }
    } catch (e) {
      // Handle error if the API call fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
