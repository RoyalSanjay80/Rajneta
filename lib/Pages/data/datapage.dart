import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Utils/colors.dart';

class DataPage extends StatefulWidget {
  final String selectedLanguage;
  final String itemName;

  DataPage({super.key, required this.selectedLanguage, required this.itemName });

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(

        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20,),
            itemdata(Icons.cloud_download_outlined,"Download List",(){}),
            itemdata(Icons.person,"Photo",(){}),
            itemdata(Icons.system_update_alt,"Update List",(){}),
            itemdata(Icons.backup_table,"Backup All Data",(){}),
            itemdata(Icons.restart_alt,"Reset From Backup FIle",(){}),
            itemdata(Icons.backup_table,"Survey  Backup Before Update",(){}),
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
  Widget itemdata(IconData icon,String text,
      void Function()? onTa){
    return Padding(
      padding: const EdgeInsets.only(left: 18.0,right: 18,top: 10),
      child: Column(
        children: [
          InkWell(
            onTap: onTa,
            child: Row(
              children: [
                Icon(icon,
                  color: AppColors.secondaryColor,
                  size: 24,
                ),
                SizedBox(width: 20,),
                Text(text,style: TextStyle(
                    fontSize: 20,
                    color: AppColors.secondaryColor
                ),)
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
