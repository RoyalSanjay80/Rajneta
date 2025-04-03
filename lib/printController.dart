import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'Utils/api_constants.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';


class Printcontroller extends GetxController {
  Future<Map<String, dynamic>> fetchPermissions() async {
    final url = Uri.parse(
        'https://rajneta.fusiontechlab.site/api/sms-setting?lang=en&voter_user_id=1&middle_name_check=1&booth_check=1&assembly_name_check=1');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ??
          ''; // Default empty string agar token nahi mila

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Token pass karo
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse["data"] ?? {}; // "data" return karo
      } else {
        print('Error fetching permissions: ${response.statusCode}');
        return {}; // Empty map return agar error aaya to
      }
    } catch (e) {
      print('API Error: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchPermissions1(
      String userId, String lang) async {
    final url = Uri.parse(
        'https://rajneta.fusiontechlab.site/api/sms-setting?lang=en&voter_user_id=1&middle_name_check=1&booth_check=1&assembly_name_check=1');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ??
          ''; // Default empty string agar token nahi mila

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Token pass karo
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse["data"] ?? {}; // "data" return karo
      } else {
        print('Error fetching permissions: ${response.statusCode}');
        return {}; // Empty map return agar error aaya to
      }
    } catch (e) {
      print('API Error: $e');
      return {};
    }
  }

  Widget buildActionRow(BuildContext context, String name, String partNo,
      String srn, String voterId, String booth, String phoneNumber) {
    final messageW = '''
----------------------------------------------------
          Voting Details 
          *Name:* $name
          Part no  : $partNo
          Srn : $srn
          Voter Id : $voterId
          Booth : $booth
----------------------------------------------------
''';

    return FutureBuilder<Map<String, dynamic>>(
      future: fetchPermissions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(""); // Empty text if no data is available
        }

        final permissions = snapshot.data ?? {};

        // Ensure we access the values from "data"
        bool includeMiddleName =
            int.tryParse(permissions["middle_name_check"].toString()) == 1;
        bool includeBooth =
            int.tryParse(permissions["booth_check"].toString()) == 0;
        bool includeAssembly =
            int.tryParse(permissions["assembly_name_check"].toString()) == 0;
        // String fullName = includeMiddleName && middleName.isNotEmpty ? "$name $middleName" : name;
        // Create a list for dynamic message construction
        List<String> messageLines = [
          "----------------------------------------------------",
          "          Voting Details ",
          "*Name:* $name",
          if (partNo.isNotEmpty) "Part no  : $partNo",
          if (srn.isNotEmpty) "Srn : $srn",
          if (voterId.isNotEmpty) "Voter Id : $voterId",
          if (includeBooth && booth.isNotEmpty) "Booth : $booth",
          if (includeAssembly) "Assembly Name: abc",
          if (includeMiddleName) "Middle Name: hello",
          "----------------------------------------------------"
        ];

        // Join only non-empty lines
        String message =
            messageLines.where((line) => line.trim().isNotEmpty).join("\n");

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // WhatsApp Share
            IconButton(
              icon: ImageIcon(AssetImage('assets/logo/whatapps.png'), size: 30),
              onPressed: () async {
                await Share.share(messageW);
              },
            ),
            // Call
            IconButton(
              icon: ImageIcon(AssetImage('assets/logo/mobile.png'), size: 25),
              onPressed: () async {
                final callUrl = "tel:$phoneNumber";
                if (await canLaunch(callUrl)) {
                  await launch(callUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Unable to make a call')),
                  );
                }
              },
            ),
            // SMS with permission check
            IconButton(
              icon: Icon(Icons.sms, color: Colors.black),
              onPressed: () async {
                launch('sms:+91$phoneNumber?body=$message');
              },
            ),
            // Print
            IconButton(
              icon: Icon(Icons.print, color: Colors.black),
              onPressed: () {
                print('Print tapped for $name');
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildActionRow1(
    BuildContext context,
    String phoneNumber,
    String userId,
    String lang,
  ) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchPermissions1(userId, lang),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(""); // Return empty text if no data is available
        }

        final permissions = snapshot.data ?? {};
        final data = permissions["data"] ?? {};

        // Extract values from API response
        String name = data["first_name"] ?? "";
        String middleName = data["middle_name"] ?? "";
        String surname = data["surname"] ?? "";
        String srn = data["srn"] ?? "";
        String partNo = data["part_no"] ?? "";
        String voterId = data["voter_id"] ?? "";
        String booth = data["booth"] ?? "";
        String description = data["description"] ?? "";

        // Convert API response values to boolean (0 => false, 1 => true)
        bool includeMiddleName =
            int.tryParse(permissions["middle_name_check"].toString()) == 1;
        bool includeBooth =
            int.tryParse(permissions["booth_check"].toString()) == 1;
        bool includeAssembly =
            int.tryParse(permissions["assembly_name_check"].toString()) == 1;

        // Construct full name based on middle name visibility
        String fullName = includeMiddleName && middleName.isNotEmpty
            ? "$name $middleName"
            : name;

        // Create a dynamic message
        List<String> messageLines = [
          "----------------------------------------------------",
          "          Voting Details ",
          "*Name:* $fullName $surname",
          if (partNo.isNotEmpty) "Part no  : $partNo",
          if (srn.isNotEmpty) "Srn : $srn",
          if (voterId.isNotEmpty) "Voter Id : $voterId",
          if (includeBooth && booth.isNotEmpty) "Booth : $booth",
          if (includeAssembly) "Assembly Name: abc",
          if (description.isNotEmpty) "Description: $description",
          "----------------------------------------------------"
        ];

        // Final formatted message
        String message =
            messageLines.where((line) => line.trim().isNotEmpty).join("\n");

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // WhatsApp Share
            IconButton(
              icon: ImageIcon(AssetImage('assets/logo/whatapps.png'), size: 30),
              onPressed: () async {
                await Share.share(message);
              },
            ),
            // Call
            if (phoneNumber.isNotEmpty)
              IconButton(
                icon: ImageIcon(AssetImage('assets/logo/mobile.png'), size: 25),
                onPressed: () async {
                  final callUrl = "tel:$phoneNumber";
                  if (await canLaunch(callUrl)) {
                    await launch(callUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unable to make a call')),
                    );
                  }
                },
              ),
            // SMS
            if (phoneNumber.isNotEmpty)
              IconButton(
                icon: Icon(Icons.sms, color: Colors.black),
                onPressed: () async {
                  launch('sms:+91$phoneNumber?body=$message');
                },
              ),
            // Print
            IconButton(
              icon: Icon(Icons.print, color: Colors.black),
              onPressed: () {
                print('Print tapped for $fullName $surname');
              },
            ),
          ],
        );
      },
    );
  }
}





