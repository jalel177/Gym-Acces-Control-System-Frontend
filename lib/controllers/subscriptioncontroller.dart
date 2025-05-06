import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/model/subscriptionmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Subscriptioncontroller extends GetxController {
  static Subscriptioncontroller get instance => Get.find();


Future<Map<String, dynamic>> createsubscription(Subscriptionmodel session) async {
 try {
      final response = await http.post(
        Uri.parse(addabo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(session.toJson()),
      );

      // Return BOTH status and raw body
      return {
        "status": response.statusCode == 200,
        "body": response.body, // ✅ Add this line
        "error": response.statusCode != 200 ? response.body : null
      };
    } catch (e) {
      return {"status": false, "error": "$e"};
    }
  }
   Future<List<Subscriptionmodel>> getallsubscriptions() async {
try {
   final prefs = await SharedPreferences.getInstance(); 
  final uri = Uri.parse(getallabo);
  final token = prefs.getString('token');
  
  if (token == null) {
    print('No authentication token found');
    return [];
  }

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Required for admin verification
    },
  ).timeout(const Duration(seconds: 10));

  if (response.statusCode == 200) {
    if (response.body.isEmpty) return [];
    
    try {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Subscriptionmodel.fromJson(item)).toList();
    } catch (e) {
      print('JSON parsing error: $e');
      return [];
    }
  } 
  else if (response.statusCode == 403) { // Admin role required
    print('Admin privileges required');
    throw Exception('Admin access required'); // Special error for UI handling
  }
  else {
    print('Server error: ${response.statusCode} - ${response.body}');
    return [];
  }
  
} on SocketException {
  print('Network connection failed');
  return [];
} on TimeoutException {
  print('Request timed out');
  return [];
} on http.ClientException catch (e) {
  print('HTTP client error: $e');
  return [];
} catch (e) {
  print('Unexpected error: $e');
  return [];
}
}
}