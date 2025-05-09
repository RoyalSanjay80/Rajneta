import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/colors.dart';

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  TextEditingController fromController = TextEditingController(text: "1");
  TextEditingController toController = TextEditingController(text: "1000");
  bool otherSwitch = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  _buildTextField("From List", fromController),
                  SizedBox(height: 16),
                  _buildTextField("To List", toController),
                  SizedBox(height: 24),
                  _buildButton(
                      Icons.delete, "DELETE OLD PHOTOS", Colors.deepOrange, () {
                    // Your delete logic here
                  }),
                  SizedBox(height: 16),
                  _buildButton(Icons.cloud_download, "START PHOTO DOWNLOAD",
                      Colors.orange, () {
                    // Your download logic here
                  }),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("other", style: TextStyle(fontSize: 16)),
                  Switch(
                    value: otherSwitch,
                    onChanged: (value) {
                      setState(() {
                        otherSwitch = value;
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey.shade300)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildfiled(String hint,  TextEditingController controller){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 6,color: Colors.green.shade300)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),

        ),
      ),
    );
  }

  Widget _buildButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      onPressed: onPressed,
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
              "Photo",
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
