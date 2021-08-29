// import 'package:project_manager/providers/entry_provider.dart';
// import 'package:project_manager/services/authentication_service.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:project_manager/proj.dart';
// import 'package:project_manager/task.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:sticky_headers/sticky_headers.dart';
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("HOME"),
//             RaisedButton(
//               onPressed: () {
//                 EntryProvider().loadAll(null);
//               },
//               child: Text("Save"),
//             ),
//             RaisedButton(
//               onPressed: () {
//                 EntryProvider().saveEntry();
//               },
//               child: Text("Save2"),
//             ),
//             RaisedButton(
//               onPressed: () {
// context.read<AuthenticationService>().signOut();
//               },
//               child: Text("Sign out"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/proj.dart';
import 'package:project_manager/task.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:project_manager/services/authentication_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pagestate = 0;
  double yOffset = 0;
  double yOffOpacity = 0;
  double windowHeight = 0;
  double windowWidth = 0;
  
  List<String> litems = [
    "1",
    "2",
    "Third",
    "4",
    "1",
    "2",
    "Third",
    "4",
    "1",
    "2",
    "Third",
    "4",
    "1",
    "2",
    "Third",
    "4"
  ];
  void changeState() {
    print("herre");
    setState(() {
      pagestate = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;
    yOffOpacity = windowHeight;
    switch (pagestate) {
      case 0:
        yOffset = windowHeight;
        break;
      case 1:
        yOffset = 300;
        yOffOpacity = 0;
        break;
      default:
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        SafeArea(
          child: SingleChildScrollView(
            
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children:<Widget> [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://i.pravatar.cc/150?img=2'),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Projects",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.search),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                print("menu");
                              },
                            ),
                            // SizedBox(
                            //   width: 30,
                            // ),
                            IconButton(
                              icon: Icon(Icons.add),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                // EntryProvider().saveEntry();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                print("menu");
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  ProjectCard(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Tasks",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                print("menu");
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  TaskCard(this.changeState),
                  // ListView.builder(
                  //     itemCount: litems.length,
                  //     itemBuilder: (BuildContext ctxt, int index) {
                  //       return Text(litems[index],style: TextStyle(color: Colors.white),);
                  //     })
                ],
              ),
            ),
          ),
        
        GestureDetector(
          onTap: () {
            setState(() {
              pagestate = 0;
            });
          },
          child: AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(0, yOffOpacity, 1),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.9)),
          ),
        ),
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 1000),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - yOffset,
          transform: Matrix4.translationValues(0, yOffset, 1),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 40, 40, 40),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: StickyHeader(
                  overlapHeaders: false,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  content: Container(
                    // width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Launch of the newest client's website.",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Deadline : 30 | 10 | 2020",
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500sLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          style: TextStyle(
                              color: Color(0xffb9e9e9e),
                              fontSize: 18,
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
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/150?img=1'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/150?img=1'),
                                // backgroundColor: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/150?img=1'),
                              ),
                            ),
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
                        Container(
                          // width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.redAccent,
                                iconSize: 30,
                                onPressed: () {
                                  print("menu");
                                },
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey),
                              ),
                              IconButton(
                                icon: Icon(Icons.check),
                                color: Colors.greenAccent,
                                iconSize: 30,
                                onPressed: () {
                                  print("menu");
                                },
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.blueAccent,
                                iconSize: 25,
                                onPressed: () {
                                  print("menu");
                                },
                              ),
                            ],
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
        )
      ]),
    );
  }
}
