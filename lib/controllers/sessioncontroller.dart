  import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/model/sessionmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Sessioncontroller extends GetxController {
  static Sessioncontroller get instance => Get.find();


Future<Map<String, dynamic>> createsession(Sessionmodel session) async {
 try {
      final response = await http.post(
        Uri.parse(addseancce),
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
 Future<List<Sessionmodel>> getallsessions() async {
try {
   final prefs = await SharedPreferences.getInstance(); 
  final uri = Uri.parse(getallseances);
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
      return jsonData.map((item) => Sessionmodel.fromJson(item)).toList();
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
 Future<bool> deletesession(int coursid) async {
  try{
    // 1. Construct URL with query parameter
    final url = Uri.parse('$deleteseance?coursid=$coursid');
    
    // 2. Debug print the actual URL
    print(' DELETE URL: $url');

    // 3. Send DELETE request
    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // 4. Handle response
    print(' Status Code: ${response.statusCode}');
    print(' Response Body: ${response.body.isEmpty ? "<empty>" : response.body}');

    return response.statusCode == 200;

  } catch (e) {
    print(' Delete Error: $e');
    return false;
  }
}
Future<bool> updateSession(Map<String,dynamic>session, int coursid) async {
 try {
    print('🔍 Starting update for session ID: $coursid');
    
    // Validate ID
    if (coursid <= 0) {
      print('⛔ Invalid ID: $coursid');
      return false;
    }

    // Verify URL
    final url = Uri.parse('$updateseance/$coursid');
    print('🌐 Full URL: ${url.toString()}');

    // Log raw data being sent
    print('📦 Raw JSON Data:');
    print(jsonEncode(session));

    final stopwatch = Stopwatch()..start();
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(session),
    );
    print('⏱️ Response time: ${stopwatch.elapsedMilliseconds}ms');

    // Log full response details
    print('⚡ Status Code: ${response.statusCode}');
    print('📄 Response Body: ${response.body.isEmpty ? "<empty>" : response.body}');
    print('🔠 Response Headers: ${response.headers}');

    // Handle specific status codes
    switch(response.statusCode) {
      case 200:
        print('✅ Update successful');
        return true;
      case 400:
        print('❌ Bad Request - Invalid data format');
        break;
      case 401:
        print('🔐 Unauthorized - Missing/invalid token');
        break;
      case 404:
        print('🔎 Not Found - Session ID $coursid doesn\'t exist');
        break;
      case 422:
        print('📛 Validation Failed - Check field requirements');
        break;
      default:
        print('⚠️ Unexpected status: ${response.statusCode}');
    }
    
    return false;
  } catch (e, stack) {
    print('🔥 Critical Error:');
    print('   - Type: ${e.runtimeType}');
    print('   - Error: $e');
    print('   - Stack Trace: $stack');
    return false;
  }
}
}

