import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/myClass.dart';
import 'package:teacherAssistant/providers/serve_url.dart';
import 'package:teacherAssistant/providers/student.dart';
import 'package:teacherAssistant/views/attendance/attendance_home.dart';
import 'package:teacherAssistant/views/students/student_page.dart';

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  Student student = new Student();
  MyClass myClass = new MyClass();
  int selectedClass;
  List students = [];
  List classes = [];
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
          title: Text("الطلاب",style: GoogleFonts.tajawal()),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(FontAwesome5Solid.plus, color: Colors.white),
                onPressed: () =>
                    Navigator.pushNamed(context, "/addstudent").then((value) => {
                      setState(() {
                        selectedClass = null;
                      })
                    })),
          ],
        ),
        floatingActionButton: selectedClass != null && students.isNotEmpty && selectedClass != 0 ? RawMaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AttendanceHomePage(selectedClass)),
            );
          },
          elevation: 6.0,
          fillColor: Colors.red[400],
          child: Icon(
            MaterialCommunityIcons.account_check_outline,
            size: 27.0,
            color: Colors.black87,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ) : Container(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              DropdownButtonHideUnderline(
                child: Container(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.white12),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  child: FutureBuilder(
                    future: myClass.getMyClasses(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator(),);
                        default:
                          if (snapshot.hasError) {
                            return new Text(
                                'Error: ${snapshot.error}');
                          } else {
                            classes = snapshot.data;
                            if(classes.isNotEmpty)
                            if(classes[0]['id'] != 0){
                              classes.insert(0,{"id":0,"name":"عرض جميع الطلاب"});
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

                                if(selectedClass == 0){
                                  student.getAllStudents().then((res) => {
                                    setState(() {
                                      students = res;
                                    })
                                  });
                                }else{
                                  student.getStudentsForClass(selectedClass).then((res) => {
                                    setState(() {
                                      students = res;
                                    })
                                  });
                                }
                              },
                              hint: Text("برجاء تحديد فصل",style: GoogleFonts.tajawal()),
                              items: classes.map<DropdownMenuItem>((value) {
                                return DropdownMenuItem(
                                  value: value['id'],
                                  child: value['id']==0 ? Text(value['name'],style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)) : Text(value['name'],style: GoogleFonts.tajawal()),
                                );
                              }).toList(),
                            );                          }
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 13,),
              selectedClass != null
                  ?
              students.isEmpty ? Center(
                child: Column(
                  children: <Widget>[
                    Opacity(child: Image.asset('assets/nodata.png',width: 150,),opacity: 0.4,),
                    SizedBox(height: 30,),
                    Text(
                      "لا يوجد طلاب في هذا الفصل",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.0
                      ),
                    )
                  ],
                ),
              ) : Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 8.0,
                      margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration:
                        BoxDecoration(color: Colors.grey[200]),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: EdgeInsets.only(left: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    left: new BorderSide(
                                        width: 0.6, color: Colors.black54))),
                            child: Card(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage('${ServerUrl.url}/img/students/' + students[i]['image']),
                              ),
                              elevation: 3.0,
                              shape: CircleBorder(),
                              clipBehavior: Clip.antiAlias,
                            ),
                          ),
                          title: Text(
                            students[i]['name'],
                            style: TextStyle(
                                color: Color(0xFF4d4646), fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Icon(MaterialCommunityIcons.email_outline, color: Color(0xFF7fcd91)),
                              Text(" ${students[i]['email']}",
                                  style: TextStyle(color: Colors.black))
                            ],
                          ),
                          trailing: Icon(Icons.keyboard_arrow_left,
                              color: Color(0xFF4d4646), size: 30.0),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StudentPage(students[i])),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
                  :
              Column(
                children: [
                  SizedBox(height: 60,),
                  Opacity(child: Image.asset('assets/select_class.png',width: 150,),opacity: 0.5,),
                  SizedBox(height: 30,),
                  Text(
                    "برجاء تحديد فصل لإظهار الطلبة الخاصه به",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.0,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
    );
  }
}
