// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:project_manager/models/employees.dart';
// import 'package:project_manager/models/project.dart';
// import 'package:project_manager/services/firestore_service.dart';
// import 'package:project_manager/task.dart';
// import 'package:uuid/uuid.dart';

// class NewProject extends StatefulWidget {
//   Project project;
//   List lnames = [];
//   List tnames = [];

//   NewProject({this.project, this.lnames, this.tnames});

//   @override
//   _NewProjectState createState() => _NewProjectState();
// }

// class _NewProjectState extends State<NewProject> {
//   String dSelected = 'mm | dd | yy';
//   List leadSelected = [];
//   List teamSelected = [];
//   List leaduid = [];
//   List teamuid = [];
//   String currentUser = '';
//   String currentUid = '';

//   Stream<List<Employee>> ulead;
//   ScrollController _scrollController = new ScrollController();
//   TextEditingController _titleController = new TextEditingController();
//   TextEditingController _descController = new TextEditingController();
//   u() async {
//     if (widget.project == null) {
//       User user = FirebaseAuth.instance.currentUser;
//       DocumentSnapshot variable = await FirebaseFirestore.instance
//           .collection('Employees')
//           .get()
//           .then((snap) {
//         snap.docs.forEach((DocumentSnapshot doc) {
//           if (doc.data()['uid'] == user.uid) {
//             currentUser = doc.data()['eName'];
//             currentUid = doc.data()['uid'];
//           }
//         });
//       });
//       // currentUser = uid[0].data()['uid'];
//       setState(() {
//         leadSelected.add(currentUser);
//         leaduid.add(currentUid);
//         teamuid.add(currentUid);
//       });
//     } else {
//       setState(() {
//         leadSelected = widget.lnames;
//         teamSelected = widget.tnames;
//         leaduid = widget.project.pLeads;
//         teamuid = widget.project.pTeam;
//         _titleController.text = widget.project.pTitle;
//         _descController.text = widget.project.pDesc;
//         dSelected = widget.project.pDeadline;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     u();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         floatingActionButton: GestureDetector(
//           onTap: () {
//             Project project = new Project(
//                 pId: Uuid().v1(),
//                 pDeadline: dSelected,
//                 pDesc: _descController.text,
//                 pTitle: _titleController.text,
//                 pLeads: leaduid,
//                 pTeam: teamuid);

