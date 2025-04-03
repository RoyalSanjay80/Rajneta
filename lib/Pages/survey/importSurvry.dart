import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rajneta/Utils/colors.dart';

class Importsurvry extends StatefulWidget {
  final String itemname;
  final String selectedlanguge;

  const Importsurvry(
      {super.key, required this.itemname, required this.selectedlanguge});

  @override
  State<Importsurvry> createState() => _ImportsurvryState();
}

class _ImportsurvryState extends State<Importsurvry> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildActionRow(),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Centered section for the checkboxes
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRoundCheckbox(0, "Overwrite Existing Values"),
                            SizedBox(height: 20),
                            _buildRoundCheckbox(1, "Don't Overwrite"),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // Other options can be added here if needed
                      Center(
                        child: _buildIconTextWidget(
                          icon: Icons.book,
                          text: 'From Zip',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0,right: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconTextWidget(
              icon: Icons.book, text: 'From Zip', onTap: () {}),
          _buildIconTextWidget(
              icon: Icons.cloud_download, text: 'From', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildIconTextWidget({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.itemname,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.secondaryColor, width: 2),
                color: selectedIndex == index
                    ? AppColors.secondaryColor
                    : Colors.transparent,
              ),
              child: selectedIndex == index
                  ? Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
                  : null,
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
