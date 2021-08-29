import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/task.dart';

class ProjectCard extends StatelessWidget {
  @override
  List<String> litems = [
    "Project 1",
    "Project 2",
    "Project 3",
    "Project 4",
    "Project 5",
    "Project 6",
    "Project 7",
  ];


  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: litems.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 14),
              child: GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => NewProject()));
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
                          litems[index],
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
                          "Mern stack built website.",
                          style: TextStyle(
                            color: Color(0xffb9e9e9e),
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Deadline : 30 | 10 | 2020",
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
          },
        ),
      ),
    );
  }
}