// class Printcontroller1 extends GetxController {
//   final FlutterBluetoothPrinter bluetoothPrinter = FlutterBluetoothPrinter();
//   ReceiptController? controller;
//
//   Future<Map<String, dynamic>> fetchPermissions1(
//       String userId, String lang) async {
//     final url = Uri.parse(
//         'https://rajneta.fusiontechlab.site/api/sms-setting?lang=$lang&voter_user_id=$userId&middle_name_check=1&booth_check=1&assembly_name_check=1');
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';
//
//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//         return jsonResponse["data"] ?? {};
//       } else {
//         print('Error fetching permissions: ${response.statusCode}');
//         return {};
//       }
//     } catch (e) {
//       print('API Error: $e');
//       return {};
//     }
//   }
//
//   Widget buildActionRow1(
//       BuildContext context,
//       String phoneNumber,
//       String userId,
//       String lang,
//       ) {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: fetchPermissions1(userId, lang),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Text("");
//         }
//
//         final data = snapshot.data ?? {};
//         print('Fetched Data: $data');
//
//         String name = data["first_name"] ?? "";
//         String middleName = data["middle_name"] ?? "";
//         String surname = data["surname"] ?? "";
//         String srn = data["srn"] ?? "";
//         String partNo = data["part_no"] ?? "";
//         String voterId = data["voter_id"] ?? "";
//         String booth = data["booth"] ?? "";
//         String description = data["description"] ?? "";
//         String assemblyname = data["assembly_name"] ?? "";
//
//         List<String> messageLines = [
//           "----------------------------------------------------",
//           "          Voting Details ",
//           "*${'name'.tr}:* $name $middleName",
//           if (partNo.isNotEmpty) "${'Part No'.tr}  : $partNo",
//           if (srn.isNotEmpty) "${'srn'.tr} : $srn",
//           if (voterId.isNotEmpty) "${'voter Id'.tr} : $voterId",
//           if (booth.isNotEmpty) "${'booth'.tr} : $booth",
//           if (description.isNotEmpty) "${'description'.tr}: $description",
//           if (assemblyname.isNotEmpty) "${'assembly_name'.tr}: $assemblyname",
//           "----------------------------------------------------"
//         ];
//
//         String message =
//         messageLines.where((line) => line.trim().isNotEmpty).join("\n");
//
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: ImageIcon(AssetImage('assets/logo/whatapps.png'), size: 30),
//               onPressed: () async {
//                 await Share.share(message);
//               },
//             ),
//             if (phoneNumber.isNotEmpty)
//               IconButton(
//                 icon: ImageIcon(AssetImage('assets/logo/mobile.png'), size: 25),
//                 onPressed: () async {
//                   final callUrl = "tel:$phoneNumber";
//                   if (await canLaunch(callUrl)) {
//                     await launch(callUrl);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Unable to make a call')),
//                     );
//                   }
//                 },
//               ),
//             if (phoneNumber.isNotEmpty)
//               IconButton(
//                 icon: Icon(Icons.sms, color: Colors.black),
//                 onPressed: () async {
//                   launch('sms:+91$phoneNumber?body=$message');
//                 },
//               ),
//             IconButton(
//               icon: Icon(Icons.print, color: Colors.black),
//               onPressed: () {
//                 _printData(context, message);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _printData(BuildContext context, String message) async {
//     final device = await FlutterBluetoothPrinter.selectDevice(context);
//     if (device != null) {
//       Receipt receipt = Receipt(
//         builder: (context) => Column(
//           mainAxisSize: MainAxisSize.min,
//           children: message.split('\n').map((line) => Text(line)).toList(),
//         ),
//         onInitialized: (controller) {
//           this.controller = controller;
//         },
//       );
//
//       await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return receipt;
//         },
//       );
//
//       controller?.print(address: device.address);
//     }
//   }
// }

