import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teacherAssistant/providers/myClass.dart';
import 'package:teacherAssistant/providers/subject.dart';
import 'package:teacherAssistant/providers/lecture.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddLecturePage extends StatefulWidget {
  @override
  _AddLecturePageState createState() => _AddLecturePageState();
}

class _AddLecturePageState extends State<AddLecturePage> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _dateController = new TextEditingController();
  final TextEditingController _timeController = new TextEditingController();

  final descriptionFocus = FocusNode();


  final dateFormat = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("HH:mm");

  File filePath;
  String base64 = '';
  var fileName = "برجاء اختيار ملف";
  Subject subject = new Subject();
  int mySubject;
  var subjects = [];

  MyClass myClass = new MyClass();
  int selectedClass;

  Lecture lecture = new Lecture();
  addLecture(){
    var info = {
      'name' : _nameController.text.trim(),
      'description' : _descriptionController.text.trim(),
      'date' : _dateController.text.trim(),
      'time' : _timeController.text.trim(),
      'subject_id' : mySubject.toString(),
      'ext' : fileName,
      'file' : base64
    };
    if(_nameController.text.trim().toLowerCase().isNotEmpty &&
        _descriptionController.text.isNotEmpty && mySubject != null
    && _dateController.text.isNotEmpty && _timeController.text.isNotEmpty){
      lecture.addLecture(info, 'lecture/add').then((res) =>{
        if(res['status'] == true){
          Navigator.pop(context),
          Fluttertoast.showToast(
              msg: "تم اضافة المحاضرة بنجاح",
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
            title: new Text('خظأ'),
            content:  new Text(msg),
            actions: <Widget>[
              new RaisedButton(
                color: Colors.blue,
                child: new Text(
                  'غلق',
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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "إضافة محاضرة جديدة",
            style: GoogleFonts.tajawal(letterSpacing: 1.0,
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
                  "إكتب بيانات المحاضرة",
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
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).requestFocus(descriptionFocus);
                  },
                  decoration: InputDecoration(
                    labelText: "عنوان المحاضرة",
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
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _descriptionController,
                  focusNode: descriptionFocus,
                  decoration: InputDecoration(
                    labelText: "الوصف",
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
                ),
                SizedBox(
                  height: 40,
                ),
                DateTimeField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: "تاريخ المحاضرة",
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
                SizedBox(
                  height: 40,
                ),
                DateTimeField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: "وقت المحاضرة",
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
                  format: timeFormat,
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    child: FutureBuilder(
                      future: myClass.getMyClasses(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        List classes = snapshot.data;
                        if(snapshot.data == null){
                          return CircularProgressIndicator();
                        }
                        return DropdownButton(
                          isExpanded: true,
                          value: selectedClass,
                          icon: Icon(AntDesign.downcircleo),
                          iconSize: 20,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (newValue) {
                            setState(() {
                              selectedClass = newValue;
                            });
                            lecture.getSubjectsFromClass(newValue).then((value) => {
                              setState(() {
                                subjects = value;
                                mySubject = null;
                              }),
                              print(subjects)
                            });
                          },
                          hint: Text("إختار فصل"),
                          items: classes.map<DropdownMenuItem>((value) {
                            return DropdownMenuItem(
                              value: value['id'],
                              child: Text(value['name']),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      value: mySubject,
                      icon: Icon(AntDesign.downcircleo),
                      iconSize: 20,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      onChanged: (newValue) {
                        setState(() {
                          mySubject = newValue;
                        });
                      },
                      hint: Text("إختار مادة"),
                      items: subjects.map<DropdownMenuItem>((value) {
                        return DropdownMenuItem(
                          value: value['id'],
                          child: Text(value['name']),
                        );
                      }).toList(),
                    ),
                  ),
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
                              child: Text("رفع ملف",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
                    width: 160,
                    height: 53,
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
                        onTap: addLecture,
                        child: Center(
                          child: Text("إضافة المحاضرة",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1.0)),
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