//             FirestoreService().setEntry(project);
//             //apna
//             widget.project == null
//                 ? Navigator.pop(context)
//                 : Navigator.of(context).pop(project);
//           },
//           child: Container(
//             height: 50,
//             width: 80,
//             decoration: BoxDecoration(
//                 color: Colors.greenAccent,
//                 borderRadius: BorderRadius.circular(20)),
//             child: Center(
//                 child: Text(
//               'Save',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w900,
//                   fontSize: 20),
//             )),
//           ),
//         ),
//         resizeToAvoidBottomInset: true,
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           child: GestureDetector(
//             onTap: () {
//               WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
//             },
//             child: ScrollConfiguration(
//               behavior: MyBehavior(),
//               child: SingleChildScrollView(
//                 controller: _scrollController,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 0, right: 8, top: 8),
//                       child: Stack(children: [
//                         Container(
//                           height: 150,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(30),
//                               bottomRight: Radius.circular(30),
//                             ),
//                             image: DecorationImage(
//                                 image: AssetImage(widget.project == null
//                                     ? "assets/b1.jpg"
//                                     : "assets/hand.jpg"),
//                                 fit: BoxFit.cover),
//                           ),
//                         ),
//                         Container(
//                           height: 150,
//                           color: Colors.black.withOpacity(0.75),
//                         ),
//                         Container(
//                           height: 150,
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.keyboard_arrow_left),
//                                     color: Colors.white,
//                                     iconSize: 30,
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               Center(
//                                 child: Text(
//                                   widget.project == null
//                                       ? "Add A New Project"
//                                       : "Edit Project",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 26,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ]),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 12, right: 8, top: 8),
//                       child: Row(
//                         children: [
//                           Text(
//                             "Project Title",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 12, right: 12, top: 8),
//                       child: Container(
//                         height: 50,
//                         decoration: BoxDecoration(
//                             color: Color(0xff313131),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Center(
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                               left: 12,
//                               right: 8,
//                             ),
//                             child: TextFormField(
//                               controller: _titleController,
//                               cursorColor: Colors.white,
//                               style: TextStyle(color: Colors.white),
//                               maxLines: 1,
//                               decoration: InputDecoration.collapsed(
//                                 hintText: "",
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 12, right: 8, top: 12),
//                       child: Row(
//                         children: [
//                           Text(
//                             "Project Description",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 12, right: 12, top: 8),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Color(0xff313131),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Center(
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 12, right: 8, top: 13, bottom: 13),
//                             child: TextFormField(
//                                 controller: _descController,
//                                 cursorColor: Colors.white,
//                                 style: TextStyle(color: Colors.white),
//                                 maxLines: 5,
//                                 decoration:
//                                     InputDecoration.collapsed(hintText: "")),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 12, right: 8, top: 12),
//                       child: Row(
//                         children: [
//                           Text(
//                             "Project Deadline",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                         padding:
//                             const EdgeInsets.only(left: 12, right: 12, top: 8),
//                         child: Row(
//                           children: [
//                             Container(
//                               height: 50,
//                               width: 200,
//                               decoration: BoxDecoration(
//                                   color: Color(0xff313131),
//                                   borderRadius: BorderRadius.circular(20)),
//                               child: Center(
//                                   child: Text(
//                                 '${dSelected}',
//                                 style: TextStyle(color: Colors.grey[600]),
//                               )),
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 Icons.calendar_today,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 WidgetsBinding
//                                     .instance.focusManager.primaryFocus
//                                     ?.unfocus();

//                                 _selectDate(context).then((value) {
//                                   if (value != null) {
//                                     // entryProvider.changeDate = value;

