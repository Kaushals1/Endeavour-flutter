import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/models/employees.dart';
import 'package:project_manager/models/project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_manager/models/task.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser;

  //Get Entries
  Stream<List<Project>> getProjects() {
    return _db.collection('Projects').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList());
  }

  Stream<List<Project>> getProjects2() {
    return _db
        .collection('Projects')
        .where('pTeam', arrayContains: user.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList());
  }

  Stream<List<Employee>> getEmployees() {
    return _db.collection('Employees').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Employee.fromJson(doc.data())).toList());
  }

   Stream<List<Task>> getTasks() {
    return _db.collection('Tasks').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
  }
  Stream<List<Task>> getTasks2() {
    return _db.collection('Tasks').where('assignedTo',arrayContains: user.uid).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
  }

  //Upsert
  Future<void> setEntry(Project project) {
    var options = SetOptions(merge: true);
    // print(entry.entryId);

    return _db
        .collection('Projects')
        .doc(project.pId)
        .set(project.toMap(), options);
  }

   Future<void> addTask(Task task) {
    var options = SetOptions(merge: true);
    // print(entry.entryId);

    return _db
        .collection('Tasks')
        .doc(task.tId)
        .set(task.toMap(), options);
  }

  
  Future<void> removeTask(String tId){
    return _db
      .collection('Tasks')
      .doc(tId)
      .delete();
  }

}
