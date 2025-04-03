import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PrintControllerData extends GetxController {
  final FlutterBluetoothPrinter bluetoothPrinter = FlutterBluetoothPrinter();
  ReceiptController? controller;

  Future<Map<String, dynamic>> fetchPermissionsData(
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

  Widget buildActionRow(
      BuildContext context, String phoneNumber, String userId, String lang) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchPermissionsData(userId, lang),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text("");
        }

        final data = snapshot.data ?? {};
        String name = data["first_name"] ?? "";
        String middleName = data["middle_name"] ?? "";
        String surname = data["surname"] ?? "";
        String srn = data["srn"] ?? "";
        String partNo = data["part_no"] ?? "";
        String voterId = data["voter_id"] ?? "";
        String booth = data["booth"] ?? "";
        String description = data["description"] ?? "";
        String assemblyName = data["assembly_name"] ?? "";

        List<String> messageLines = [
          "----------------------------------------------------",
          "          Voting Details ",
          "*Name:* $name $middleName $surname",
          if (partNo.isNotEmpty) "Part No: $partNo",
          if (srn.isNotEmpty) "SRN: $srn",
          if (voterId.isNotEmpty) "Voter ID: $voterId",
          if (booth.isNotEmpty) "Booth: $booth",
          if (description.isNotEmpty) "Description: $description",
          if (assemblyName.isNotEmpty) "Assembly Name: $assemblyName",
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
              onPressed: () async {
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
      // Create a Receipt widget with your message content
      Receipt receipt = Receipt(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: message.split('\n').map((line) => Text(line)).toList(),
        ),
        onInitialized: (controller) {
          this.controller = controller;
        },
      );
      // Ensure the receipt is built before printing
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return receipt;
        },
      );
      controller?.print(address: device.address);
    }
  }

}