class Printcontroller12 extends GetxController {
  Future<Map<String, dynamic>> fetchPermissions12(
      String userId, String lang) async {
    final url = Uri.parse(
        'https://rajneta.fusiontechlab.site/api/sms-setting?lang=$lang&voter_user_id=$userId&middle_name_check=1&booth_check=1&assembly_name_check=1');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse["data"] ?? {};
      } else {
        print('Error fetching permissions: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('API Error: $e');
      return {};
    }
  }

  Future<void> buildActionRow1(BuildContext context, String phoneNumber,
      String userId, String lang) async {
    final data = await fetchPermissions12(userId, lang);

    if (data.isEmpty) {
      print("No data received.");
      return;
    }

    print('Fetched Data: $data');

    String name = data["first_name"] ?? "";
    String middleName = data["middle_name"] ?? "";
    String surname = data["surname"] ?? "";
    String srn = data["srn"] ?? "";
    String partNo = data["part_no"] ?? "";
    String voterId = data["voter_id"] ?? "";
    String booth = data["booth"] ?? "";
    String description = data["description"] ?? "";
    String assemblyname = data["assembly_name"] ?? "";

    // मैसेज बनाएं
    List<String> messageLines = [
      "----------------------------------------------------",
      "          Voting Details ",
      "*${'name'.tr}:* $name $middleName",
      if (partNo.isNotEmpty) "${'Part No'.tr}  : $partNo",
      if (srn.isNotEmpty) "${'srn'.tr} : $srn",
      if (voterId.isNotEmpty) "${'voter Id'.tr} : $voterId",
      if (booth.isNotEmpty) "${'booth'.tr} : $booth",
      if (description.isNotEmpty) "${'description'.tr}: $description",
      if (assemblyname.isNotEmpty) "${'assembly_name'.tr}: $assemblyname",
      "----------------------------------------------------"
    ];

    String message =
        messageLines.where((line) => line.trim().isNotEmpty).join("\n");

    // **Directly Call Share Outside FutureBuilder**
    Share.share(message);
  }

