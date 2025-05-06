import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/config/config.dart' as ApiEndpoints;
import 'package:flutter_application_2/model/usermodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  
Future<Map<String, dynamic>> signinController(Usermodel user) async {
    try {
    var response = await http.post(
      Uri.parse(signin),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": user.username, "password": user.password}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['access_token'] ?? jsonResponse['token'];
          final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('username', user.username?? "no username");
      if (jsonResponse.containsKey('email')) {
        await prefs.setString('email', jsonResponse['email']);
      }
      
      // Parse JWT to get roles
      final roles = parseJwt(token)['realm_access']['roles'] ?? [];
      
      return {
        "status": true, 
        "token": token,
        "roles": List<String>.from(roles)
      };
    } else {
      return {"status": false, "error": "Invalid credentials"};
    }
  } catch (e) {
    print("Error: $e");
    return {"status": false, "error": "Check your connection"};
  }
}

// Add JWT parsing function
Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw Exception('Invalid token');
  
  final payload = _decodeBase64(parts[1]);
  return jsonDecode(payload);
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');
  switch (output.length % 4) {
    case 0: break;
    case 2: output += '=='; break;
    case 3: output += '='; break;
    default: throw Exception('Illegal base64url string!');
  }
  return utf8.decode(base64Url.decode(output));
}
    Future<Map<String, dynamic>> signupController(Usermodel user) async {
    var response = await http.post(
      Uri.parse(signup),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == true) {
      return {"status": true, "success": "User Registered Successfully"};
    } else {
      return {
        "status": false,
        "error": jsonResponse['message'] ?? "Registration Failed",
      };
    }
  }
     Future<List<Usermodel>> getallusers() async {
try {
   final prefs = await SharedPreferences.getInstance(); 
  final uri = Uri.parse(getusers);
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
      return jsonData.map((item) => Usermodel.fromJson(item)).toList();
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
Future<bool> deleteuser(String userid) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    // Debug 1: Print authentication status
    print('AUTH STATUS: ${token != null ? "Authenticated" : "NOT AUTHENTICATED"}');
    if (token == null) {
      print('⚠️ No token found in SharedPreferences');
      return false;
    }

    // Debug 2: Verify base URL from config
    const configUrl = ApiEndpoints.deleteuser; // Add this line
    print('CONFIG URL: $configUrl');

    // Debug 3: Construct URL with verification
    final fullUrl = Uri.parse('$configUrl?userid=$userid');
    print('FULL URL DEBUG:');
    print('| Scheme: ${fullUrl.scheme}');
    print('| Host: ${fullUrl.host}');
    print('| Path: ${fullUrl.path}');
    print('| Query: ${fullUrl.query}');

    if (fullUrl.host.isEmpty) {
      print('❌ INVALID URL: Missing host in constructed URL');
      return false;
    }

    final response = await http.delete(
      fullUrl,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      
    );

    // Debug 4: Response analysis
    print('RESPONSE ANALYSIS:');
    print('| Status: ${response.statusCode}');
    print('| Headers: ${response.headers}');
    print('| Body: ${response.body.isEmpty ? "<empty>" : response.body}');

    return response.statusCode == 200;
  } catch (e, stack) {
    print('‼️ CRITICAL ERROR:');
    print('| Error: $e');
    print('| Stack: $stack');
    return false;
  }
}
}