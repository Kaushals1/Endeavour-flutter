import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/firestore_service.dart';

class EditProject extends StatefulWidget {
  Project project;
  EditProject({this.project});
  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  TextEditingController title = new TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      title.text = widget.project.pDesc;
    });
  }
   onBackPressed() {
      Navigator.of(context).pop(widget.project);
    }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onBackPressed();
        return Future.value(false);
      },
          child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.project.pDesc = title.text;
            FirestoreService().setEntry(widget.project);
            Navigator.of(context).pop(widget.project);
            // print(widget.project.pTitle);
          },
        ),
        body: SafeArea(
          child: TextFormField(
            controller: title,
          ),
        ),
      ),
    );
  }
}
