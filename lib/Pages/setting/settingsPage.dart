import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rajneta/Pages/setting/adminController/adminController.dart';
import 'package:rajneta/Pages/setting/smsSetting.dart';
import 'package:restart_app/restart_app.dart';
import '../../Utils/colors.dart';
import 'Term and condition.dart';
import 'bluetoothSlipSetting.dart';
import 'help.dart';

class SettingPage extends StatefulWidget {
  final String selectedLanguage;
  final String itemName;

  SettingPage({super.key, required this.selectedLanguage, required this.itemName});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Admincontroller admincontroller =Get.put(Admincontroller());
  bool isSearchSpeedOptimized = true;
  void showtoast(String title){
    showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ App Icon
            Image.asset(
              'assets/applogo.png', // <-- app ka icon yahan dalna hai
              height: 24,
              width: 24,
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
    );
  }
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
              // itemdata(Icons.restart_alt, "Reactivate App", () {}),
              itemdata(Icons.report_gmailerrorred_sharp, "Terms and Conditions", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TeramAndCondtionPage(),));
              }),
              itemdata(
                Icons.speed,
                "Search Speed Optimization-${isSearchSpeedOptimized ? "On" : "Off"}",
                    () {
                  setState(() {
                    isSearchSpeedOptimized = !isSearchSpeedOptimized;
                  });
                },
                icconColor: isSearchSpeedOptimized ? AppColors.secondaryColor : Colors.grey,
              ),
              itemdata(Icons.print, "Disconnect BT printer", () {
                print("Printer Disconnect");
                showtoast('Printer Disconnect');
              }),

              itemdata(Icons.refresh_sharp, "Update Setting From Server", () {
                showtoast('Sync Complete');
              }),
              itemdata(Icons.sync_rounded, "Sync Labels", () {
                showtoast('Done');
              }),
              itemdata(Icons.help, "Help", () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => Helppage(),));
              }),
              itemdata(Icons.star_border_purple500, "AppId -166121 -v1", () {}),
              itemdata(Icons.restart_alt, "Restart App", () {
                Restart.restartApp();
              }),
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

  Widget itemdata(IconData icon, String text, void Function()? onTap,{Color? icconColor}) {
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
                  color: icconColor ?? AppColors.secondaryColor,
                  size: 24,
                ),
                SizedBox(width: 20),
                Text(
                  text,
                  style: TextStyle(fontSize: 18, color: AppColors.secondaryColor),
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
