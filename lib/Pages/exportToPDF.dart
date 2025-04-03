import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/colors.dart';

class Exporttopdf extends StatefulWidget {
  final String itemName;
  final String selectedLanguage;

  const Exporttopdf(
      {Key? key, required this.itemName, required this.selectedLanguage})
      : super(key: key);

  @override
  State<Exporttopdf> createState() => _ExporttopdfState();
}

class _ExporttopdfState extends State<Exporttopdf> {
  // Controllers for text fields
  final TextEditingController a3PageController = TextEditingController(text: "1");
  final TextEditingController dataController = TextEditingController(text: "1000");

  // State for switches
  final Map<String, bool> switches = {
    "A3 Page": false,
    "Box Pdf": false,
    "Family wise": false,
    "Alphabetically": false,

  };
  void onPressed() {
    // बटन की क्रिया
    print("Bottom Button Pressed");
  }

  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;
  bool isChecked7 = false;


  void toggleSwitch(String key, bool value) {
    setState(() {
      switches[key] = value;
    });
  }

  @override
  void dispose() {
    a3PageController.dispose();
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get screen width for responsive design
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(screenWidth),
            const SizedBox(height: 10),
            _buildExportButton(),
            const SizedBox(height: 10),
            _buildSwitchRow("A3 Page", "Box Pdf", screenWidth),
            _buildSwitchRow("Family wise", "Alphabetically", screenWidth),
            const SizedBox(height: 10),
            _buildInputRow("Records From", a3PageController, "To", dataController, screenWidth),
            const SizedBox(height: 10),
            _bulidText("* You can change columns to export"),
            _bulidText("* Change sequence of columns by drag n drop"),
            _bulidText(
                "* 45.17% space available so you can select columns accordingly"),
            // Scrollable content starts here
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCard(
                      "cfvg",
                      "fgh",
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked = newValue!;
                        });
                      },
                    ),
                    _buildCard(
                      "cfvg",
                      "fgh",
                      value: isChecked1,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked1 = newValue!;
                        });
                      },
                    ),
                    _buildCard(
                      "cfvg",
                      "fgh",
                      value: isChecked2,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked2 = newValue!;
                        });
                      },
                    ),
                    _buildCard(
                      "cfvg",
                      "fgh",
                      value: isChecked3,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked3 = newValue!;
                        });
                      },
                    ),
                    _buildCard(
                      "cfvg",
                      "fgh",
                      value: isChecked4,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked4 = newValue!;
                        });
                      },
                    ),
                    _buildCard(
                      "cfvg",
                      "fgh",
                      value: isChecked5,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked5 = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],

        ),
        bottomNavigationBar: Card(
          margin: EdgeInsets.zero,
          elevation: 4,
          color: Colors.white,
          child: SizedBox(
            height: 60,
            child: Center(
              child: MaterialButton(
                onPressed: () {},
                color: AppColors.secondaryColor, // बटन का रंग
                textColor: Colors.white, // आइकन और टेक्स्ट का रंग
                child: Row(
                  mainAxisSize: MainAxisSize.min, // सामग्री के अनुसार बटन का आकार
                  children: [
                    const Icon(Icons.close_outlined), // बटन में आइकन
                    const SizedBox(width: 8), // आइकन और टेक्स्ट के बीच गैप
                    const Text(
                      "Reset Settings", // बटन का टेक्स्ट
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      height: screenWidth * 0.2, // Dynamically adjust the header height
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
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    return MaterialButton(
      onPressed: () {
        // Your export to PDF functionality
      },
      color: AppColors.secondaryColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.picture_as_pdf, color: Colors.white),
          SizedBox(width: 8),
          Text("Export To PDF",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label1, String label2, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label1),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: switches[label1]!,
            activeColor: AppColors.secondaryColor,
            activeTrackColor: Colors.deepOrangeAccent[200],
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black12,
            onChanged: (value) => toggleSwitch(label1, value),
          ),
        ),
        Text(label2),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: switches[label2]!,
            activeColor: AppColors.secondaryColor,
            activeTrackColor: Colors.deepOrangeAccent[200],
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black12,
            onChanged: (value) => toggleSwitch(label2, value),
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

  Widget _bulidText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 10.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String ftext, String eText,
      {required bool value, required ValueChanged<bool?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.red, width: 2), // Red border with 2px width
          borderRadius: BorderRadius.circular(
              8), // Optional: to give the card rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Distribute the space evenly
            children: [
              Text(ftext),
              Text(eText), // Start text
              Checkbox(
                value: value,
                onChanged: onChanged,
              ),
              // End text
            ],
          ),
        ),
      ),
    );
  }
}
