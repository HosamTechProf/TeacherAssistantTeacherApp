import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/serve_url.dart';
import 'package:teacherAssistant/views/students/student_attendance.dart';
import 'package:teacherAssistant/views/students/student_grades.dart';

class StudentPage extends StatefulWidget {
  StudentPage(this.student);
  final student;

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7fcd91),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.1,
        backgroundColor: Color(0xFF7fcd91),
        title: Text("صفحة طالب",style: GoogleFonts.tajawal()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 13),
        child: Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width: 5),
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0.0, 5.0),
                          blurRadius: 8.0)
                    ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage('${ServerUrl.url}/img/students/' + widget.student['image']),
                  radius: 60,
                ),
              ),
              SizedBox(height: 15,),
              Card(
                elevation: 8.0,
                margin:
                new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: ExpansionTile(
                    leading: Container(
                      padding: EdgeInsets.only(left: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              left: new BorderSide(
                                  width: 1.0, color: Colors.black54))),
                      child: Icon(FontAwesome5.id_card,
                          color: Color(0xFF7fcd91)),
                    ),
                    title: Text(
                      "بيانات الطالب",
                      style: TextStyle(
                          color: Color(0xFF4d4646),
                          fontWeight: FontWeight.bold),
                    ),
                    initiallyExpanded: true,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                            ListTile(
                              title: Text(widget.student['name']),
                              leading: Icon(Octicons.person),
                            ),
                            ListTile(
                              title: Text(widget.student['email']),
                              leading: Icon(MaterialIcons.email),
                            ),
                            ListTile(
                              title: Text(widget.student['phone']),
                              leading: Icon(MaterialIcons.phone),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: InkWell(
                      onTap: ()=> Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentAttendancePage(widget.student['id'])),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 14, left: 0, right: 0, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                      Colors.black12.withOpacity(0.3),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.grey[300],
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 16,
                                    right: 16,
                                    bottom: 8),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(MaterialCommunityIcons.account_check_outline,color: Colors.black87.withOpacity(0.7),),
                                    SizedBox(height: 3,),
                                    Text(
                                      "الغياب ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 0.2,
                                        color: Colors.black87.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: InkWell(
                      onTap: ()=> Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentGradesPage(widget.student['id'])),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 14, left: 0, right: 0, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                      Colors.black12.withOpacity(0.3),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.grey[300],
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 16,
                                    right: 16,
                                    bottom: 8),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Feather.percent,color: Colors.black87.withOpacity(0.7),),
                                    SizedBox(height: 3,),
                                    Text(
                                      "الدرجات",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 0.2,
                                        color: Colors.black87.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "*من هذه الصفحة يمكنك فقط الاطلاع علي الدرجات والغياب اذا كنت تريد إضافة او تعديل يمكنك هذا من صفحة الفصل",
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
