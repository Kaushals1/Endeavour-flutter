// import 'package:flutter/material.dart';
// import 'package:project_manager/models/entry.dart';
// import 'package:project_manager/services/firestore_service.dart';
// import 'package:uuid/uuid.dart';

// class EntryProvider with ChangeNotifier {
//   final firestoreService = FirestoreService();
//   DateTime _date=DateTime.now();
//   String _entry="kaushal";
//   String _entryId;
//   var uuid = Uuid();

//   //Getters
//   DateTime get date => _date;
//   String get entry => _entry;
//   Stream<List<Entry>> get entries => firestoreService.getEntries();

//   //Setters
//   set changeDate(DateTime date) {
//     _date = date;
//     notifyListeners();
//   }

//   set changeEntry(String entry) {
//     _entry = entry;
//     notifyListeners();
//   }

//   //Functions
//   loadAll(Entry entry) {
//     print('loadall');
//     if (entry != null) {
//       _date = DateTime.parse(entry.date);
//       _entry = entry.entry;
//       _entryId = entry.entryId;
//     } else {
//       print('loadall else');

//       _date = DateTime.now();
//       _entry = "kaushal";
//       _entryId = null;
//       print(_date);
//       print(_entry);
//       print(_entryId);

//     }
//   }

//   saveEntry() {
//     if (_entryId == null) {
//       //Add
//       var newEntry = Entry(
//           date: _date.toIso8601String(), entry: _entry, entryId: uuid.v1());
//       // print(newEntry.entryId);
//       // print(newEntry.entry);
//       // print(newEntry.date);

//       firestoreService.setEntry(newEntry);
//     } else {
//       //Edit
//       var updatedEntry = Entry(
//           date: _date.toIso8601String(), entry: _entry, entryId: _entryId);
//       firestoreService.setEntry(updatedEntry);
//     }
//   }

//   removeEntry(String entryId) {
//     firestoreService.removeEntry(entryId);
//   }
// }
