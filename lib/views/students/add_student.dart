import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/student.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  Student student = new Student();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final phoneFocus = FocusNode();

  File _image;
  String base64Image = '';
  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxHeight: 1000,
        maxWidth: 1000
    );
    setState(() {
      _image = image;
      print(_image);
      base64Image = base64Encode(_image.readAsBytesSync());
    });
  }

  var errors;
  addStudent(){
    setState(() {
      var info = {
        'name' : _nameController.text.trim(),
        'email' : _emailController.text.trim(),
        'phone' : _phoneController.text.trim(),
        'password' : _passwordController.text,
        'image' : base64Image
      };
      if(_nameController.text.trim().toLowerCase().isNotEmpty &&
          _emailController.text.isNotEmpty){
        student.addStudent(info, 'student/add').then((res) =>{
          if(res['status'] == true){
            Navigator.pop(context),
            Fluttertoast.showToast(
                msg: "تم إضافة الطالب بنجاح",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            )
          }else if(res['status'] == false){
            errors = res['error'].values.toList(),
            _showDialog(errors[0][0].toString()),
          }
          else{
          _showDialog(res.toString()),
          }
        });
      }else{
        _showDialog('تحقق من البيانات المدخله');
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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "إضافة طالب جديد",
            style: GoogleFonts.tajawal(
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
                Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[200],
                                  offset: Offset(0.0, 15.0),
                                  blurRadius: 9.0),
                              BoxShadow(
                                  color: Colors.grey[200],
                                  offset: Offset(0.0, -5.0),
                                  blurRadius: 10.0),
                            ]),
                        child: CircleAvatar(
                            backgroundImage: _image == null ? AssetImage('assets/user.png') : FileImage(_image),
                            radius: 60.0
                        ),
                      ),
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 60,
                        child: IconButton(
                          icon: Icon(Icons.add_photo_alternate),
                          onPressed: getImage,
                          color: Colors.white70,
                          iconSize: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15,),
                Text(
                  "ادخل بيانات الطالب",
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
                    FocusScope.of(context).requestFocus(emailFocus);
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
                    labelText: "إسم الطالب",
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
                  controller: _emailController,
                  focusNode: emailFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).requestFocus(passwordFocus);
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
                    labelText: "البريد الإلكتروني للطالب",
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
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  focusNode: passwordFocus,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).requestFocus(phoneFocus);
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
                    labelText: "كلمة مرور الطالب",
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
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  focusNode: phoneFocus,
                  decoration: InputDecoration(
                    labelText: "رقم جوال الطالب",
                    fillColor: Colors.white,
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
                    width: 150,
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
                        onTap: addStudent,
                        child: Center(
                          child: Text("إضافة الطالب",
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

