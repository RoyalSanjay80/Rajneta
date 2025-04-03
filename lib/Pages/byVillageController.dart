import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ByVillageController extends GetxController {
  // Function to show the options dialog
  void showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select an Option"),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.analytics),
                title: Text("More Analysis"),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text("Export to PDF"),
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigate to the Export to PDF screen
                },
              ),
              ListTile(
                leading: Icon(Icons.table_chart),
                title: Text("Export to Excel"),
                onTap: () {
                  Navigator.of(context).pop();

                },
              ),
            ],
          ),
        );
      },
    );
  }
}