  Future<void> buildActionRow1sms(
      BuildContext context, String phoneNumber, String userId, String lang) async {
    final data = await fetchPermissions12(userId, lang);

    if (data.isEmpty) {
      print("No data received.");
      return;
    }

    print('Fetched Data: $data');

    String name = data["first_name"] ?? "";
    String middleName = data["middle_name"] ?? "";
    String surname = data["surname"] ?? "";
    String srn = data["srn"] ?? "";
    String partNo = data["part_no"] ?? "";
    String voterId = data["voter_id"] ?? "";
    String booth = data["booth"] ?? "";
    String description = data["description"] ?? "";
    String assemblyname = data["assembly_name"] ?? "";

    // Create message
    List<String> messageLines = [
      "----------------------------------------------------",
      "          Voting Details ",
      "*Name:* $name $middleName",
      if (partNo.isNotEmpty) "Part No: $partNo",
      if (srn.isNotEmpty) "SRN: $srn",
      if (voterId.isNotEmpty) "Voter ID: $voterId",
      if (booth.isNotEmpty) "Booth: $booth",
      if (description.isNotEmpty) "Description: $description",
      if (assemblyname.isNotEmpty) "Assembly Name: $assemblyname",
      "----------------------------------------------------"
    ];

    String message = messageLines.where((line) => line.trim().isNotEmpty).join("\n");

    // Encode the message to avoid URL issues
    String encodedMessage = Uri.encodeComponent(message);

    // Construct SMS URIs
    final Uri smsUri = Uri.parse("sms:$phoneNumber");
    final Uri smsWithBodyUri = Uri.parse("sms:$phoneNumber?body=$encodedMessage");

    // Try opening the SMS app with the message
    if (await canLaunchUrl(smsWithBodyUri)) {
      await launchUrl(smsWithBodyUri);
    } else if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      print("SMS functionality not available.");
    }
  }

}









// class PrintControllerData extends GetxController {
//   final FlutterBluetoothPrinter bluetoothPrinter = FlutterBluetoothPrinter();
//
//   Future<Map<String, dynamic>> fetchPermissionsData(
//       String userId, String lang) async {
//     final url = Uri.parse(
//         'https://rajneta.fusiontechlab.site/api/sms-setting?lang=$lang&voter_user_id=$userId&middle_name_check=1&booth_check=1&assembly_name_check=1');
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';
//
//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//         return jsonResponse["data"] ?? {};
//       } else {
//         print('Error fetching permissions: ${response.statusCode}');
//         return {};
//       }
//     } catch (e) {
//       print('API Error: $e');
//       return {};
//     }
//   }
//   ReceiptController? controller;
//   Widget buildActionRow(
//       BuildContext context, String phoneNumber, String userId, String lang) {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: fetchPermissionsData(userId, lang),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Text("");
//         }
//
//         final data = snapshot.data ?? {};
//         String name = data["first_name"] ?? "";
//         String middleName = data["middle_name"] ?? "";
//         String surname = data["surname"] ?? "";
//         String srn = data["srn"] ?? "";
//         String partNo = data["part_no"] ?? "";
//         String voterId = data["voter_id"] ?? "";
//         String booth = data["booth"] ?? "";
//         String description = data["description"] ?? "";
//         String assemblyName = data["assembly_name"] ?? "";
//
//         List<String> messageLines = [
//           "----------------------------------------------------",
//           "          Voting Details ",
//           "*Name:* $name $middleName $surname",
//           if (partNo.isNotEmpty) "Part No: $partNo",
//           if (srn.isNotEmpty) "SRN: $srn",
//           if (voterId.isNotEmpty) "Voter ID: $voterId",
//           if (booth.isNotEmpty) "Booth: $booth",
//           if (description.isNotEmpty) "Description: $description",
//           if (assemblyName.isNotEmpty) "Assembly Name: $assemblyName",
//           "----------------------------------------------------"
//         ];
//
//         String message =
//         messageLines.where((line) => line.trim().isNotEmpty).join("\n");
//
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: ImageIcon(AssetImage('assets/logo/whatapps.png'), size: 30),
//               onPressed: () async {
//                 await Share.share(message);
//               },
//             ),
//             if (phoneNumber.isNotEmpty)
//               IconButton(
//                 icon: ImageIcon(AssetImage('assets/logo/mobile.png'), size: 25),
//                 onPressed: () async {
//                   final callUrl = "tel:$phoneNumber";
//                   if (await canLaunch(callUrl)) {
//                     await launch(callUrl);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Unable to make a call')),
//                     );
//                   }
//                 },
//               ),
//             if (phoneNumber.isNotEmpty)
//               IconButton(
//                 icon: Icon(Icons.sms, color: Colors.black),
//                 onPressed: () async {
//                   launch('sms:+91$phoneNumber?body=$message');
//                 },
//               ),
//             IconButton(
//               icon: Icon(Icons.print, color: Colors.black),
//               onPressed: () async {
//
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//
//
// }