//                                     setState(() {
//                                       dSelected = value.toIso8601String();
//                                     });
//                                   }
//                                 });
//                               },
//                             ),
//                           ],
//                         )),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 12, right: 8, top: 12),
//                       child: Row(
//                         children: [
//                           Text(
//                             "Project Lead",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
//                           child: GestureDetector(
//                             onTap: () async {
//                               WidgetsBinding.instance.focusManager.primaryFocus
//                                   ?.unfocus();
//                               final l = await Navigator.of(context).push(
//                                   CupertinoPageRoute(
//                                       builder: (context) => CDialog(
//                                           type: 'lead',
//                                           leadSelected: leadSelected,
//                                           teamSelected: teamSelected,
//                                           leaduid: leaduid,
//                                           teamuid: teamuid)));
//                               setState(() {
//                                 leadSelected = l[0];
//                                 leaduid = l[1];
//                                 teamuid = l[2];
//                               });
//                             },
//                             child: Container(
//                               height: 50,
//                               // width: 100,
//                               decoration: BoxDecoration(
//                                   color: Colors.blueAccent,
//                                   borderRadius: BorderRadius.circular(20)),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       "Add",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w900,
//                                           fontSize: 18),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 8),
//                                     child: Icon(
//                                       Icons.add,
//                                       color: Colors.white,
//                                       size: 30,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         leadSelected.length > 0
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(22),
//                                 child: Container(
//                                   height: 50,
//                                   width: 280,
//                                   child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: leadSelected.length,
//                                       itemBuilder:
//                                           (BuildContext ctxt, int ind) {
//                                         return Stack(
//                                           children: [
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(6.0),
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             18),
//                                                     color: Colors.white),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets
//                                                           .symmetric(
//                                                       horizontal: 10,
//                                                       vertical: 5),
//                                                   child: Text(
//                                                     leadSelected[ind],
//                                                     style: TextStyle(
//                                                         fontSize: 20,
//                                                         color: Colors.black,
//                                                         fontWeight:
//                                                             FontWeight.w900),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Positioned(
//                                               right: -4,
//                                               top: -4,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(4.0),
//                                                 child: GestureDetector(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       leadSelected
//                                                           .removeAt(ind);
//                                                       leaduid.removeAt(ind);
//                                                       teamuid.removeAt(ind);
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                       height: 22,
//                                                       width: 22,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.redAccent,
//                                                         shape: BoxShape.circle,
//                                                       ),
//                                                       child: Center(
//                                                           child: Text(
//                                                         'x',
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w900),
//                                                       ))),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         );
//                                       }),
//                                 ),
//                               )
//                             : Container()
//                       ],
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 12, right: 8, top: 12),
//                       child: Row(
//                         children: [
//                           Text(
//                             "Project Team",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
//                           child: GestureDetector(
//                             onTap: () async {
//                               WidgetsBinding.instance.focusManager.primaryFocus
//                                   ?.unfocus();
//                               final l = await Navigator.of(context).push(
//                                   CupertinoPageRoute(
//                                       builder: (context) => CDialog(
//                                           type: 'team',
//                                           leadSelected: leadSelected,
//                                           teamSelected: teamSelected,
//                                           leaduid: leaduid,
//                                           teamuid: teamuid)));
//                               setState(() {
//                                 teamSelected = l[0];
//                                 leaduid = l[1];
//                                 teamuid = l[2];
//                               });
//                             },
//                             child: Container(
//                               height: 50,
//                               // width: 100,
//                               decoration: BoxDecoration(
//                                   color: Colors.blueAccent,
//                                   borderRadius: BorderRadius.circular(20)),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       "Add",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w900,
//                                           fontSize: 18),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 8),
//                                     child: Icon(
//                                       Icons.add,
//                                       color: Colors.white,
//                                       size: 30,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         teamSelected.length > 0
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(22),
//                                 child: Container(
//                                   height: 50,
//                                   width: 280,
//                                   child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: teamSelected.length,
//                                       itemBuilder:
//                                           (BuildContext ctxt, int ind) {
//                                         return Stack(
//                                           children: [
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(6.0),
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             18),
//                                                     color: Colors.white),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets
//                                                           .symmetric(
//                                                       horizontal: 10,
//                                                       vertical: 5),
//                                                   child: Text(
//                                                     teamSelected[ind],
//                                                     style: TextStyle(
//                                                         fontSize: 20,
//                                                         color: Colors.black,
//                                                         fontWeight:
//                                                             FontWeight.w900),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Positioned(
//                                               right: -4,
//                                               top: -4,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(4.0),
//                                                 child: GestureDetector(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       teamSelected
//                                                           .removeAt(ind);
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                       height: 22,
//                                                       width: 22,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.redAccent,
//                                                         shape: BoxShape.circle,
//                                                       ),
//                                                       child: Center(
//                                                           child: Text(
//                                                         'x',
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w900),
//                                                       ))),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         );
//                                       }),
//                                 ),
//                               )
//                             : Container()
//                       ],
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 12, right: 8, top: 12),
//                       child: Row(
//                         children: [
//                           Text(
//                             "Project Tasks",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
//                           child: Container(
//                             height: 50,
//                             // width: 100,
//                             decoration: BoxDecoration(
//                                 color: Colors.blueAccent,
//                                 borderRadius: BorderRadius.circular(20)),
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     "Add",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w900,
//                                         fontSize: 18),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8),
//                                   child: Icon(
//                                     Icons.add,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // void showmera() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return CDialog();
//   //     },
//   //   );
//   // }
// }

// _selectDate(BuildContext context) async {
//   final DateTime picked = await showDatePicker(
//     context: context,
//     initialDate: DateTime.now(), // Refer step 1
//     firstDate: DateTime(2000),
//     lastDate: DateTime(2025),
//   );
//   return picked;
// }

// class CDialog extends StatefulWidget {
//   String type = '';
//   List leadSelected = [];
//   List teamSelected = [];
//   List leaduid = [];
//   List teamuid = [];

