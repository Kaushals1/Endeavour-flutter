import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/employees.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/screens/newTask.dart';
import 'package:project_manager/services/firestore_service.dart';
import 'package:project_manager/task.dart';
import 'package:uuid/uuid.dart';

class NewProject extends StatefulWidget {
  Project project;
  List lnames = [];
  List tnames = [];
  List tempTasks = [];

  NewProject({this.project, this.lnames, this.tnames, this.tempTasks});

  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  String dSelected = 'dd | mm | yy';
  List leadSelected = [];
  List teamSelected = [];
  List leaduid = [];
  List teamuid = [];
  List tasks = [];
  List removedTasks = [];
  String currentUser = '';
  String currentUid = '';
  List<Widget> taskWidgets = [];
  Stream<List<Employee>> ulead;
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  u() async {
    if (widget.project == null) {
      User user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('Employees')
          .get()
          .then((snap) {
        snap.docs.forEach((DocumentSnapshot doc) {
          if (doc.data()['uid'] == user.uid) {
            currentUser = doc.data()['eName'];
            currentUid = doc.data()['uid'];
          }
        });
      });
      setState(() {
        leadSelected.add(currentUser);
        leaduid.add(currentUid);
      });
    } else {
      List tempTasks =
          new List.generate(widget.project.pTasks.length, (index) => 'a');

      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('Tasks')
          .get()
          .then((snap) {
        snap.docs.forEach((DocumentSnapshot doc) {
          if (widget.project.pTasks.contains(doc.data()['tId'])) {
            tempTasks[widget.project.pTasks.indexOf(doc.data()['tId'])] = Task(
                tId: doc.data()['tId'],
                pId: doc.data()['pId'],
                tDesc: doc.data()['tDesc'],
                tTitle: doc.data()['tTitle'],
                assignedTo: doc.data()['assignedTo'],
                isCompleted: doc.data()['isCompleted']);
          }
        });
      });

      setState(() {
        leadSelected = widget.lnames;
        teamSelected = widget.tnames;
        leaduid = widget.project.pLeads;
        teamuid = widget.project.pTeam;
        tasks = tempTasks;
        _titleController.text = widget.project.pTitle;
        _descController.text = widget.project.pDesc;
        dSelected = widget.project.pDeadline;
      });
      teamuid.removeRange(0, leaduid.length);
      buildTaskWidgets();
    }
  }

