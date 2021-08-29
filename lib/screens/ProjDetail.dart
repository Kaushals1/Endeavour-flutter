import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/screens/editProject.dart';
import 'package:project_manager/screens/newProject.dart';
import 'package:project_manager/services/firestore_service.dart';
import 'package:project_manager/task.dart';

class ProjectDetail extends StatefulWidget {
  Project project;
  Project temp;
  ProjectDetail({this.project});
  @override
  _ProjectDetailState createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  List lnames = [];
  List tnames = [];
  List tempTasks2 = [];
  List<Widget> l = [];
  List<Widget> t = [];
  List<Widget> tasks = [];

  xyz() {
    widget.temp = widget.project;
  }

  abc() async {
    List a = new List.generate(widget.temp.pLeads.length, (index) => 'a');
    List b = new List.generate(widget.temp.pTeam.length, (index) => 'b');

    lnames.clear();
    tnames.clear();
    l.clear();
    t.clear();
    tasks.clear();
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('Employees')
        .get()
        .then((snap) {
      snap.docs.forEach((DocumentSnapshot doc) {
        if (widget.temp.pLeads.contains(doc.data()['uid'])) {
          a[widget.temp.pLeads.indexOf(doc.data()['uid'])] =
              doc.data()['eName'];
        }

        if (widget.temp.pTeam.contains(doc.data()['uid']) &&
            !widget.temp.pLeads.contains(doc.data()['uid'])) {
          b[widget.temp.pTeam.indexOf(doc.data()['uid'])] = doc.data()['eName'];
        }
      });
    });
    b.removeWhere((element) => element == 'b');
    lnames = a;
    tnames = b;

    for (String name in lnames) {
      setState(() {
        l.add(
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        );
      });
    }

    for (String name in tnames) {
      setState(() {
        t.add(
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        );
      });
    }

    List tempTasks =
        new List.generate(widget.project.pTasks.length, (index) => 'a');

    DocumentSnapshot variable2 =
        await FirebaseFirestore.instance.collection('Tasks').get().then((snap) {
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
    tempTasks2 = tempTasks;

    for (Task task in tempTasks) {
      // print(task.isCompleted);
      setState(() {
        tasks.add(
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              // height: 35,
              width: 280,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: task.isCompleted ? Colors.greenAccent : Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  task.tTitle,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    xyz();
    abc();
  }

  onBackPressed() {
    Navigator.of(context).pop(widget.temp);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onBackPressed();
        // return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () async {
            if (widget.project.pLeads
                .contains(FirebaseAuth.instance.currentUser.uid)) {
              Project p = await Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => NewProject(
                      project: widget.temp, lnames: lnames, tnames: tnames),
                ),
              );
              setState(() {
                p != null
                    ? {
                        widget.temp = p,
                        abc(),
                      }
                    : widget.temp = widget.project;
              });
            } else {
              Flushbar(
                borderWidth: 2,
                duration: Duration(seconds: 2),
                borderColor: Colors.red,
                dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                titleText: Text(
                  'Restricted Access',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.w900),
                ),
                borderRadius: 20,
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                padding: EdgeInsets.all(10),
                backgroundColor: Colors.black,
                messageText: Text(
                  'Only project leads can make changes',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w600),
                ),
                margin: EdgeInsets.all(10),
                animationDuration: Duration(seconds: 1),
              )..show(context);
            }
          },
          child: Container(
            height: 50,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(
              'Edit',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            )),
          ),
        ),
        backgroundColor: Color(0xffb121212),
        body: SafeArea(
            child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  image: AssetImage("assets/details.png"),
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
                                        Navigator.of(context).pop(widget.temp);
                                      },
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Text(
                                    "Project Details",
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
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Project Title',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              widget.temp.pTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffb9e9e9e),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Project Description',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              widget.temp.pDesc,
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffb9e9e9e),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Project Deadline',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${widget.temp.pDeadline.substring(8, 10)} | ${widget.temp.pDeadline.substring(5, 7)} | ${widget.temp.pDeadline.substring(0, 4)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffb9e9e9e),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Project Lead',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Wrap(
                                spacing: 4.0, // gap between adjacent chips
                                runSpacing: 4.0, // gap between lines
                                children: l),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Project Team',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Wrap(
                                spacing: 4.0, // gap between adjacent chips
                                runSpacing: 4.0, // gap between lines
                                children: t),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Project Tasks',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Wrap(
                                spacing: 4.0, // gap between adjacent chips
                                runSpacing: 4.0, // gap between lines
                                children: tasks),
                            SizedBox(
                              height: 70,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }
}
