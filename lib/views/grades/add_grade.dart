import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/grades.dart';

class AddGradePage extends StatefulWidget {
  @override
  _AddGradePageState createState() => _AddGradePageState();
}

class _AddGradePageState extends State<AddGradePage> {
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _maxGradeController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();

  final maxGradeFocus = FocusNode();
  final descriptionFocus = FocusNode();

  Grades grades = new Grades();
  var classId;

  addGrade(){
    setState(() {
      var info = {
        'title' : _titleController.text.trim(),
        'max_grade' : _maxGradeController.text.trim(),
        'description' : _descriptionController.text,
        'class_id' : classId.toString()
      };
      if(_titleController.text.trim().toLowerCase().isNotEmpty &&
          _maxGradeController.text.isNotEmpty){
        grades.addGrade(info, 'grades/add').then((res) =>{
          if(res['status'] == true){
            Navigator.pop(context),
            Fluttertoast.showToast(
                msg: "تم إضافة الدرجة بنجاح",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            )
          }else{
            _showDialog(res.toString()),
          }
        });
      }else{
        _showDialog('تحقق من البيانات المدخلة');
      }
    });
  }

  void _showDialog(String msg){
    showDialog(
        context:context ,
        builder:(BuildContext context){
          return AlertDialog(
            title: new Text('خطأ'),
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
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) classId = arguments['classId'];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "إضافة درجة جديدة",style: GoogleFonts.tajawal(letterSpacing: 1.0,
              fontWeight: FontWeight.w700,
              fontSize: 18)
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
                  "assets/test.png",
                  height: 130,
                ),
                SizedBox(height: 15,),
                Text(
                  "أدخل البيانات",
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
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).requestFocus(maxGradeFocus);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF7fcd91),
                      ),
                    ),
                    labelText: "العنوان*",
                    labelStyle: TextStyle(
                        color: Colors.black45
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
                TextFormField(
                  controller: _maxGradeController,
                  focusNode: maxGradeFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).requestFocus(descriptionFocus);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF7fcd91),
                      ),
                    ),
                    labelStyle: TextStyle(
                        color: Colors.black45
                    ),
                    labelText: "أقصي درجة*",
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
                TextFormField(
                  controller: _descriptionController,
                  focusNode: descriptionFocus,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF7fcd91),
                      ),
                    ),
                    labelText: "الوصف",
                    labelStyle: TextStyle(
                        color: Colors.black45
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
                SizedBox(height: 40,),
                InkWell(
                  child: Container(
                    width: 140,
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
                        onTap: addGrade,
                        child: Center(
                          child: Text("إضافة",
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
