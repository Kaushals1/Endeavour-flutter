import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/services/firestore_service.dart';
import 'package:project_manager/temp.dart';

import 'models/project.dart';

class TaskCard extends StatefulWidget {
  final Function changeState;
  TaskCard(this.changeState);
  @override
  _TaskCardState createState() => _TaskCardState(changeState);
}

class _TaskCardState extends State<TaskCard> {
  final Function changeState;
  Stream<List<Project>> projects;
  _TaskCardState(this.changeState);
  deadline() {
// String dl;
//     DocumentSnapshot variable2 = await FirebaseFirestore.instance
//         .collection('Projects')
//         .get()
//         .then((snap) {
//       snap.docs.forEach((DocumentSnapshot doc) {
//         if (doc.data()['pId'] == item.pId) {
//           dl = doc.data()['pDeadline'];

//         }
//       });
//     });
  }

  @override
  void initState() {
    super.initState();
    deadline();
  }

  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height - 420,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: StreamBuilder<List<Task>>(
              stream: FirestoreService().getTasks2(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // projects = FirestoreService().getProjects();
                          // print(index);
                          // print(projects);
                          this.changeState(snapshot.data[index]);
                          // Navigator.of(context).push(CupertinoPageRoute(
                          //       builder: (context) => MeraModal(
                          //             item: snapshot.data[index],
                          //           )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 12),
                          child: new Container(
                            // height: 100,
                            // width: 350,

                            decoration: BoxDecoration(
                              
                              borderRadius: BorderRadius.circular(20),
                              color: snapshot.data[index].isCompleted
                                  ? Colors.greenAccent
                                  : Color(0xff313131),
                              
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          snapshot.data[index].tTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                              color: snapshot
                                                      .data[index].isCompleted
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          snapshot.data[index].tDesc,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color:
                                                snapshot.data[index].isCompleted
                                                    ? Colors.black
                                                    : Color(0xffb9e9e9e),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // IconButton(
                                  //   icon: Icon(Icons.delete),
                                  //   color: Colors.red,
                                  //   iconSize: 24,
                                  //   onPressed: () {
                                  //     print("menu");
                                  //   },
                                  // ),
                                  // Container(
                                  //   height: 30,
                                  //   width: 1,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(20),
                                  //       color: Colors.grey),
                                  // ),
                                  SizedBox(
                                    width: 20,
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: IconButton(
                                      icon:snapshot.data[index].isCompleted?Icon(Icons.assignment): Icon(Icons.check),
                                      color:snapshot.data[index].isCompleted?Colors.white: Colors.green,
                                      iconSize: 24,
                                      onPressed: () {
                                        snapshot.data[index].isCompleted =
                                            !snapshot.data[index].isCompleted;
                                        FirestoreService()
                                            .addTask(snapshot.data[index]);
                                      },
                                    ),
                                  ),
                                  // Container(
                                  //   height: 30,
                                  //   width: 1,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(20),
                                  //       color: Colors.grey),
                                  // ),
                                  // IconButton(
                                  //   icon: Icon(Icons.warning),
                                  //   color: Colors.orangeAccent,
                                  //   iconSize: 24,
                                  //   onPressed: () {
                                  //     print("menu");
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

