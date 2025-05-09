import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Utils/colors.dart';

class Updatelistpage extends StatefulWidget {
  const Updatelistpage({super.key});

  @override
  State<Updatelistpage> createState() => _UpdatelistpageState();
}

class _UpdatelistpageState extends State<Updatelistpage> {
  final List<String> datalist = [
    'Part no : 2 - Amnapur - Supp List Oct 24',
    'Part No : 3 - Ramaling - Supp List Oct 24',
    'Part no : 4 - Ramaling - Supp List Oct 24',
    'Part no : 5 - Ramaling - Supp List Oct 24',
    'Part no : 6 - Shirur Shahar - Supp List Oct 24',
    'Part no : 7 - Shirur Shahar - Supp List Oct 24',
    'Part no : 8 - Shaiur Shahar - Supp List Oct 24',
    'Part no : 9 - Shaiur Shahar - Supp List Oct 24',
    'Part no : 10 - Shaiur Shahar - Supp List Oct 24',
    'Part no : 11 - Shaiur Shahar - Supp List Oct 24',
    'Part no : 12 - Shaiur Shahar - Supp List Oct 24',
    'Part no :13 - Shaiur Shahar - Supp List Oct 24',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 10,),
          _buildBotom('STEP 1 - EXPORT SURVEY'),
          _buildBotom('STEP 1 - UPDATE LIST'),
        const  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Your Service Has Been Expired, Please Contect Us For Update,',style: TextStyle(
              color: Colors.red,fontWeight: FontWeight.bold,

            ),
            textAlign: TextAlign.center,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(child: _buildDropdown('Assembly', ['All'])),
                SizedBox(width: 10,),
                Expanded(child: _buildDropdown('Village', ['All'])),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(
            itemCount: datalist.length,
              itemBuilder: (context ,index){
              return _buildListItem(datalist[index]);
              }))
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
              "Update List",
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

  Widget _buildBotom(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
  Widget _buildDropdown(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      value: items[0],
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (_) {},
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildListItem(String title){
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: ListTile(
        leading: Icon(Icons.play_arrow,color: Colors.orange,),
        title: Text(title),
        trailing: Icon(Icons.check_circle,color: Colors.orange,),
      ),
    );
  }
}
