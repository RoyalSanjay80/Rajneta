import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rajneta/Pages/List/ByPosition/allPosition.dart';
import 'package:rajneta/Pages/List/By%20Bluetooth%20Slip%20Report%20By%20User/bluetoothSlipReportByUser.dart';

import 'package:rajneta/Pages/List/ByAge/allAgeList.dart';
import 'package:rajneta/Pages/List/ColorCode/allColorCode.dart';
import 'package:rajneta/Pages/List/ByDead/allDead.dart';
import 'package:rajneta/Pages/List/ByGender/allGender.dart';
import 'package:rajneta/Pages/List/By%20House%20Number/allHouseNo.dart';
import 'package:rajneta/Pages/List/ByNewAddress/allNewAdderss.dart';
import 'package:rajneta/Pages/List/ByPartNumber/allPartNO.dart';

import 'package:rajneta/Pages/List/BySurname/allSuraname.dart';
import 'package:rajneta/Pages/List/By%20Taluka/allTaluka.dart';
import 'package:rajneta/Pages/List/By%20SurveyTeam/allSurveyTeam.dart';
import 'package:rajneta/Pages/List/By%20Extra%20Check-1/allExtraChech1.dart';
import 'package:rajneta/Pages/List/ExtraInfo1/allExtraInfo1.dart';
import 'package:rajneta/Pages/List/ExtraInfo3/allExtraInfo3.dart';
import 'package:rajneta/Pages/List/ExtraInfo4/allExtraInfo4.dart';
import 'package:rajneta/Pages/List/ExtraInfo5/allExtraInfo5.dart';

import 'package:rajneta/Pages/List/ByRepeated/allRepeated.dart';
import 'package:rajneta/Pages/List/By%20Slip%20Printer%20Report/slipPrintReport.dart';
import 'package:rajneta/Pages/List/ByStar%20Voter/allStareVoter.dart';
import 'package:rajneta/Pages/List/By%20Today%20Birthday/allTodayBirthday.dart';
import 'package:rajneta/Pages/List/By%20Voted/allVoted.dart';
import 'package:rajneta/Pages/List/VoterWithoutMobileList/allVoterWithoutMobile.dart';
import '../../Utils/colors.dart';

import 'Address/allAdderss.dart';
import 'ByCaste/AllCasteList.dart';
import 'ByMobileNumberList/allMobileNo.dart';
import 'society/allSociety.dart';
import 'ByPersonnel/allPersonnel.dart';
import 'AlphabeticalList/alphabeticalList.dart';
import 'ByViallage/byVillage.dart';
import 'ByVotingCenter/allvotingCenter.dart';
import 'ByDemands List/allDemandsList.dart';
import 'ByExtraCheck2/allExtraCheck2.dart';
import 'ExtraInfo2/allExtraInfo2.dart';

