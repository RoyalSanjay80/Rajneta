import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Utils/colors.dart';

class Backupalldata extends StatefulWidget {
  const Backupalldata({super.key});

  @override
  State<Backupalldata> createState() => _BackupalldataState();
}

class _BackupalldataState extends State<Backupalldata> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 50,),
          Center(
            child: ElevatedButton.icon(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  padding:
                    EdgeInsets.symmetric(horizontal: 32,vertical: 16),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  elevation: 4
                ),
                icon: Icon(Icons.backup,color: Colors.white,),
                label: Text('BACKUP DATABASE',style: TextStyle(
                  color: Colors.white,fontSize: 16
                ),)),
          )

        ],
      ),
    ));
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
              "Backup All Data",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