  buildTaskWidgets() {
    taskWidgets.clear();
    if (tasks.length > 0) {
      for (Task task in tasks) {
        setState(() {
          taskWidgets.add(Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: GestureDetector(
                  onTap: () async {
                    final ta = await Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) => NewTask(
                                leaduid: leaduid,
                                teamuid: teamuid,
                                currentTask: task,
                                tasks: tasks)));

                    buildTaskWidgets();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: task.isCompleted
                            ? Colors.greenAccent
                            : Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(
                        task.tTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -4,
                top: -4,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tasks.remove(task);
                        removedTasks.add(task);
                      });
                      buildTaskWidgets();
                    },
                    child: Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Text(
                          '-',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ))),
                  ),
                ),
              )
            ],
          ));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    u();
  }

  onBackPressed() {
    widget.project != null
        ? {
            widget.project.pTeam = [...leaduid, ...teamuid].toSet().toList(),
            Navigator.of(context).pop()
          }
        : Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // buildTaskWidgets();
    return WillPopScope(
      onWillPop: () {
        onBackPressed();
        // return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: Scaffold(
          floatingActionButton: GestureDetector(
            onTap: () {
              if (_titleController.text == '' ||
                  _descController.text == '' ||
                  dSelected == 'dd | mm | yy' ||
                  leaduid.length == 0) {
                Flushbar(
                  borderWidth: 2,
                  duration: Duration(seconds: 2),
                  borderColor: Colors.orangeAccent,
                  dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                  forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                  titleText: Text(
                    'Error',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.w900),
                  ),
                  borderRadius: 20,
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.orangeAccent,
                  ),
                  padding: EdgeInsets.all(10),
                  backgroundColor: Colors.black,
                  messageText: Text(
                    'All the * marked fields are required',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.w600),
                  ),
                  margin: EdgeInsets.all(10),
                  animationDuration: Duration(seconds: 1),
                )..show(context);
              } else {
                if (widget.project == null) {
                  String projectId = Uuid().v1();
                  List taskIds = [];
                  tasks.forEach((element) {
                    taskIds.add(element.tId);
                    element.pId = projectId;
                  });
                  Project project = new Project(
                      pId: projectId,
                      pDeadline: dSelected,
                      pDesc: _descController.text,
                      pTitle: _titleController.text,
                      pLeads: leaduid,
                      pTeam: [...leaduid, ...teamuid],
                      pTasks: taskIds);

                  tasks.forEach((element) {
                    FirestoreService().addTask(element);
                  });
                  FirestoreService().setEntry(project);
                  Navigator.of(context).pop(true);
                } else {
                  List taskIds = [];
                  tasks.forEach((element) {
                    taskIds.add(element.tId);
                    element.pId = widget.project.pId;
                  });
                  widget.project.pTitle = _titleController.text;
                  widget.project.pDesc = _descController.text;
                  widget.project.pDeadline = dSelected;
                  widget.project.pLeads = leaduid;
                  widget.project.pTeam = [
                    ...leaduid.toSet().toList(),
                    ...teamuid.toSet().toList()
                  ];
                  widget.project.pTasks = taskIds;
                  tasks.forEach((element) {
                    FirestoreService().addTask(element);
                  });
                  removedTasks.forEach((element) {
                    FirestoreService().removeTask(element.tId);
                  });
                  FirestoreService().setEntry(widget.project);
                  Navigator.of(context).pop(widget.project);
                }
              }

              //apna
            },
            child: Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              )),
            ),
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xffb121212),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              },
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 0, right: 0, top: 0),
                          child: Stack(children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                  
                                ),
                                image: DecorationImage(
                                    image: AssetImage(widget.project == null
                                        ? "assets/b1.jpg"
                                        : "assets/hand.jpg"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.85),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            ),
                            Container(
                              height: 150,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.keyboard_arrow_left),
                                        color: Colors.white,
                                        iconSize: 30,
                                        onPressed: () {
                                          widget.project != null
                                              ? {
                                                  widget.project.pTeam = [
                                                    ...leaduid,
                                                    ...teamuid
                                                  ].toSet().toList(),
                                                  Navigator.of(context).pop()
                                                }
                                              : Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      widget.project == null
                                          ? "Add A New Project"
                                          : "Edit Project",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12, right: 8, top: 8),
                          child: Row(
                            children: [
                              Text(
                                "Project Title",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 8),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xff313131),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 8,
                                ),
                                child: TextFormField(
                                  
                                  controller: _titleController,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  decoration: InputDecoration.collapsed(
                                    hintText: "",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 8, top: 12),
                          child: Row(
                            children: [
                              Text(
                                "Project Description",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff313131),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 8, top: 13, bottom: 13),
                                child: TextFormField(
                                    controller: _descController,
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    maxLines: 5,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "")),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 8, top: 12),
                          child: Row(
                            children: [
                              Text(
                                "Project Deadline",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 8),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Color(0xff313131),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Text(
                                    dSelected == 'dd | mm | yy'
                                        ? '${dSelected}'
                                        : '${dSelected.substring(8, 10)} | ${dSelected.substring(5, 7)} | ${dSelected.substring(0, 4)}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    WidgetsBinding
                                        .instance.focusManager.primaryFocus
                                        ?.unfocus();

                                    _selectDate(context).then((value) {
                                      if (value != null) {
                                        // entryProvider.changeDate = value;

                                        setState(() {
                                          dSelected = value.toIso8601String();
                                        });
                                      }
                                    });
                                  },
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 12, right: 12),
                          child: Text(
                            'NOTE : Tasks can only be assigned to employees selected as either Project Lead or Project Members',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 8, top: 12),
                          child: Row(
                            children: [
                              Text(
                                "Project Lead",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                              child: GestureDetector(
                                onTap: () async {
                                  WidgetsBinding
                                      .instance.focusManager.primaryFocus
                                      ?.unfocus();
                                  final l = await Navigator.of(context).push(
                                      CupertinoPageRoute(
                                          builder: (context) => CDialog(
                                              type: 'lead',
                                              leadSelected: leadSelected,
                                              teamSelected: teamSelected,
                                              leaduid: leaduid,
                                              teamuid: teamuid)));
                                  setState(() {
                                    leadSelected = l[0];
                                    leaduid = l[1];
                                    teamuid = l[2];
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  // width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            leadSelected.length > 0
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: Container(
                                      height: 50,
                                      width: 280,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: leadSelected.length,
                                          itemBuilder:
                                              (BuildContext ctxt, int ind) {
                                            return Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        color: Colors.white),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12,
                                                          vertical: 8),
                                                      child: Text(
                                                        leadSelected[ind],
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: -4,
                                                  top: -4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (tasks.length > 0) {
                                                          for (Task task
                                                              in tasks) {
                                                            if (task.assignedTo
                                                                .contains(
                                                                    leaduid[
                                                                        ind])) {
                                                              task.assignedTo
                                                                  .remove(
                                                                      leaduid[
                                                                          ind]);
                                                            }
                                                          }
                                                          buildTaskWidgets();
                                                        }
                                                        setState(() {
                                                          leadSelected
                                                              .removeAt(ind);
                                                          leaduid.removeAt(ind);
                                                          // teamuid.removeAt(ind);
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 22,
                                                          width: 22,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .redAccent,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            '-',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                          ))),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 8, top: 12),
                          child: Row(
                            children: [
                              Text(
                                "Project Team",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                              child: GestureDetector(
                                onTap: () async {
                                  WidgetsBinding
                                      .instance.focusManager.primaryFocus
                                      ?.unfocus();
                                  final l = await Navigator.of(context).push(
                                      CupertinoPageRoute(
                                          builder: (context) => CDialog(
                                              type: 'team',
                                              leadSelected: leadSelected,
                                              teamSelected: teamSelected,
                                              leaduid: leaduid,
                                              teamuid: teamuid)));
                                  setState(() {
                                    teamSelected = l[0];
                                    leaduid = l[1];
                                    teamuid = l[2];
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  // width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            teamSelected.length > 0
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: Container(
                                      height: 50,
                                      width: 280,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: teamSelected.length,
                                          itemBuilder:
                                              (BuildContext ctxt, int ind) {
                                            return Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        color: Colors.white),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12,
                                                          vertical: 8),
                                                      child: Text(
                                                        teamSelected[ind],
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: -4,
                                                  top: -4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        //   //edit
                                                        if (tasks.length > 0) {
                                                          for (Task task
                                                              in tasks) {
                                                            if (task.assignedTo
                                                                .contains(
                                                                    teamuid[
                                                                        ind])) {
                                                              task.assignedTo
                                                                  .remove(
                                                                      teamuid[
                                                                          ind]);
                                                            }
                                                          }
                                                          buildTaskWidgets();
                                                        }

                                                        // //***edit */

                                                        setState(() {
                                                          teamSelected
                                                              .removeAt(ind);
                                                          teamuid.removeAt(ind);
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 22,
                                                          width: 22,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .redAccent,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            '-',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                          ))),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 8, top: 12),
                          child: Row(
                            children: [
                              Text(
                                "Project Tasks",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                              child: GestureDetector(
                                onTap: () async {
                                  WidgetsBinding
                                      .instance.focusManager.primaryFocus
                                      ?.unfocus();
                                  final ta = await Navigator.of(context)
                                      .push(CupertinoPageRoute(
                                          builder: (context) => NewTask(
                                                tasks: tasks,
                                                leaduid: leaduid,
                                                teamuid: teamuid,
                                              )));

                                  setState(() {
                                    tasks = ta;
                                  });
                                  buildTaskWidgets();
                                },
                                child: Container(
                                  height: 50,
                                  // width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                width: 280,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Wrap(
                                      spacing: 0, // gap between adjacent chips
                                      runSpacing: 4.0, // gap between lines
                                      children: taskWidgets),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 75,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void showmera() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return CDialog();
  //     },
  //   );
  // }
}

_selectDate(BuildContext context) async {
  final DateTime picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // Refer step 1
    firstDate: DateTime.now(),
    lastDate: DateTime(2025),
  );
  return picked;
}

class CDialog extends StatefulWidget {
  String type = '';
  List leadSelected = [];
  List teamSelected = [];
  List leaduid = [];
  List teamuid = [];

  CDialog(
      {this.type,
      this.leadSelected,
      this.teamSelected,
      this.leaduid,
      this.teamuid});
  @override
  _CDialogState createState() => _CDialogState();
}

class _CDialogState extends State<CDialog> {
 
  List mylist = [];
  List searchList = [];
  List selected = [];
  List<List> data = [];
  double h;
  String query = '';
  TextEditingController search = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    widget.type == 'lead'
        ? selected = widget.leadSelected
        : selected = widget.teamSelected;
    data.add(selected);

    data.add(widget.leaduid);
    data.add(widget.teamuid);

    // calculating height
    if (selected.length == 0 && MediaQuery.of(context).viewInsets.bottom == 0) {
      h = MediaQuery.of(context).size.height - 85;
    } else if (selected.length == 0 &&
        MediaQuery.of(context).viewInsets.bottom > 0) {
      h = MediaQuery.of(context).size.height -
          90 -
          MediaQuery.of(context).viewInsets.bottom;
    } else if (selected.length > 0 &&
        MediaQuery.of(context).viewInsets.bottom == 0) {
      h = MediaQuery.of(context).size.height - 130;
    } else if (selected.length > 0 &&
        MediaQuery.of(context).viewInsets.bottom > 0) {
      h = MediaQuery.of(context).size.height -
          130 -
          MediaQuery.of(context).viewInsets.bottom;
    }
    onBackPressed() {
      Navigator.of(context).pop(data);
    }

    // modifying list as per search
    // mylist = search.text == ''
    //     ? country
    //     : country
    //         .where((element) => element.toLowerCase().contains(query))
    //         .toList();
    return WillPopScope(
      onWillPop: () {
        onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(data);
          },
          child: Container(
            height: 40,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(
              'Done',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            )),
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xffb121212),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Color(0xff313131),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 8,
                          ),
                          child: TextFormField(
                              controller: search,
                              cursorColor: Colors.white,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              onChanged: (value) {
                                setState(() {
                                  query = value;
                                });
                              },
                              maxLines: 1,
                              decoration: InputDecoration.collapsed(
                                  hintStyle: TextStyle(
                                      color: Colors.grey[600], fontSize: 18),
                                  hintText: "Search by name or email Id")),
                        ),
                      ),
                    ),
                  ),
                  selected.length > 0
                      ? Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selected.length,
                                itemBuilder: (BuildContext ctxt, int ind) {
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              selected[ind],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: -4,
                                        top: -4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selected.removeAt(ind);
                                                widget.type == 'lead'
                                                    ? widget.leaduid
                                                        .removeAt(ind)
                                                    : widget.teamuid
                                                        .removeAt(ind);
                                              });
                                            },
                                            child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ))),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ))
                      : Container(),
                  Container(
                    height: h,
                    decoration: BoxDecoration(
                        // color: Colors.transparent,
                        ),
                    child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: StreamBuilder<List<Employee>>(
                            stream: FirestoreService().getEmployees(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }

                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return selected.contains(
                                                snapshot.data[index].eName) ||
                                            widget.leadSelected.contains(
                                                snapshot.data[index].eName) ||
                                            widget.teamSelected.contains(
                                                snapshot.data[index].eName)
                                        ? Container()
                                        : Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selected.add(snapshot
                                                      .data[index].eName);
                                                  if (widget.type == 'lead') {
                                                    widget.leaduid.add(snapshot
                                                        .data[index].uid);
                                                    // widget.teamuid.add(snapshot
                                                    //     .data[index].uid);
                                                  } else {
                                                    widget.teamuid.add(snapshot
                                                        .data[index].uid);
                                                  }
                                                });
                                              },
                                              highlightColor:
                                                  Colors.white.withOpacity(0.3),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        snapshot
                                                            .data[index].eName,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 22),
                                                      ),
                                                      Text(
                                                        snapshot
                                                            .data[index].eEmail,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                  });
                            })),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// showDialog(
//                   barrierColor: Colors.black.withOpacity(0.9),
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       backgroundColor: Color(0xff313131),
//                       title: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Icon(
//                             Icons.check_circle,
//                             size: 50,
//                             color: Colors.greenAccent,
//                           )),
//                       content: Text(
//                         'Project Added!',
//                         style: TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.w900,
//                             color: Colors.white),
//                       ),
//                       actions: [
//                         FlatButton(
//                           onPressed: () {
//                            Navigator.of(context).popUntil(ModalRoute.withName('/home'));
//                           },
//                           child: Text('Close'),
//                         )
//                       ],
//                     );
//                   });
//             });