//   CDialog(
//       {this.type,
//       this.leadSelected,
//       this.teamSelected,
//       this.leaduid,
//       this.teamuid});
//   @override
//   _CDialogState createState() => _CDialogState();
// }

// class _CDialogState extends State<CDialog> {
//   List<String> country = [
//     "America",
//     "Brazil",
//     "Canada",
//     "India",
//     "Mongalia",
//     "USA",
//     "China",
//     "Russia",
//     "Germany",
//     "Aditya",
//     "Kaushal"
//   ];
//   List mylist = [];
//   List searchList = [];
//   List selected = [];
//   List<List> data = [];
//   double h;
//   String query = '';
//   TextEditingController search = new TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     widget.type == 'lead'
//         ? selected = widget.leadSelected
//         : selected = widget.teamSelected;
//     data.add(selected);

//     data.add(widget.leaduid);
//     data.add(widget.teamuid);

//     // calculating height
//     if (selected.length == 0 && MediaQuery.of(context).viewInsets.bottom == 0) {
//       h = MediaQuery.of(context).size.height - 85;
//     } else if (selected.length == 0 &&
//         MediaQuery.of(context).viewInsets.bottom > 0) {
//       h = MediaQuery.of(context).size.height -
//           90 -
//           MediaQuery.of(context).viewInsets.bottom;
//     } else if (selected.length > 0 &&
//         MediaQuery.of(context).viewInsets.bottom == 0) {
//       h = MediaQuery.of(context).size.height - 130;
//     } else if (selected.length > 0 &&
//         MediaQuery.of(context).viewInsets.bottom > 0) {
//       h = MediaQuery.of(context).size.height -
//           130 -
//           MediaQuery.of(context).viewInsets.bottom;
//     }
//     onBackPressed() {
//       Navigator.of(context).pop(data);
//     }

//     // modifying list as per search
//     mylist = search.text == ''
//         ? country
//         : country
//             .where((element) => element.toLowerCase().contains(query))
//             .toList();
//     return WillPopScope(
//       onWillPop: () {
//         onBackPressed();
//         return Future.value(false);
//       },
//       child: Scaffold(
//         floatingActionButton: GestureDetector(
//           onTap: () {
//             Navigator.of(context).pop(data);
//           },
//           child: Container(
//             height: 40,
//             width: 80,
//             decoration: BoxDecoration(
//                 color: Colors.greenAccent,
//                 borderRadius: BorderRadius.circular(20)),
//             child: Center(
//                 child: Text(
//               'Done',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w900,
//                   fontSize: 20),
//             )),
//           ),
//         ),
//         resizeToAvoidBottomInset: true,
//         backgroundColor: Colors.black,
//         body: SingleChildScrollView(
//           child: SafeArea(
//             child: Container(
//               color: Colors.black.withOpacity(0.5),
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       height: 50,
//                       width: 350,
//                       decoration: BoxDecoration(
//                           color: Color(0xff313131),
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                             left: 12,
//                             right: 8,
//                           ),
//                           child: TextFormField(
//                               controller: search,
//                               cursorColor: Colors.white,
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 20),
//                               onChanged: (value) {
//                                 setState(() {
//                                   query = value;
//                                 });
//                               },
//                               maxLines: 1,
//                               decoration: InputDecoration.collapsed(
//                                   hintStyle: TextStyle(
//                                       color: Colors.grey[600], fontSize: 18),
//                                   hintText: "Search by name or email Id")),
//                         ),
//                       ),
//                     ),
//                   ),
//                   selected.length > 0
//                       ? Container(
//                           height: 50,
//                           width: MediaQuery.of(context).size.width,
//                           child: ScrollConfiguration(
//                             behavior: MyBehavior(),
//                             child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: selected.length,
//                                 itemBuilder: (BuildContext ctxt, int ind) {
//                                   return Stack(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(6.0),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(18),
//                                               color: Colors.white),
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8),
//                                             child: Text(
//                                               selected[ind],
//                                               style: TextStyle(
//                                                   fontSize: 20,
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w900),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         right: -4,
//                                         top: -4,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 selected.removeAt(ind);
//                                                 // widget.leaduid.removeAt(widget.leaduid.indexOf(selected[ind]));
//                                                 // widget.teamuid.removeAt(widget.teamuid.indexOf(selected[ind]));
//                                               });
//                                             },
//                                             child: Container(
//                                                 height: 20,
//                                                 width: 20,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.redAccent,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: Center(
//                                                     child: Text(
//                                                   'x',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w900),
//                                                 ))),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   );
//                                 }),
//                           ))
//                       : Container(),
//                   Container(
//                     height: h,
//                     decoration: BoxDecoration(
//                         // color: Colors.transparent,
//                         ),
//                     child: ScrollConfiguration(
//                         behavior: MyBehavior(),
//                         child: StreamBuilder<List<Employee>>(
//                             stream: FirestoreService().getEmployees(),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return CircularProgressIndicator();
//                               }
                               
