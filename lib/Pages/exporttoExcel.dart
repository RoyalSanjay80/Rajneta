import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utils/colors.dart';
class ExportToExcel extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;
  const ExportToExcel({Key? key, required this.itemName, required this.selectedLanguage}) : super(key: key);

  @override
  _ExportToExcelState createState() => _ExportToExcelState();
}

class _ExportToExcelState extends State<ExportToExcel> {
  final TextEditingController a3PageController =
  TextEditingController(text: "1"); // Default value 1
  final TextEditingController dataController =
  TextEditingController(text: "1000");
   var a=10;
   var b=100;


  final Map<String, bool> switches = {
    "A3 Page": false,
    "Box Pdf": false,
    "Family wise": false,
    "Alphabetically": false,
    "1": false, "2": false, "3": false, "4": false, "5": false, "6": false, "7": false, "8": false, "9": false, "10": false, "11": false, "12": false,'37':false,
    "13": false, "14": false, "15": false, "16": false, "17": false, "18": false, "19": false, "20": false, "21": false, "22": false, "23": false, "24": false,
    "25": false, "26": false, "27": false, "28": false, "29": false, "30": false, "31": false, "32": false, "33": false, "34": false, "35": false, "36": false,
  };

  void toggleSwitch(String key) {
    setState(() {
      // Ensure the key exists before toggling.
      if (switches.containsKey(key)) {
        switches[key] = !switches[key]!;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(screenWidth),
              const SizedBox(height: 10),
              _buildExportButton(),
              const SizedBox(height: 10),
              _buildSwitchRow("Family wise", "Alphabetically", screenWidth),
              const SizedBox(height: 10),
              _buildInputRow("Records From", a3PageController, "To", dataController, screenWidth),
              const SizedBox(height: 15),
              Text("Please select columns to export", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.red, width: 2), // Red border with 2px width
                    borderRadius: BorderRadius.circular(8), // Optional: to give the card rounded corners
                  ),

                  color: Colors.grey[100],
                  child: Column(
                    children: [
                      _buildExportCard("Assembly".tr, "1"),
                      _buildExportCard("Part No".tr, "2"),
                      _buildExportCard("Booth no".tr, "3"),
                      _buildExportCard("Srn".tr, "4"),
                      _buildExportCard("Final Srno".tr, "5"),
                      _buildExportCard("Name".tr, "6"),
                      _buildExportCard("gender".tr, "7"),
                      _buildExportCard("age".tr, "8"),
                      _buildExportCard("voter Id".tr, "9"),
                      _buildExportCard("Gat".tr, "10"),
                      _buildExportCard("Export Cart".tr, "12"),
                      _buildExportCard("Gan".tr, "11"),
                      _buildExportCard("Assembly No".tr, "13"),
                      _buildExportCard("village".tr, "14"),
                      _buildExportCard("Colour Code".tr, "15"),
                      _buildExportCard("mobile-1".tr, "16"),
                      _buildExportCard("mobile-2".tr, "17"),
                      _buildExportCard("Dob".tr, "18"),
                      _buildExportCard("demands".tr, "19"),
                      _buildExportCard("Personnel".tr, "20"),
                      _buildExportCard("Cast".tr, "21"),
                      _buildExportCard("position".tr, "22"),
                      _buildExportCard("New Address".tr, "23"),
                      _buildExportCard("Society".tr, "24"),
                      _buildExportCard("Flat No".tr, "25"),
                      _buildExportCard("address".tr, "26"),
                      _buildExportCard("House No".tr, "27"),
                      _buildExportCard("Booth".tr, "28"),
                      _buildExportCard("Booth(English)".tr, "29"),
                      _buildExportCard("Extra Ckeck 1".tr, "30"),
                      _buildExportCard("Extra Ckeck 2".tr, "31"),
                      _buildExportCard("Extra Info 1".tr, "32"),
                      _buildExportCard("Extra Info 2".tr, "33"),
                      _buildExportCard("Extra Info 3".tr, "34"),
                      _buildExportCard("Extra Info 4".tr, "35"),
                      _buildExportCard("Extra Info 5".tr, "36"),
                      _buildExportCard("dead".tr, "37"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      height: screenWidth * 0.2,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.itemName.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    return MaterialButton(
      onPressed: () {
        // Add your export functionality here
      },
      color: AppColors.secondaryColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.picture_as_pdf, color: Colors.white),
          SizedBox(width: 8),
          Text("Export To PDF", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label1, String label2, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSwitch(label1),
        const SizedBox(width: 20),
        _buildSwitch(label2),
      ],
    );
  }

  Widget _buildSwitch(String label) {
    return Row(
      children: [
        Text(label),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: switches[label] ?? false,
            activeColor: AppColors.secondaryColor,
            activeTrackColor: Colors.deepOrangeAccent[200],
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black12,
            onChanged: (value) => toggleSwitch(label),
          ),
        ),
      ],
    );
  }

  Widget _buildInputRow(
      String label1,
      TextEditingController controller1,
      String label2,
      TextEditingController controller2,
      double screenWidth,
      ) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label1,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildInputField(controller1, "$label1", screenWidth),
          ),
          const SizedBox(width: 20),
          Text(
            label2,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildInputField(controller2, "Enter $label2", screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String hint, double screenWidth) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
  }

  Widget _buildExportCard(String title, String switchKey) {
    return Card(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,color: AppColors.secondaryColor,),
            onPressed: () {},
          ),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(
              switches[switchKey] ?? false ? Icons.check_box : Icons.check_box_outline_blank,
              color: switches[switchKey] ?? false ? AppColors.secondaryColor: Colors.grey,
            ),
            onPressed: () => toggleSwitch(switchKey),
          ),
        ],
      ),
    );
  }
}
