import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rajneta/Pages/setting/societyMaster/SocietyMasterPage.dart';
import 'package:rajneta/Pages/setting/positionMaster/positionMaster.dart';

import '../../../Utils/colors.dart';
import '../addressMaster/addressMaster.dart';
import '../castMaster/castMaster.dart';
import '../karyakartaMaster/karyakartaMaster.dart';
import '../manageUsersPage.dart';

class Admincontroller extends GetxController{

  void showAdminDialog(BuildContext context,String selectedLanguage ) {
    Get.defaultDialog(
      title: "Admin Option",
      titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _adminOptionItem("Manage Users", Icons.people ,(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserListScreen(selectedLanguage: selectedLanguage),));
          }),
          _adminOptionItem("Society Master", Icons.apartment,(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Societymasterpage(selectedLanguage: selectedLanguage),));
          }),
          _adminOptionItem("Address Master", Icons.location_on,(){
           Navigator.push(context, MaterialPageRoute(builder: (context) => Addressmaster(selectedLanguage: selectedLanguage),));
          }),
          _adminOptionItem("Karyakarta Master", Icons.supervisor_account,(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Karyakartamaster(selectedLanguage: selectedLanguage),));
          }),
          _adminOptionItem("Cast Master", Icons.groups,(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Castmaster(selectedLanguage: selectedLanguage),));
          }),
          _adminOptionItem("Position Master", Icons.work,(){
           Navigator.push(context, MaterialPageRoute(builder: (context) => Positionmaster(selectedLanguage: selectedLanguage),));
          }),
          _adminOptionItem("Allow All Mobile Users To Create Master Data", Icons.mobile_friendly,(){}),
          _adminOptionItem("Enable campaign info in all phones", Icons.campaign,(){}),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: Icon(Icons.close, color: Colors.red, size: 40),
      ),
    );
  }


  Widget _adminOptionItem(String title,IconData icon,VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondaryColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.black87),
      ),
      onTap: onTap
    );
  }
}