//                               return ListView.builder(
//                                   itemCount: snapshot.data.length,
//                                   itemBuilder: (context, index) {
//                                     return selected
//                                             .contains(snapshot.data[index].eName)
//                                         ? Container()
//                                         : Material(
//                                             color: Colors.transparent,
//                                             child: InkWell(
//                                               onTap: () {
//                                                 setState(() {
//                                                   selected.add(snapshot
//                                                       .data[index].eName);
//                                                   if (widget.type == 'lead') {
//                                                     widget.leaduid.add(snapshot
//                                                         .data[index].uid);
//                                                     widget.teamuid.add(snapshot
//                                                         .data[index].uid);
//                                                   } else {
//                                                     widget.teamuid.add(snapshot
//                                                         .data[index].uid);
//                                                   }
//                                                 });
//                                                 print(widget.leaduid);
//                                                 print(widget.teamuid);
//                                               },
//                                               highlightColor:
//                                                   Colors.white.withOpacity(0.3),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         snapshot.data[index].eName,
//                                                         style: TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize: 22),
//                                                       ),
//                                                       Text(
//                                                         snapshot
//                                                             .data[index].eEmail,
//                                                         style: TextStyle(
//                                                             color: Colors.grey,
//                                                             fontSize: 16),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                   });
//                             })),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // showDialog(
// //                   barrierColor: Colors.black.withOpacity(0.9),
// //                   context: context,
// //                   builder: (context) {
// //                     return AlertDialog(
// //                       backgroundColor: Color(0xff313131),
// //                       title: Padding(
// //                           padding: const EdgeInsets.all(4.0),
// //                           child: Icon(
// //                             Icons.check_circle,
// //                             size: 50,
// //                             color: Colors.greenAccent,
// //                           )),
// //                       content: Text(
// //                         'Project Added!',
// //                         style: TextStyle(
// //                             fontSize: 25,
// //                             fontWeight: FontWeight.w900,
// //                             color: Colors.white),
// //                       ),
// //                       actions: [
// //                         FlatButton(
// //                           onPressed: () {
// //                            Navigator.of(context).popUntil(ModalRoute.withName('/home'));
// //                           },
// //                           child: Text('Close'),
// //                         )
// //                       ],
// //                     );
// //                   });
// //             });


// ///
// ///
// class CDialog2 extends StatefulWidget {
//   @override
//   _CDialog2State createState() => _CDialog2State();
// }

