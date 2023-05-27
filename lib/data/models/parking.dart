import 'package:cloud_firestore/cloud_firestore.dart';

class Parking {
  String? id;
  String name;
  String group;
  DateTime? from;
  DateTime? to;
  int order;
  bool? wasTaken;

  Parking({this.id, required this.name,required this.group,required this.order, this.from, this.to});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'group': group,
      'order': order,
      'from': from==null?null:Timestamp.fromDate(from!),
      'to': to == null ? null : Timestamp.fromDate(to!),
    };
  }

  factory Parking.fromJson(Map<String, dynamic> json,String id) {
    return Parking(
      id: id,
      name: json['name'] as String,
      group: json['group'] as String,
      order: json['order'],
      from: json['from']==null?null:(json['from'] as Timestamp).toDate(),
      to: json['to']==null?null:(json['to'] as Timestamp).toDate(),
    );
  }
}
