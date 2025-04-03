import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rajneta/Pages/setting/adminController/adminController.dart';
import 'package:rajneta/Pages/setting/smsSetting.dart';
import '../../Utils/colors.dart';
import 'Term and condition.dart';
import 'bluetoothSlipSetting.dart';

class SettingPage extends StatefulWidget {
  final String selectedLanguage;
  final String itemName;

  SettingPage({super.key, required this.selectedLanguage, required this.itemName});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Admincontroller admincontroller =Get.put(Admincontroller());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              itemdata(Icons.person_add_alt_1_sharp, "Admin", (){
                admincontroller.showAdminDialog(context,widget.selectedLanguage);
              }),
              itemdata(Icons.sms, "Sms Setting", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SmsSetting(),));
              }),
              itemdata(Icons.print, "Bluetooth Slip Setting", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothSlipSetting(),));
              }),
              itemdata(Icons.restart_alt, "Reactivate App", () {}),
              itemdata(Icons.report_gmailerrorred_sharp, "Terms and Conditions", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TeramAndCondtionPage(),));
              }),
              itemdata(Icons.speed, "Search Speed Optimization-On", () {}),
              itemdata(Icons.print, "Disconnect BT printer", () {}),
              itemdata(Icons.refresh_sharp, "Update Setting From Server", () {}),
              itemdata(Icons.sync_rounded, "Sync Labels", () {}),
              itemdata(Icons.help, "Help", () {}),
              itemdata(Icons.star_border_purple500, "AppId -166121 -v1", () {}),
              itemdata(Icons.restart_alt, "Restart App", () {}),
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

  Widget itemdata(IconData icon, String text, void Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.secondaryColor,
                  size: 24,
                ),
                SizedBox(width: 20),
                Text(
                  text,
                  style: TextStyle(fontSize: 20, color: AppColors.secondaryColor),
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }


}
