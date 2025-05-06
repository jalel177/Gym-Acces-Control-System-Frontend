import 'package:flutter/foundation.dart';
import 'package:flutter_application_2/controllers/sessioncontroller.dart';
import 'package:flutter_application_2/model/sessionmodel.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SessionProvider with ChangeNotifier {
   final Sessioncontroller _sessioncontroller = Get.find<Sessioncontroller>();
   List<Sessionmodel> _sessions = [];
  bool isLoading = false;
  List<Sessionmodel> get sessions => _sessions;
    String? errorMessage;
  Future<void> getallsessions() async {
        try {
      isLoading = true;
      notifyListeners();

      // Get raw response
      final rawResponse = await _sessioncontroller.getallsessions();
      
      // Debug raw response
      print('Raw API Response: $rawResponse');

      _sessions = rawResponse.map((item) {
        return Sessionmodel.fromJson(item as Map<String, dynamic>);
      }).toList();

      errorMessage = null;

    } on FormatException catch (e) {
      errorMessage = 'Data format error: ${e.message}';
      print('JSON Parsing Error: $e');
    } catch (e) {
      errorMessage = 'Connection error: ${e.toString()}';
      print('General Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  void addSession(Sessionmodel session) {
    _sessions.add( session); // Newest at beginning
    notifyListeners();
  }
void updateSession(int index, Sessionmodel updatedSession) {
  // Create NEW list instance
  final newList = List<Sessionmodel>.from(_sessions);
  newList[index] = updatedSession;
  
  // Replace entire list reference
  _sessions = newList;
  
  notifyListeners();
}

void deleteSession(int index) {
  _sessions.removeAt(index);
  notifyListeners();
}
}
