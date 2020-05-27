import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:teacherAssistant/providers/assignment.dart';

class AddAssignmentPage extends StatefulWidget {
  @override
  _AddAssignmentPageState createState() => _AddAssignmentPageState();
}

class _AddAssignmentPageState extends State<AddAssignmentPage> {
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _dateController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  var classId;

  final dateFormat = DateFormat("yyyy-MM-dd");

  File filePath;
  String base64 = '';
  var fileName = "Please Select A File";

  Assignment assignment = new Assignment();

  addAssignment(){
    var info = {
      'title' : _titleController.text.trim(),
      'description' : _descriptionController.text.trim(),
      'class_id' : classId.toString(),
      'assignmentDate' : _dateController.text.trim(),
      'ext' : fileName,
      'file' : base64
    };
    if(_titleController.text.trim().toLowerCase().isNotEmpty &&
     _dateController.text.isNotEmpty && _descriptionController.text.trim().toLowerCase().isNotEmpty){
      assignment.addAssignment(info, 'assignment/add').then((res) =>{
        if(res['status'] == true){
          Navigator.pop(context),
          Fluttertoast.showToast(
              msg: "Assignment Added Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          )
        }else{
//          _showDialog(res.toString()),
        }
      });
    }else{
      _showDialog('Check Your Data');
    }
  }

  void _showDialog(String msg){
    showDialog(
        context:context ,
        builder:(BuildContext context){
          return AlertDialog(
            title: new Text('Error'),
            content:  new Text(msg),
            actions: <Widget>[
              new RaisedButton(
                color: Colors.blue,
                child: new Text(
                  'Close',
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) classId = arguments['myClassData'];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Add New Assignment",
            style: TextStyle(
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
          elevation: 0.1,
          backgroundColor: Color(0xFF7fcd91),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/lecture.png",
                  height: 130,
                ),
                SizedBox(height: 15,),
                Text(
                  "Type Assignment Data",
                  style: TextStyle(
                      fontSize: 23,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Assignment Title",
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                        color: Colors.black45
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF7fcd91),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Assignment Description",
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                        color: Colors.black45
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF7fcd91),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                DateTimeField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: "Assignment Date",
                    labelStyle: TextStyle(
                        color: Colors.black45
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF7fcd91),
                      ),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  format: dateFormat,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Container(
                        width: 110,
                        height: 45,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.blue[300],
                              Colors.blueAccent,
                            ]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF6078ea).withOpacity(.3),
                                  offset: Offset(0.0, 8.0),
                                  blurRadius: 8.0)
                            ]),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              filePath = await FilePicker.getFile();
                              setState(() {
                                fileName = path.basename(filePath.path);
                                base64 = base64Encode(filePath.readAsBytesSync());
                              });
                            },
                            child: Center(
                              child: Text("Upload File",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 15,
                                      letterSpacing: 1.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(fileName)
                  ],
                ),
                SizedBox(height: 40,),
                InkWell(
                  child: Container(
                    width: 170,
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xFF7fcd91),
                          Colors.green,
                        ]),
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF6078ea).withOpacity(.3),
                              offset: Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: addAssignment,
                        child: Center(
                          child: Text("Add Assignment",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins-Bold",
                                  fontSize: 16.7,
                                  letterSpacing: 0.6)),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
