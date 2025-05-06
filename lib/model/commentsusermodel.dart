import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_application_2/model/sessionmodel.dart';
import 'package:flutter_application_2/model/usermodel.dart';

/// Use this for parsing comments coming back from the server:
class Commentairesmodel {
  int id;
  String contenu;
  DateTime dateCreation;
  Usermodel user;
  Sessionmodel seancecours;

  Commentairesmodel({
    required this.id,
    required this.contenu,
    required this.dateCreation,
    required this.user,
    required this.seancecours,
  });

  factory Commentairesmodel.fromJson(Map<String, dynamic> json) {
    return Commentairesmodel(
      id: json["id"],
      contenu: json["contenu"],
      dateCreation: DateTime.parse(json["dateCreation"]),
      user: Usermodel.fromJson(json["user"]),
      seancecours: Sessionmodel.fromJson(json["seancecours"]),
    );
  }

  Map<String, dynamic> toJson() {
    // Usually you don’t send back the entire nested user/session on update;
    // but for completeness:
    return {
      "id": id,
      "contenu": contenu,
      "dateCreation": DateFormat('yyyy-MM-dd').format(dateCreation),
      "user": user.toJson(),
      "seancecours": seancecours.toJson(),
    };
  }
}
