import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/serve_url.dart';
import 'package:teacherAssistant/views/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:teacherAssistant/providers/auth.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Auth auth = new Auth();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/profile/update');
            },
          ),
        ],
        title: Text(
          'الصفحة الشخصية', style: GoogleFonts.tajawal(letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: Colors.black)
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: auth.getUserData(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot){
          var user = snapshot.data;
          if(snapshot.hasData) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage('${ServerUrl.url}/img/users/' + user[0]['image']),
                    radius: 80,
                  ),
                  SizedBox(height: 25,),
                  Text(
                    user[0]['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text(user[0]['email']),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text(user[0]['phone']),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Container(
                      width: 153,
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
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                              ModalRoute.withName('/login'),
                            );
                          },
                          child: Center(
                            child: Text("تسجيل الخروج",
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
              )
            );
          }
          return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 25,),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.white,
                    child: CircleAvatar(
                      radius: 80,
                    ),
                  ),
                  SizedBox(height: 25,),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.white,
                    child: Text(
                      'تحميل...',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.white, child: null,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text('تحميل...'),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('تحميل...'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        },
      ),
    );
  }
}