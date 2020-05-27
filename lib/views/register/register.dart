import 'dart:convert';
import 'dart:io';
import 'package:teacherAssistant/providers/auth.dart';
import 'package:teacherAssistant/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  File _image;
  String base64Image = '';
  bool loading = false;
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final rePasswordFocus = FocusNode();
  final phoneFocus = FocusNode();

  bool _obscureText1 = true;
  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  bool _obscureText2 = true;
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

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

  Auth auth = new Auth();
  var msgStatus;
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  _register(){
    setState(() {
      loading = true;
      var info = {
        'name' : _nameController.text.trim(),
        'email' : _emailController.text.trim().toLowerCase(),
        'password' : _passwordController.text,
        'c_password' : _confirmPasswordController.text,
        'phone' : _phoneController.text,
        'image' : base64Image
      };
      if(_emailController.text.trim().toLowerCase().isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty){
        auth.registerData(info).then((res) =>{
          setState(() {
            loading = false;
          }),
          if(res == true){
              Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              ModalRoute.withName('/home'),
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
  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Expanded(child: Image.asset("assets/image_02.png"))
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(Icons.arrow_back_ios),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      ),
                      Text("تسجيل عضوية",
                          style: TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(45),
                              fontWeight: FontWeight.bold,
                              letterSpacing: .6)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(50),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(1200),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[200],
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.grey[200],
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("الإسم بالكامل",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (v){
                              FocusScope.of(context).requestFocus(emailFocus);
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_circle),
                                hintText: "الإسم بالكامل",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("البريد الإلكتروني",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            controller: _emailController,
                            focusNode: emailFocus,
                            onSubmitted: (v){
                              FocusScope.of(context).requestFocus(passwordFocus);
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                hintText: "البريد الإلكتروني",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("كلمة المرور",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            obscureText: _obscureText1,
                            controller: _passwordController,
                            focusNode: passwordFocus,
                            onSubmitted: (v){
                              FocusScope.of(context).requestFocus(rePasswordFocus);
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.vpn_key),
                                suffixIcon: IconButton(
                                  onPressed: _toggle1,
                                  icon: _obscureText1 ? Icon(Icons.visibility,color: Colors.grey) : Icon(Icons.visibility_off,color: Colors.blue,),
                                ),
                                hintText: "كلمة المرور",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("إعادة كلمة المرور",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            controller: _confirmPasswordController,
                            focusNode: rePasswordFocus,
                            onSubmitted: (v){
                              FocusScope.of(context).requestFocus(phoneFocus);
                            },
                            textInputAction: TextInputAction.next,
                            obscureText: _obscureText2,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.vpn_key),
                                suffixIcon: IconButton(
                                  onPressed: _toggle2,
                                  icon: _obscureText2 ? Icon(Icons.visibility,color: Colors.grey) : Icon(Icons.visibility_off,color: Colors.blue,),
                                ),
                                hintText: "إعادة كلمة المرور",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("رقم الجوال",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            controller: _phoneController,
                            focusNode: phoneFocus,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                hintText: "رقم الجوال",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(330),
                          height: ScreenUtil.getInstance().setHeight(100),
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
                              onTap: _register,
                              child: Center(
                                child: Text("تسجيل",
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
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(String msg){
    setState(() {
      loading = false;
    });
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
}