// class _CDialog2State extends State<CDialog2> {
//   onBackPressed() {
//     Navigator.of(context).pop();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return   WillPopScope(
//       onWillPop: () {
//         onBackPressed();
//         return Future.value(false);
//       },
//       child: Scaffold(
//         floatingActionButton: GestureDetector(
//           onTap: () {
//             // Navigator.of(context).pop(data);
//           },
//           child: Container(
//             height: 40,
//             width: 80,
//             decoration: BoxDecoration(
//                 color: Colors.greenAccent,
//                 borderRadius: BorderRadius.circular(20)),
//             child: Center(
//                 child: Text(
//               'Done',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w900,
//                   fontSize: 20),
//             )),
//           ),
//         ),
//         resizeToAvoidBottomInset: true,
//         backgroundColor: Colors.black,
//         body: SingleChildScrollView(
//           child: SafeArea(
//             child: Container(
//               color: Colors.black.withOpacity(0.5),
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       height: 50,
//                       width: 350,
//                       decoration: BoxDecoration(
//                           color: Color(0xff313131),
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                             left: 12,
//                             right: 8,
//                           ),
//                           child: TextFormField(
//                               // controller: search,
//                               cursorColor: Colors.white,
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 20),
//                               onChanged: (value) {
//                                 setState(() {
//                                   // query = value;
//                                 });
//                               },
//                               maxLines: 1,
//                               decoration: InputDecoration.collapsed(
//                                   hintStyle: TextStyle(
//                                       color: Colors.grey[600], fontSize: 18),
//                                   hintText: "Search by name or email Id")),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // selected.length > 0?
//                        Container(
//                           height: 50,
//                           width: MediaQuery.of(context).size.width,
//                           child: ScrollConfiguration(
//                             behavior: MyBehavior(),
//                             child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: 10 ,
//                                 itemBuilder: (BuildContext ctxt, int ind) {
//                                   return Stack(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(6.0),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(18),
//                                               color: Colors.white),
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8),
//                                             child: Text("sel",
//                                               // selected[ind],
//                                               style: TextStyle(
//                                                   fontSize: 20,
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w900),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         right: -4,
//                                         top: -4,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               // setState(() {
//                                               //   selected.removeAt(ind);
//                                               //   widget.type == 'lead'
//                                               //       ? widget.leaduid
//                                               //           .removeAt(ind)
//                                               //       : widget.teamuid
//                                               //           .removeAt(ind);
//                                               // });
//                                             },
//                                             child: Container(
//                                                 height: 20,
//                                                 width: 20,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.redAccent,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: Center(
//                                                     child: Text(
//                                                   'x',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w900),
//                                                 ))),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   );
//                                 }),
//                           ))
//                        ,
//                   Container(
//                     height: 500,
//                     decoration: BoxDecoration(
//                         // color: Colors.transparent,
//                         ),
//                     child: ScrollConfiguration(
//                         behavior: MyBehavior(),
//                         child: StreamBuilder<List<Employee>>(
//                             stream: FirestoreService().getEmployees(),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return CircularProgressIndicator();
//                               }

//                               return ListView.builder(
//                                   itemCount: snapshot.data.length,
//                                   itemBuilder: (context, index) {
//                                     // return selected.contains(
//                                     //             snapshot.data[index].eName) ||
//                                     //         widget.leadSelected.contains(
//                                     //             snapshot.data[index].eName) ||
//                                     //         widget.teamSelected.contains(
//                                     //             snapshot.data[index].eName)
//                                         // ?Container()
//                                          Material(
//                                             color: Colors.transparent,
//                                             child: InkWell(
//                                               onTap: () {
//                                                 // setState(() {
//                                                 //   selected.add(snapshot
//                                                 //       .data[index].eName);
//                                                 //   if (widget.type == 'lead') {
//                                                 //     widget.leaduid.add(snapshot
//                                                 //         .data[index].uid);
//                                                 //     // widget.teamuid.add(snapshot
//                                                 //     //     .data[index].uid);
//                                                 //   } else {
//                                                 //     widget.teamuid.add(snapshot
//                                                 //         .data[index].uid);
//                                                 //   }
//                                                 // });
//                                                 // print(widget.leaduid);
//                                                 // print(widget.teamuid);
//                                               },
//                                               highlightColor:
//                                                   Colors.white.withOpacity(0.3),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         snapshot
//                                                             .data[index].eName,
//                                                         style: TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize: 22),
//                                                       ),
//                                                       Text(
//                                                         snapshot
//                                                             .data[index].eEmail,
//                                                         style: TextStyle(
//                                                             color: Colors.grey,
//                                                             fontSize: 16),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                   });
//                             })),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }