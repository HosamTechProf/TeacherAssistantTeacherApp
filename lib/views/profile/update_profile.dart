import 'dart:convert';
import 'dart:io';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  Auth auth = new Auth();

  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();

  File _image;
  String base64Image = '';
  String msgStatus = '';
  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxHeight: 1000,
        maxWidth: 1000
    );
    setState(() {
      if(image != null){
        _image = image;
        base64Image = base64Encode(_image.readAsBytesSync());
      }
    });
  }

  _update(){
    setState(() {
      var info = {
        'name' : _nameController.text.trim(),
        'email' : _emailController.text.trim().toLowerCase(),
        'phone' : _phoneController.text,
        'image' : base64Image
      };
      if(_emailController.text.trim().toLowerCase().isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty){
        auth.updateUserData(info).then((res) =>{
          if(res == true){
            Navigator.pop(context),
            Fluttertoast.showToast(
              msg: "تم التعديل بنجاح",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
            )
          }else{
            _showDialog(res.toString()),
            msgStatus = res
          }
        });
      }else{
        _showDialog('تحقق من البيانات المدخله');
        msgStatus = 'تحقق من البيانات المدخله';
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
        centerTitle: true,
        title: Text(
          'تعديل البيانات الشخصية',
          style: GoogleFonts.tajawal(
              letterSpacing: 1.4,
              fontSize: 19,
              color: Colors.black
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            color: Colors.black,
            onPressed: _update,
          ),
        ],
        backgroundColor: Colors.grey[200],
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 25),
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: auth.getUserData(),
              builder: (context, snapshot) {
                var user = snapshot.data;
                if (snapshot.hasData) {
                  _emailController.text = user[0]['email'];
                  _nameController.text = user[0]['name'];
                  _phoneController.text = user[0]['phone'];
                  return Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: _image == null ? NetworkImage(
                                '${auth.serverUrl}/img/users/' +
                                    user[0]['image']) : FileImage(_image),
                            radius: 80,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 80,
                            child: IconButton(
                              icon: Icon(Icons.insert_photo),
                              onPressed: getImage,
                              color: Colors.white70,
                              iconSize: 40.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(top:30.0, left:30.0, right:30.0, bottom:60.0),
                        child: Column(
                          children: <Widget>[
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
                                labelText: "الإسم",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                            ),
                            SizedBox(height: 30,),
                            TextFormField(
                              controller: _emailController,
                              focusNode: emailFocus,
                              textInputAction: TextInputAction.next,
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
                                labelText: "البريد الإلكتروني",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                            ),
                            SizedBox(height: 30,),
                            TextFormField(
                              controller: _phoneController,
                              focusNode: phoneFocus,
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
                                labelText: "رقم الجوال",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                            ),
                            SizedBox(height: 30,),
                            SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}
