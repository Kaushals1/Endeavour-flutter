import 'package:flutter/cupertino.dart';

class Employee {
  final String uid;
  final String eName;
  final String eEmail;
  Employee({@required this.uid, this.eName, this.eEmail});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        uid: json['uid'], eName: json['eName'], eEmail: json['eEmail']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'eName': eName,
      'eEmail': eEmail,
    };
  }
}
