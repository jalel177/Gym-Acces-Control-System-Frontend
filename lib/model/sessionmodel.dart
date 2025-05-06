import 'dart:convert';

import 'package:intl/intl.dart';

Sessionmodel sessionmodelFromJson(String str) => Sessionmodel.fromJson(json.decode(str));

String sessionmodelToJson(Sessionmodel data) => json.encode(data.toJson());

class Sessionmodel {
    int?coursid;
    String sportname;
    DateTime? date;
    String? entraineur;
    String? duration;
      List<dynamic>? users;

    Sessionmodel({
         this.coursid,
        required this.sportname,
         this.date,
         this.entraineur,
        this.duration,
        this.users
    });

    factory Sessionmodel.fromJson(Map<String, dynamic> json){
    final rawDate = json['date']?.toString();
    final formattedDate = rawDate?.replaceAll(' ', 'T') ?? '';
      return Sessionmodel(
      coursid: _parseInt(json['coursid']),
      sportname: json['sportname'].toString(),
      entraineur: json['entraineur']?.toString(),
            users: json['users'] != null
          ? List<dynamic>.from(json['users'].map((x) => x))
          : null,
      duration: json['duration']?.toString(),
      date: DateTime.tryParse(formattedDate),);}
    
    
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  


    Map<String, dynamic> toJson() => {
    "coursid": coursid,
  "sportname": sportname,
  "date": date != null 
      ? DateFormat('yyyy-MM-dd HH:mm:ss').format(date!) 
      : null, // Allow null dates
  "entraineur": entraineur,
  "duration": duration,
    };
}
