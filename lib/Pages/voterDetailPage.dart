import 'package:flutter/material.dart';
import '../Utils/colors.dart';
import 'package:get/get.dart';
import 'FamilyPage.dart';
import 'LocalizationService.dart';
import 'SurveyPage.dart';
import 'VoterDetailsPage.dart';

class VoterDetailPage extends StatefulWidget {
  final String voterName;
  final String voterDetails;
  final String selectedLanguage;

  const VoterDetailPage({
    Key? key,
    required this.voterName,
    required this.voterDetails,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  _VoterDetailPageState createState() => _VoterDetailPageState();
}

class _VoterDetailPageState extends State<VoterDetailPage> {
  @override
  void initState() {
    super.initState();
    // Change locale only once when the widget is created
    LocalizationService().changeLocale(widget.selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3, // Number of tabs
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Navigate back on button press
                      },
                    ),
                    SizedBox(width: 10), // Space between icon and text
                    Expanded(
                      child: Text(
                        widget.voterName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16), // Space between header and tab bar

              // Tab Bar
              TabBar(
                labelColor: AppColors.secondaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.secondaryColor,
                tabs: [
                  Tab(text: "details".tr),
                  Tab(text: "family".tr),
                  Tab(text: "survey".tr),
                ],
              ),

              // Tab bar views (content for each tab)
              Expanded(
                child: TabBarView(
                  children: [
                    Voterdetailspage(
                      selectedLanguage: widget.selectedLanguage,
                      name: widget.voterName,
                      voterid: widget.voterDetails,
                    ),

                    // Second tab content: FamilyPage
                    Familypage(
                      selectedLanguage: widget.selectedLanguage,
                      name: widget.voterName,
                      voterid: widget.voterDetails,
                    ),

                    // Third tab content: SurveyPage
                    Surveypage(
                      selectedLanguage: widget.selectedLanguage,
                      voterid: widget.voterDetails,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
