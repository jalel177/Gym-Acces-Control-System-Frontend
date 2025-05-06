// To parse this JSON data, do
//
//     final subscriptionmodel = subscriptionmodelFromJson(jsonString);

import 'dart:convert';

Subscriptionmodel subscriptionmodelFromJson(String str) => Subscriptionmodel.fromJson(json.decode(str));

String subscriptionmodelToJson(Subscriptionmodel data) => json.encode(data.toJson());

class Subscriptionmodel {
    int? id;
    String type;
    DateTime datedebut;
    DateTime datefin;

    Subscriptionmodel({
        this.id,
        required this.type,
        required this.datedebut,
        required this.datefin,
    });

    factory Subscriptionmodel.fromJson(Map<String, dynamic> json) => Subscriptionmodel(
        id: json["id"],
        type: json["type"],
        datedebut: DateTime.parse(json["datedebut"]),
        datefin: DateTime.parse(json["datefin"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "datedebut": "${datedebut.year.toString().padLeft(4, '0')}-${datedebut.month.toString().padLeft(2, '0')}-${datedebut.day.toString().padLeft(2, '0')}",
        "datefin": "${datefin.year.toString().padLeft(4, '0')}-${datefin.month.toString().padLeft(2, '0')}-${datefin.day.toString().padLeft(2, '0')}",
    };
}
