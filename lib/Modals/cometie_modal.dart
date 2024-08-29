import 'package:cloud_firestore/cloud_firestore.dart';

class CometieModal {
  String name;
  int amount;
  List members;
  int duration;
  String status;
  Timestamp createdAt;
  Timestamp launchedAt;
  Timestamp completedAt;

  CometieModal(
      {required this.name,
        required this.amount,
        required this.members,
        required this.duration,
        required this.status,
        required this.launchedAt,
        required this.createdAt,
        required this.completedAt,
      });

  // from map
  factory CometieModal.fromMap(Map<String, dynamic>map){
    return CometieModal(
        name: map['name'] ?? '',
        amount: map['amount'] ?? '',
        members: map['members'] ?? '',
        duration: map['duration'] ?? '',
        status: map['status'] ?? '',
        createdAt: map['createdAt'] ?? '',
        launchedAt: map['launchedAt'] ?? '',
        completedAt: map['completedAt'] ?? '',
    );
  }

  // to Map
  Map<String , dynamic>toMap(){
    return {
      "name": name,
      "amount": amount,
      "members": members,
      "duration": duration,
      "status": status,
      "createdAt": createdAt,
      "launchedAt":launchedAt,
      "completedAt":completedAt,
    };
  }
}
