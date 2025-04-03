import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/colors.dart';

class Exportsurvey extends StatefulWidget {
  final String itemname;
  final String selectedLangauge;
  const Exportsurvey({super.key, required this.itemname, required this.selectedLangauge});

  @override
  State<Exportsurvey> createState() => _ExportsurveyState();
}

class _ExportsurveyState extends State<Exportsurvey> {
  int? selectedIndex; // Tracks the currently selected checkbox

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRoundCheckbox(0, "Export All Families"),
                    SizedBox(height: 10),
                    _buildRoundCheckbox(1, "Export Modified Family"),
                    SizedBox(height: 40),
                    SizedBox(
                      width: 210,
                      child: _buildIconTextWidget(
                        icon: Icons.download,
                        text: "Export to phone",
                        onTap: () {


                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: 200,
                      child: _buildIconTextWidget(
                        icon: Icons.cloud_upload_rounded,
                        text: "Send To Admin",
                        onTap: () {


                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: 300,
                      child: _buildIconTextWidget(
                        icon: Icons.share,
                        text: "Share Survey File (Whatsapp)",
                        onTap: () {


                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
              widget.itemname,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundCheckbox(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index; // Update selected index
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondaryColor, width: 2),
                color: selectedIndex == index ? AppColors.secondaryColor : Colors.transparent,
              ),
              child: selectedIndex == index
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTextWidget({required IconData icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
