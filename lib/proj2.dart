import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/ProjDetail.dart';
import 'package:project_manager/services/firestore_service.dart';

class Proj2 extends StatefulWidget {
  @override
  _Proj2State createState() => _Proj2State();
}

class _Proj2State extends State<Proj2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: StreamBuilder<List<Project>>(
          stream: FirestoreService().getProjects2(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  // Project ptemp=snapshot.data[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: GestureDetector(
                      onTap: () async {
                        Project p2 =
                            await Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => ProjectDetail(
                                      project: snapshot.data[index],
                                    )));

                        setState(() {
                          snapshot.data[index] = p2;
                        });
                      },
                      child: new Container(
                        // height: 100,
                        width: 350,
                        decoration: BoxDecoration(
                            //  border: Border.all(
                            //   color: Colors.grey[200],
                            //   width: 5,
                            // ),
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff313131)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data[index].pTitle,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data[index].pDesc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xffb9e9e9e),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${snapshot.data[index].pDeadline.substring(8, 10)} | ${snapshot.data[index].pDeadline.substring(5, 7)} | ${snapshot.data[index].pDeadline.substring(0, 4)}',
                                style: TextStyle(
                                  color: Color(0xffb9e9e9e),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                height: 45,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Team Members : ",
                                    style: TextStyle(
                                      color: Color(0xffb9e9e9e),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
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
                      ),
                    ),
                  );
                });
          }),
    );

    // return Scaffold(
    //   body: StreamBuilder<List<Project>>(
    //     stream: FirestoreService().getProjects(),
    //     builder: (context, snapshot) {
    //       // if (!snapshot.hasData) return Text("loading...");
    //       return Container(
    //         height: 220,
    //         child: ListView.builder(
    //           scrollDirection: Axis.horizontal,
    //           itemCount: snapshot.data.length,
    //           itemBuilder: (BuildContext ctxt, int index) {
    //             return Padding(
    //               padding: const EdgeInsets.only(left: 14),
    //               child: GestureDetector(
    //                 onTap: () {
    //                   // Navigator.of(context).push(
    //                   //     MaterialPageRoute(builder: (context) => NewProject()));
    //                 },
    //                 child: new Container(
    //                   // height: 100,
    //                   width: 350,
    //                   decoration: BoxDecoration(
    //                       //  border: Border.all(
    //                       //   color: Colors.grey[200],
    //                       //   width: 5,
    //                       // ),
    //                       borderRadius: BorderRadius.circular(20),
    //                       color: Color(0xff313131)),
    //                   child: Padding(
    //                     padding: const EdgeInsets.symmetric(
    //                         horizontal: 15, vertical: 10),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           'title',
    //                           maxLines: 1,
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 20,
    //                             fontWeight: FontWeight.w900,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 5,
    //                         ),
    //                         Text(
    //                           "Mern stack built website.",
    //                           style: TextStyle(
    //                             color: Color(0xffb9e9e9e),
    //                             fontSize: 19,
    //                             fontWeight: FontWeight.w900,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 5,
    //                         ),
    //                         Text(
    //                           "Deadline : 30 | 10 | 2020",
    //                           style: TextStyle(
    //                             color: Color(0xffb9e9e9e),
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.w900,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 45,
    //                         ),
    //                         Row(
    //                           children: [
    //                             Text(
    //                               "Team Members : ",
    //                               style: TextStyle(
    //                                 color: Color(0xffb9e9e9e),
    //                                 fontSize: 16,
    //                                 fontWeight: FontWeight.w500,
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.all(4.0),
    //                               child: Container(
    //                                 height: 40,
    //                                 width: 40,
    //                                 decoration: BoxDecoration(
    //                                   color: Colors.white,
    //                                   shape: BoxShape.circle,
    //                                   border: Border.all(color: Colors.white),
    //                                   image: DecorationImage(
    //                                       image: AssetImage("assets/p1.jpg"),
    //                                       fit: BoxFit.cover),
    //                                 ),
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.all(4.0),
    //                               child: Container(
    //                                 height: 40,
    //                                 width: 40,
    //                                 decoration: BoxDecoration(
    //                                   color: Colors.white,
    //                                   shape: BoxShape.circle,
    //                                   border: Border.all(color: Colors.white),
    //                                   image: DecorationImage(
    //                                       image: AssetImage("assets/p2.jpg"),
    //                                       fit: BoxFit.cover),
    //                                 ),
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.all(4.0),
    //                               child: Container(
    //                                 height: 40,
    //                                 width: 40,
    //                                 decoration: BoxDecoration(
    //                                   color: Colors.white,
    //                                   shape: BoxShape.circle,
    //                                   border: Border.all(color: Colors.white),
    //                                   image: DecorationImage(
    //                                       image: AssetImage("assets/p3.jpg"),
    //                                       fit: BoxFit.cover),
    //                                 ),
    //                               ),
    //                             )
    //                           ],
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
