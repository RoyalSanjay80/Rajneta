import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Utils/colors.dart';
import 'exportSurvey.dart';
import 'importSurvry.dart';

class Survey extends StatefulWidget {
  final String selectedLanguage;
  final String itemName;

  Survey({super.key, required this.selectedLanguage, required this.itemName });

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(

        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20,),
            itemdata(Icons.download_for_offline_outlined,"Export Survey",(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Exportsurvey(
                itemname:'Export Survey',
                selectedLangauge:widget.selectedLanguage
              ),));
            }),
            itemdata(Icons.download_for_offline_outlined,"Import Survey",(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Importsurvry(
                itemname:'Import Survey',
                selectedlanguge:widget.selectedLanguage
              ),));
            }),
            itemdata(Icons.grid_view_outlined,"View Voted",(){}),
            itemdata(Icons.delete_sweep,"Reset voted marking",(){}),
            itemdata(Icons.restart_alt,"Reset Master Data",(){}),
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
