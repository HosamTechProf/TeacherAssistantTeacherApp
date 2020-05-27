import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/myClass.dart';
import 'package:teacherAssistant/providers/serve_url.dart';
import 'package:teacherAssistant/providers/student.dart';
import 'package:teacherAssistant/views/attendance/attendance_home.dart';
import 'package:teacherAssistant/views/students/student_page.dart';

class MyClassPage extends StatefulWidget {
  @override
  _MyClassPageState createState() => _MyClassPageState();
}

class _MyClassPageState extends State<MyClassPage> {
  MyClass myClass = new MyClass();
  Student student = new Student();
  var myClassData;
  var myData;
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) myClassData = arguments['class'];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Ionicons.ios_chatbubbles),
            onPressed: () => Navigator.pushNamed(context, "/chat",arguments: {'myClassData':myClassData}),
          ),
        ],
        backgroundColor: Colors.grey[100],
        elevation: 0.3,
//        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: ()=>Navigator.pop(context),
        ),
        iconTheme: IconThemeData(
            color: Colors.black87
        ),
        title: Text(myClassData["name"],style: GoogleFonts.tajawal(letterSpacing: 1.0,fontWeight: FontWeight.bold,color: Colors.black87)),
      ),
      body: FutureBuilder(
        future: myClass.getAllClassData("${myClassData['id']}"),
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            default:
              if (snapshot.hasError) {
                return new Text(
                    'Error: ${snapshot.error}');
              } else {
                myData = snapshot.data;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text(
                        "إجراءات الفصل",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: InkWell(
                            onTap: ()=> Navigator.pushNamed(context, "/chat", arguments: {"myClassData":myClassData}),
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
                                              Colors.green,
                                              Color(0xFF7fcd91),
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
                                              Icon(Ionicons.ios_chatbubbles,color: Colors.white,),
                                              SizedBox(height: 3,),
                                              Text(
                                                "المناقشات",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.2,
                                                  color: Colors.white,
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
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AttendanceHomePage(myClassData['id'])),
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
                                              Colors.green,
                                              Color(0xFF7fcd91),
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
                                              Icon(MaterialCommunityIcons.account_check_outline,color: Colors.white,),
                                              SizedBox(height: 3,),
                                              Text(
                                                "الغياب   ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.2,
                                                  color: Colors.white,
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
//                            Padding(
//                              padding: const EdgeInsets.only(right: 15),
//                              child: InkWell(
//                            onTap: ()=> Navigator.pushNamed(context, "/assignments", arguments: {"myClassData":myClassData['id']}),
//                                child: Stack(
//                                  children: <Widget>[
//                                    Padding(
//                                      padding: const EdgeInsets.only(
//                                          top: 14, left: 0, right: 0, bottom: 20),
//                                      child: Container(
//                                        decoration: BoxDecoration(
//                                          boxShadow: <BoxShadow>[
//                                            BoxShadow(
//                                                color:
//                                                Colors.black12.withOpacity(0.3),
//                                                offset: const Offset(1.1, 4.0),
//                                                blurRadius: 8.0),
//                                          ],
//                                          gradient: LinearGradient(
//                                            colors: [
//                                              Colors.green,
//                                              Color(0xFF7fcd91),
//                                            ],
//                                            begin: Alignment.topLeft,
//                                            end: Alignment.bottomRight,
//                                          ),
//                                          borderRadius: const BorderRadius.only(
//                                            bottomRight: Radius.circular(8.0),
//                                            bottomLeft: Radius.circular(8.0),
//                                            topLeft: Radius.circular(8.0),
//                                            topRight: Radius.circular(8.0),
//                                          ),
//                                        ),
//                                        child: Padding(
//                                          padding: const EdgeInsets.only(
//                                              top: 8,
//                                              left: 16,
//                                              right: 16,
//                                              bottom: 8),
//                                          child: Column(
//                                            mainAxisAlignment:
//                                            MainAxisAlignment.center,
//                                            crossAxisAlignment:
//                                            CrossAxisAlignment.center,
//                                            children: <Widget>[
//                                              Icon(Ionicons.md_paper,color: Colors.white,),
//                                              SizedBox(height: 3,),
//                                              Text(
//                                                "الواجبات",
//                                                textAlign: TextAlign.center,
//                                                style: TextStyle(
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 16,
//                                                  letterSpacing: 0.2,
//                                                  color: Colors.white,
//                                                ),
//                                              ),
//                                            ],
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: InkWell(
                            onTap: ()=> Navigator.pushNamed(context, "/gradeshome", arguments: {"classId":myClassData['id']}),
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
                                              Colors.green,
                                              Color(0xFF7fcd91),
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
                                              Icon(Feather.percent,color: Colors.white,),
                                              SizedBox(height: 3,),
                                              Text(
                                                "الدرجات  ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.2,
                                                  color: Colors.white,
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "طلاب الفصل",
                            style: TextStyle(
                                color: Color(0xff242424),
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                            tooltip: "إضافة طالب",
                            icon: Icon(Icons.add),
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AddStudent(myClassData['id']);
                                  }).then((value) => {
                                    student.getAllStudents().then((value) => {
                                      setState((){
                                        myData = value;
                                      })
                                    })
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      myData['students'].isEmpty
                          ?
                      Center(
                        child: Column(
                          children: <Widget>[
//                            Opacity(child: Image.asset('assets/nodata.png',width: 150,),opacity: 0.4,),
                              SizedBox(height: 30,),
                                Text(
                                  "لا يوجد طلبة في هذا الفصل",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1.0
                                ),
                            )
                          ],
                        ),
                      )
                          :
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: myData['students'].length,
                          itemBuilder: (context, i){
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                              onTap: ()=> Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StudentPage(myData['students'][i])),
                              ),
                              title: Text(
                                myData['students'][i]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.7)
                                ),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_left),
                              leading: Container(
                                padding: EdgeInsets.only(left: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        left: new BorderSide(width: 0.6, color: Colors.black54),
                                    )
                                ),
                                child: Card(
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage('${ServerUrl.url}/img/students/' + myData['students'][i]['image']),
                                  ),
                                  elevation: 3.0,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

class IconTile extends StatelessWidget {
  final String imgAssetPath;
  final Color backColor;

  IconTile({this.imgAssetPath, this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: backColor, borderRadius: BorderRadius.circular(15)),
        child: Image.asset(
          imgAssetPath,
          width: 20,
        ),
      ),
    );
  }
}

class AddStudent extends StatefulWidget {
  AddStudent(this.myClassId);
  final myClassId;
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {

  Student student = new Student();
  List selectedStudents = [];

  @override
  initState(){
    super.initState();
    student.getClassStudentsIds(widget.myClassId).then((value) => {
      setState((){
        selectedStudents = value;
      }),
    });
  }

  submit() {
    var info = {
      'selected_students': jsonEncode(selectedStudents),
      'class_id' : widget.myClassId.toString()
    };
    student.addStudentsToClass(info, 'addstudentstoclass').then((res) => {
      if (res['status'] == true)
        {
          Navigator.pop(context),
          Fluttertoast.showToast(
              msg: "تم تحديث الطلبة بنجاح",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0)
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        height: 400.0,
        width: 300.0,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(FontAwesome.search),
                      labelText: "بحث عن طالب"
                    ),
                  ),
                ),
                IconButton(
                  onPressed: submit,
                  icon: Icon(Icons.check),
                ),
              ],
            ),
            FutureBuilder(
              future: student.getAllStudents(),
              builder: (context, snapshot){
                if(snapshot.data != null){
                  List students = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: students.length,
                      itemBuilder: (context, i){
                        return CheckboxListTile(
                          title: Text(students[i]['name']),
                          onChanged: (val){
                            if(val == true){
                              setState(() {
                                selectedStudents.add(students[i]['id']);
                              });
                            }else{
                              setState(() {
                                selectedStudents.remove(students[i]['id']);
                              });
                            }
                          },
                          value: selectedStudents.contains(students[i]['id']),
                        );
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator(),);
              },
            )
          ],
        ),
      ),
    );
  }
}
