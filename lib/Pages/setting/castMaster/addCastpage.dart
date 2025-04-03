import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rajneta/Utils/colors.dart';

class AddCast extends StatefulWidget {
  const AddCast({super.key});

  @override
  State<AddCast> createState() => _AddCastState();
}

class _AddCastState extends State<AddCast> {
  final TextEditingController castController = TextEditingController();
  final RxList<String> _Cast = <String>[].obs;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              _buildHeader(),
              SizedBox(
                height: 10,
              ),
              Expanded(child: _buildCast())
            ],
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: AppColors.secondaryColor,
              ),
              onPressed: () {
                _showBottomSheet(context);
              }),
        ));
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
                'Add Karyakarta',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
              ))
        ],
      ),
    );
  }

  Widget _buildCast() {
    return Obx(() => _Cast.isEmpty
        ? Center(
      child: Text(
        'No Cast Yet',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    )
        : ListView.builder(
        itemCount: _Cast.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: AppColors.secondaryColor,
              ),
              title: Text(
                _Cast[index],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ),
          );
        }));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Create New Cast",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: castController,
                decoration: InputDecoration(
                  labelText: 'Cast Name',
                  prefixIcon: Icon(Icons.home, color: AppColors.secondaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.secondaryColor, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  String societyName = castController.text.trim();
                  if (societyName.isNotEmpty) {
                    _Cast.add(societyName); // Add to List
                    castController.clear(); // Clear input
                    Get.back(); // Close bottom sheet
                    Get.snackbar(
                      "Added",
                      "Cast '$societyName' added successfully!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      "Please enter a Cast"
                          ""
                          ""
                          ""
                          " name.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: Text(
                  "Add Cast",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