class Printcontroller1 extends GetxController {
  final FlutterBluetoothPrinter bluetoothPrinter = FlutterBluetoothPrinter();
  ReceiptController? controller;

  Future<Map<String, dynamic>> fetchPermissions1(
      String userId, String lang) async {
    final url = Uri.parse(
        'https://rajneta.fusiontechlab.site/api/sms-setting?lang=$lang&voter_user_id=$userId&middle_name_check=1&booth_check=1&assembly_name_check=1');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse["data"] ?? {};
      } else {
        print('Error fetching permissions: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('API Error: $e');
      return {};
    }
  }

  Widget buildActionRow1(
      BuildContext context,
      String phoneNumber,
      String userId,
      String lang,
      ) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchPermissions1(userId, lang),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text("");
        }

        final data = snapshot.data ?? {};
        print('Fetched Data: $data');

        String name = data["first_name"] ?? "";
        String middleName = data["middle_name"] ?? "";
        String surname = data["surname"] ?? "";
        String srn = data["srn"] ?? "";
        String partNo = data["part_no"] ?? "";
        String voterId = data["voter_id"] ?? "";
        String booth = data["booth"] ?? "";
        String description = data["description"] ?? "";
        String assemblyname = data["assembly_name"] ?? "";

        List<String> messageLines = [
          "----------------------------------------------------",
          "          Voting Details ",
          "${'Name'.tr}:$name $middleName",

          if (partNo.isNotEmpty) "${'Part No'.tr} : $partNo",

          if (srn.isNotEmpty) "${'srn'.tr} : $srn",

          if (voterId.isNotEmpty) "${'voter Id'.tr} : $voterId",

          if (booth.isNotEmpty) "${'booth'.tr} : $booth",

          if (description.isNotEmpty) "${'description'.tr}: $description",

          if (assemblyname.isNotEmpty) "${'assembly_name'.tr}: $assemblyname",
          "----------------------------------------------------"
        ];

        String message =
        messageLines.where((line) => line.trim().isNotEmpty).join("\n");

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: ImageIcon(AssetImage('assets/logo/whatapps.png'), size: 30),
              onPressed: () async {
                await Share.share(message);
              },
            ),
            if (phoneNumber.isNotEmpty)
              IconButton(
                icon: ImageIcon(AssetImage('assets/logo/mobile.png'), size: 25),
                onPressed: () async {
                  final callUrl = "tel:$phoneNumber";
                  if (await canLaunch(callUrl)) {
                    await launch(callUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unable to make a call')),
                    );
                  }
                },
              ),
            if (phoneNumber.isNotEmpty)
              IconButton(
                icon: Icon(Icons.sms, color: Colors.black),
                onPressed: () async {
                  launch('sms:+91$phoneNumber?body=$message');
                },
              ),
            IconButton(
              icon: Icon(Icons.print, color: Colors.black),
              onPressed: () {
                _printData(context, message);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _printData(BuildContext context, String message) async {
    final device = await FlutterBluetoothPrinter.selectDevice(context);
    if (device != null) {
      Receipt receipt = Receipt(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // लाइन में डेटा प्रिंट करने के लिए जोड़ा गया
          children: message.split('\n').map((line) => Text(line)).toList(),
        ),
        onInitialized: (controller) {
          this.controller = controller;
        },
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          bool isPrinting = false;

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AlertDialog(
                    title: Text(
                      'Print Confirmation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: receipt,
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                          'Print',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            isPrinting = true;
                          });
                          controller?.print(address: device.address);
                          setState(() {
                            isPrinting = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                    contentPadding: EdgeInsets.all(20),
                    actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  if (isPrinting)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            },
          );
        },
      );
    }
  }
}

class PrintPreviewPage extends StatefulWidget {
  final String message;
  final BluetoothDevice device;

  PrintPreviewPage({required this.message, required this.device});

  @override
  _PrintPreviewPageState createState() => _PrintPreviewPageState();
}

class _PrintPreviewPageState extends State<PrintPreviewPage> {
  ReceiptController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Print Preview')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.message),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Receipt receipt = Receipt(
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.message.split('\n').map((line) => Text(line)).toList(),
                      ),
                      onInitialized: (controller) {
                        this.controller = controller;
                      },
                    );

                    await showDialog(
                      context: context,


                      builder: (BuildContext context) {
                        return receipt;
                      },
                    );

                    controller?.print(address: widget.device.address);
                    Navigator.pop(context);
                  },
                  child: Text('Print'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
