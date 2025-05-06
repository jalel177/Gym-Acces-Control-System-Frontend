import 'package:flutter/foundation.dart';
import 'package:flutter_application_2/controllers/subscriptioncontroller.dart';
import 'package:flutter_application_2/model/subscriptionmodel.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SubscriptionProvider with ChangeNotifier {
  
   final Subscriptioncontroller _subsccriptioncontroller = Get.find<Subscriptioncontroller>();
   
   final List<Subscriptionmodel> _subs = [];
    Subscriptionmodel? _currentSubscription;

  Subscriptionmodel? get currentSubscription => _currentSubscription;
  String? get type => _currentSubscription?.type;
  DateTime? get startDate => _currentSubscription?.datedebut;
  DateTime? get endDate => _currentSubscription?.datefin;

     void AddSubscription(Subscriptionmodel sub) {
    _subs.add( sub); 
    _currentSubscription=sub;
    notifyListeners();
  }}