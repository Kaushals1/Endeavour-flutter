import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/proj.dart';
import 'package:project_manager/proj2.dart';
import 'package:project_manager/screens/list.dart';
import 'package:project_manager/screens/newProject.dart';
import 'package:project_manager/services/firestore_service.dart';
import 'package:project_manager/task.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:project_manager/services/authentication_service.dart';
import 'package:provider/provider.dart';

import 'models/task.dart';

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  void changeState(item) async {
    String dl;
    String pname;
    bool toggle = item.isCompleted;
    DocumentSnapshot variable2 = await FirebaseFirestore.instance
        .collection('Projects')
        .get()
        .then((snap) {
      snap.docs.forEach((DocumentSnapshot doc) {
        if (doc.data()['pId'] == item.pId) {
          dl = doc.data()['pDeadline'];
          pname = doc.data()['pTitle'];
        }
      });
    });

    showModalBottomSheet(
        backgroundColor: Color(0xff313131),
        barrierColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (builder) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: new SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: StickyHeader(
                    overlapHeaders: false,
                    content: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.tTitle,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${dl.substring(8, 10)} | ${dl.substring(5, 7)} | ${dl.substring(0, 4)}',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${pname} (Project Title)',
                            style: TextStyle(
                                color: Color(0xffb9e9e9e),
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            item.tDesc,
                            style: TextStyle(
                                color: Color(0xffb9e9e9e),
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Assigned to : ",
                                style: TextStyle(
                                  color: Color(0xffb9e9e9e),
                                  fontSize: 18,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white),
                                    image: DecorationImage(
                                        image: AssetImage("assets/p1.jpg"),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white),
                                    image: DecorationImage(
                                        image: AssetImage("assets/p2.jpg"),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white),
                                    image: DecorationImage(
                                        image: AssetImage("assets/p3.jpg"),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    header: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                toggle = !toggle;
                              });
                              item.isCompleted = !item.isCompleted;
                              FirestoreService().addTask(item);
                            },
                            child: Container(
                              // width: 300,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color:
                                    toggle ? Colors.greenAccent : Colors.black,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    !item.isCompleted
                                        ? 'Status : In Progress..'
                                        : 'Status : Completed!',
                                    style: TextStyle(
                                        color: !item.isCompleted
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  // Container(
                                  //   height: 30,
                                  //   width: 1,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(20),
                                  //       color: Colors.grey),
                                  // ),
                                  // IconButton(
                                  //   icon: toggle
                                  //       ? Icon(Icons.work)
                                  //       : Icon(Icons.check),
                                  //   color: item.isCompleted
                                  //       ? Colors.black
                                  //       : Colors.greenAccent,
                                  //   iconSize: 25,
                                  //   onPressed: () {
                                  //     print("menu");
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          );
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb121212),
      body: SafeArea(
        child: Stack(children: [
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage("assets/mainbg.jpg"), fit: BoxFit.cover),
          //   ),
          // ),
          // Container(
          //   decoration: BoxDecoration(
          //    color: Colors.black.withOpacity(0.8)
          //   ),
          // ),
          SingleChildScrollView(
            child: Stack(children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () {
                            context.read<AuthenticationService>().signOut();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white),
                              image: DecorationImage(
                                  image: AssetImage("assets/p4.jpg"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "My Projects",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.search),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                // print("menu");
                              },
                            ),
                            // SizedBox(
                            //   width: 30,
                            // ),
                            IconButton(
                              icon: Icon(Icons.add),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () async {
                                bool show = await Navigator.of(context).push(
                                    CupertinoPageRoute(
                                        builder: (context) => NewProject()));
                                if (show) {
                                  Flushbar(
                                    duration: Duration(seconds: 2),
                                    reverseAnimationCurve:
                                        Curves.fastLinearToSlowEaseIn,
                                    borderWidth: 2,
                                    borderColor: Colors.green,
                                    dismissDirection:
                                        FlushbarDismissDirection.HORIZONTAL,
                                    forwardAnimationCurve:
                                        Curves.fastLinearToSlowEaseIn,
                                    titleText: Text(
                                      'Success',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    borderRadius: 20,
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Colors.black,
                                    messageText: Text(
                                      'Project added successfully!',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    margin: EdgeInsets.all(10),
                                    animationDuration: Duration(seconds: 1),
                                  )..show(context);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                // print("menu");
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => Listt()));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Proj2(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "My Tasks",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => Listt()));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  TaskCard(this.changeState),
                  
                ],
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
