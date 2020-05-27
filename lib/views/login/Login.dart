import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:teacherAssistant/providers/auth.dart';
import 'package:teacherAssistant/views/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Auth auth = new Auth();
  String msgStatus = '';
  bool loading = false;
  final focus = FocusNode();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showDialog() {
    setState(() {
      loading = false;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('خطأ'),
            content: Text('تحقق من البريد الإلكتروني وكلمة المرور'),
            actions: <Widget>[
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  'غلق',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _login() async {
    setState(() {
      loading = true;
      var info = {
        'email': _emailController.text.trim().toLowerCase(),
        'password': _passwordController.text
      };
      if (_emailController.text.trim().toLowerCase().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty) {
        auth.loginData(info).whenComplete(() {
          if (auth.status) {
            _showDialog();
            msgStatus = 'تحقق من البريد الإلكتروني وكلمة المرور';
          } else {
            loading = false;
            Navigator.pushReplacementNamed(context, '/home');
            Fluttertoast.showToast(
            msg: "تم تسجيل الدخول بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
          }
        });
      } else {
        loading = false;
        _showDialog();
        msgStatus = 'تحقق من البريد الإلكتروني وكلمة المرور';
      }
    });
  }

  bool _isSelected = false;
  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

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
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Image.asset("assets/teacher_login.png"),
              ),
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
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(250),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(500),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0.0, 10.0),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0.0, 1.0),
                              blurRadius: 7.0),
                        ]),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("تسجيل الدخول",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(45),
                                  letterSpacing: .6)
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("البريد الإلكتروني",
                              style: TextStyle(
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            textInputAction: TextInputAction.next,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus);
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                hintText: "البريد الإلكتروني",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("كلمة المرور",
                              style: TextStyle(
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            focusNode: focus,
                            controller: _passwordController,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.vpn_key),
                                suffixIcon: IconButton(
                                  onPressed: _toggle,
                                  icon: _obscureText ? Icon(Icons.visibility,color: Colors.green) : Icon(Icons.visibility_off,color: Colors.grey,),
                                ),
                                hintText: "كلمة المرور",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15.0)),
                          ),

                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
//                              Text(
//                                "Forgot Password?",
//                                style: TextStyle(
//                                    color: Colors.green,
//                                    fontFamily: "Poppins-Medium",
//                                    fontSize:
//                                        ScreenUtil.getInstance().setSp(28)),
//                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("تذكرني",
                              style: TextStyle(
                                  fontSize: 12))
                        ],
                      ),
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
                              onTap: _login,
                              child: Center(
                                child: loading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[300])) : Text("تسجيل الدخول",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "مستخدم جديد؟ ",
                        style: TextStyle(fontSize: 15),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => RegisterPage(),
                          ));
                        },
                        child: Text("تسجيل عضوية",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,)),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
