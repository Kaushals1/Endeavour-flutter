class Task {
  String tId;
  String pId;
  String tTitle;
  String tDesc;
  List assignedTo;
  bool isCompleted=false;
  Task({this.tId, this.pId, this.tTitle, this.tDesc, this.assignedTo,this.isCompleted});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      tId: json['tId'],
      pId: json['pId'],
      tTitle: json['tTitle'],
      tDesc: json['tDesc'],
      assignedTo: json['assignedTo'],
      isCompleted: json['isCompleted'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tId': tId,
      'pId': pId,
      'tTitle': tTitle,
      'tDesc': tDesc,
      'assignedTo': assignedTo,
      'isCompleted':isCompleted
    };
  }
}
