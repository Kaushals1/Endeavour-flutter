import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/employees.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/screens/newProject.dart';
import 'package:project_manager/services/firestore_service.dart';

import 'package:project_manager/task.dart';
import 'package:uuid/uuid.dart';

class NewTask extends StatefulWidget {
  List tasks = [];
  List leaduid = [];
  List teamuid = [];
  Task currentTask;
  NewTask({this.tasks, this.leaduid, this.teamuid, this.currentTask});
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  List selected = [];
  List assignedTo = [];
  TextEditingController _tasktitleController = new TextEditingController();
  TextEditingController _taskdescController = new TextEditingController();
  onBackPressed() {
    Navigator.of(context).pop(widget.tasks);
  }

  abc() async {
    setState(() {
      _tasktitleController.text = widget.currentTask.tTitle;
      _taskdescController.text = widget.currentTask.tDesc;
    });
    List a =
        new List.generate(widget.currentTask.assignedTo.length, (index) => 'a');
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('Employees')
        .get()
        .then((snap) {
      snap.docs.forEach((DocumentSnapshot doc) {
        if (widget.currentTask.assignedTo.contains(doc.data()['uid'])) {
          a[widget.currentTask.assignedTo.indexOf(doc.data()['uid'])] =
              doc.data()['eName'];
        }
      });
    });
    setState(() {
      selected = a;
      assignedTo = widget.currentTask.assignedTo;
    });
    
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentTask != null) {
      abc();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          onBackPressed();
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: Scaffold(
            floatingActionButton: GestureDetector(
              onTap: () {
                if(_taskdescController.text==''||_tasktitleController.text==''){
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
                }else{
                if (widget.currentTask == null) {
                  Task task = new Task(
                    tId: Uuid().v1(),
                    tTitle: _tasktitleController.text,
                    tDesc: _taskdescController.text,
                    assignedTo: assignedTo,
                    isCompleted: false
                  );
                  widget.tasks.add(task);
                  Navigator.of(context).pop(widget.tasks);
                } else {
                  widget.currentTask.tTitle = _tasktitleController.text;
                  widget.currentTask.tDesc = _taskdescController.text;
                  widget.currentTask.assignedTo = assignedTo;
                  widget.tasks[widget.tasks.indexOf(widget.currentTask)] =
                      widget.currentTask;
                  Navigator.of(context).pop(widget.tasks);
                }}
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
                    // controller: _scrollController,
                    child: Column(children: [
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
                                  image: AssetImage("assets/task.jpeg"),
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
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Text(
                                    "Add A New Task",
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
                              "Task Title",
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
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 8),
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
                                controller: _tasktitleController,
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
                        padding:
                            const EdgeInsets.only(left: 12, right: 8, top: 12),
                        child: Row(
                          children: [
                            Text(
                              "Task Description",
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
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff313131),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 8, top: 13, bottom: 13),
                              child: TextFormField(
                                  controller: _taskdescController,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 5,
                                  decoration:
                                      InputDecoration.collapsed(hintText: "")),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 8, top: 12),
                        child: Row(
                          children: [
                            Text(
                              "Assigned to",
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
                                        builder: (context) => CDialog2(
                                                team: [
                                                  ...widget.leaduid,
                                                  ...widget.teamuid
                                                ],
                                                selected: selected,
                                                assignedTo: assignedTo)));
                                setState(() {
                                  if (l != null) {
                                    selected = l[0];
                                    assignedTo = l[1];
                                  }
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
                                      padding: const EdgeInsets.only(right: 8),
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
                          selected.length > 0
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Container(
                                    height: 50,
                                    width: 280,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: selected.length,
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
                                                          BorderRadius.circular(
                                                              18),
                                                      color: Colors.white),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                    child: Text(
                                                      selected[ind],
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: -4,
                                                top: -4,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selected.removeAt(ind);
                                                        assignedTo
                                                            .removeAt(ind);
                                                        // teamuid.removeAt(ind);
                                                      });
                                                    },
                                                    child: Container(
                                                        height: 22,
                                                        width: 22,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.redAccent,
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
                              : Container(),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class CDialog2 extends StatefulWidget {
  List team = [];
  List selected = [];
  List assignedTo = [];

  CDialog2({this.team, this.selected, this.assignedTo});
  @override
  _CDialog2State createState() => _CDialog2State();
}

class _CDialog2State extends State<CDialog2> {
  double h;
  List<List> data = [];
  @override
  Widget build(BuildContext context) {
    List selected = widget.selected;
    data.add(selected);
    data.add(widget.assignedTo);
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
      // print(widget.team);
      Navigator.of(context).pop(data);
    }

    return WillPopScope(
      onWillPop: () {
        onBackPressed();
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
              child: Column(
                children: [
                  Center(
                    child: Padding(
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
                                // controller: search,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                onChanged: (value) {
                                  setState(() {
                                    // query = value;
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
                                                widget.assignedTo.removeAt(ind);
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
                                            !widget.team.contains(
                                                snapshot.data[index].uid)
                                        ? Container()
                                        : Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selected.add(snapshot
                                                      .data[index].eName);
                                                  widget.assignedTo.add(
                                                      snapshot.data[index].uid);
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
