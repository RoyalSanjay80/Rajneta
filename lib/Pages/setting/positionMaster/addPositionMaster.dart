import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:rajneta/Utils/colors.dart';

class Addposition extends StatefulWidget {
  const Addposition({super.key});

  @override
  State<Addposition> createState() => _AddpositionState();
}

class _AddpositionState extends State<Addposition> {
  final TextEditingController _positionMasterController = TextEditingController();
  final RxList<String> _position = <String>[].obs;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 10,),
            Expanded(child: _buildPosition())
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.secondaryColor,
          child: Icon(Icons.add,color: AppColors.backgroundColor,),
            onPressed: (){
              _showBottomSheet(context);
        }),
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
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            'Position Master',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ))
        ],
      ),
    );
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
                "Create New Position",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _positionMasterController,
                decoration: InputDecoration(
                  labelText: 'Position Name',
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
                  String societyName = _positionMasterController.text.trim();
                  if (societyName.isNotEmpty) {
                    _position.add(societyName); // Add to List
                    _positionMasterController.clear(); // Clear input
                    Get.back(); // Close bottom sheet
                    Get.snackbar(
                      "Added",
                      "Position '$societyName' added successfully!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      "Please enter a position"
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
                  "Add Position",
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
  Widget _buildPosition(){
    return Obx(()=>_position.isEmpty
    ? Center(
      child: Text('No Position yet',style: TextStyle(
        fontSize: 16,color: Colors.grey
      ),),
    )
        : ListView.builder(
      itemCount: _position.length,
        itemBuilder: (context,index){
          return Card(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.home,color: AppColors.secondaryColor,),
              title: Text(
                _position[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ),
          );
        })
    );
  }
}