class ListPage extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  ListPage({Key? key, required this.itemName, required this.selectedLanguage}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Container
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
                      widget.itemName.tr, // Use .tr for localization
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Main List with Scroll functionality
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildListItem(
                    icon: Image.asset("assets/logo/ALPHABETICAL LIST.png", width: 30, height: 30),
                    text: "alphabetical list".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlphabeticalList(
                            itemName: 'alphabetical list',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  _buildListItem(
                    icon: Image.asset("assets/logo/logo 3.png", width: 30, height: 30),
                    text: "By Village".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ByVillageList(
                            itemName: 'By Village',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  _buildListItem(
                    icon: Image.asset("assets/logo/logo 2.png", width: 30, height: 30),
                    text: "By Part No".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPartNo(
                            itemName: 'By Part No',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  _buildListItem(
                    icon: Image.asset("assets/logo/by voting center.png", width: 30, height: 30),
                    text: "By voiting center".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllVotingCenter(
                            itemName: 'By voiting center',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  _buildListItem(
                    icon: Image.asset("assets/logo/by personnel.png", width: 30, height: 30),
                    text: "By Personnel".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPersonnel(
                            itemName: 'By Personnel',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  _buildListItem(
                    icon: Image.asset("assets/logo/extra info all.png", width: 30, height: 30),
                    text: "By Surname".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllSuraname(
                            itemName: 'By Surname',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  _buildListItem(
                    icon: Image.asset("assets/logo/by colour code.png", width: 30, height: 30),
                    text: "By Colour Code".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllColorCode(
                            itemName: 'By Colour Code',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  _buildListItem(
                    icon: Image.asset("assets/logo/mobile.png", width: 25, height: 25),
                    text: "Mobile No List".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllMobileNoList(
                            itemName: 'Mobile No List',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  _buildListItem(
                    icon: Image.asset("assets/logo/mobile.png", width: 25, height: 25),
                    text: "VotercWithout Mobile".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllVoterWithoutMobile(
                            itemName: 'VotercWithout Mobile',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/logo.png", width: 30, height: 30),
                    text: "By Adderss".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllAdderss(
                            itemName: 'By Adderss',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/logo.png", width: 30, height: 30),
                    text: "By New Adderss".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllNewAdderss(
                            itemName: 'By New Adderss',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/logo 3.png", width: 30, height: 30),
                    text: "By Society".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllSociety(
                            itemName: 'By Society',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/human_prev_ui (1).png", width: 25, height: 25),
                    text: "By Gender".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllGender(
                            itemName: 'By Gender',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/by age.png", width: 25, height: 25),
                    text: "By Age".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ByAge(
                            itemName: 'By Age',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/by cast.png", width: 30, height: 30),
                    text: "By Caste".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ByCast(
                            itemName: 'By Caste',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/by position.png", width: 25, height: 25),
                    text: "By Position".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPosition(
                            itemName: 'By Position',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/dead.png", width: 30, height: 30),
                    text: "By Dead".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllDead(
                            itemName: 'By Dead',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/human_prev_ui (1).png", width: 25, height: 25),
                    text: "Repeated".tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Repeated(
                            itemName: 'Repeated',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/star voter.png", width: 30, height: 30),
                    text: 'Star Voter'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllStareVoter(
                            itemName: 'Star Voter',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/extra check all.png", width: 30, height: 30),
                    text: 'Extra Ckeck 1'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllExtraCheck1(
                            itemName: 'Extra Ckeck 1',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/extra check all.png", width: 30, height: 30),
                    text: 'Extra Ckeck 2'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExtraCheck2(
                            itemName: 'Extra Ckeck 2',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/extra info all.png", width: 30, height: 30),
                    text: 'Extra Info 1'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllExtraInfo1(
                            itemName: 'Extra Info 1',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/extra info all.png", width: 30, height: 30),
                    text: 'Extra Info 2'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllExtraInfo2(
                            itemName: 'Extra Info 2',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/extra info all.png", width: 30, height: 30),
                    text: 'Extra Info 3'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllExtraInfo3(
                            itemName: 'Extra Info 3',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/extra info all.png", width: 30, height: 30),
                    text: 'Extra Info 4'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllExtraInfo4(
                            itemName: 'Extra Info 4',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/extra info all.png", width: 30, height: 30),
                    text: 'Extra Info 5'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllExtraInfo5(
                            itemName: 'Extra Info 5',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/by house number.png", width: 30, height: 30),
                    text: 'By House No'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllHouseNo(
                            itemName: 'By House No',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/extra info all.png", width: 30, height: 30),
                    text: 'Demands List'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllDemandsList(
                            itemName: 'Demands List',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/voted.png", width: 30, height: 30),
                    text: 'voted'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllVoted(
                            itemName: 'voted',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/by survey team.png", width: 30, height: 30),
                    text: 'By Survey Team'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllSurveyTeam(
                            itemName: 'By Survey Team',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/logo 3.png", width: 30, height: 30),
                    text: 'By Taluka'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllTaluka(
                            itemName: 'By Taluka',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/extra info all.png", width: 30, height: 30),
                    text: 'Today BirthDay'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodayBirthDay(
                            itemName: 'Today BirthDay',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/pinter_s.png", width: 28, height: 28),
                    text: 'Slip Printer Report'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SlipPrinterReport(
                            itemName: 'Slip Printer Report',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListItem(
                    icon: Image.asset("assets/logo/pinter_s.png", width: 30, height: 30,),
                    text: 'Bluetooth Slip Report By User'.tr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BluetoothSlipReportByUser(
                            itemName: 'Bluetooth Slip Report By User',
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for each list item with GestureDetector for navigation
  Widget _buildListItem({
    required Widget icon, // Change from IconData to Widget
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Row(
          children: [
            icon, // Use the passed icon widget directly
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        thickness: 2,
        color: AppColors.secondaryColor,
      ),
    );
  }
}
