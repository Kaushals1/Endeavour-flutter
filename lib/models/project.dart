import 'package:flutter/cupertino.dart';

class Project {
  String pId;
  String pTitle;
  String pDesc;
  String pDeadline;
  List pLeads;
  List pTeam;
  List pTasks;
  Project(
      {@required this.pId,
      this.pTitle,
      this.pDesc,
      this.pDeadline,
      this.pLeads,
      this.pTeam,
      this.pTasks});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        pId: json['pId'],
        pTitle: json['pTitle'],
        pDesc: json['pDesc'],
        pDeadline: json['pDeadline'],
        pLeads: json['pLeads'],
        pTeam: json['pTeam'],
        pTasks: json['pTasks'],
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'pId': pId,
      'pTitle': pTitle,
      'pDesc': pDesc,
      'pDeadline': pDeadline,
      'pLeads': pLeads,
      'pTeam': pTeam,
      'pTasks': pTasks,

    };
  }
}
