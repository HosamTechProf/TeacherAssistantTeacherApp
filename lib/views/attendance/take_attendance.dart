import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/attendance.dart';
import 'package:teacherAssistant/providers/serve_url.dart';

class TakeAttendancePage extends StatefulWidget {
  TakeAttendancePage(this.students, this.lecture);
  final students;
  final lecture;

  @override
  _TakeAttendancePageState createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage> {

  Attendance attendance = new Attendance();
  List absent = [];
  List present = [];
  List students = [];
  @override
  void initState() {
    super.initState();
    attendance.getAttendanceTakePage(widget.lecture).then((res) => {
      setState((){
        absent = res['absent'];
        present = res['present'];
      }),
    });
    }

  @override
  Widget build(BuildContext context) {
    students = widget.students;
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFF7fcd91),
        title: Text("صفحة أخذ الغياب",style: GoogleFonts.tajawal()),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
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
                            Text(
                              "حاضر",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0.2,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              present.length.toString(),
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
              SizedBox(width: 20,),
              Stack(
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
                            Colors.redAccent,
                            Colors.red.withOpacity(0.6),
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
                            Text(
                              "غائب",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0.2,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              absent.length.toString(),
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
              SizedBox(width: 20,),
              Stack(
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
                            Colors.blueGrey[300],
                            Colors.grey.withOpacity(0.6),
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
                            Text(
                              "غير مسجل",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0.2,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              (students.length - (present.length + absent.length)).toString(),
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
            ],
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: (itemWidth / itemHeight),
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 8.0,
              ),
              padding: const EdgeInsets.all(4.0),
              itemCount: students.length,
              itemBuilder: (context, i){
                return Column(
                  children: [
                    InkWell(
                      onTap:(){
                        var info = {
                          'studentId' : students[i]['id'].toString(),
                          'lectureId' : widget.lecture.toString()
                        };
                        attendance.addAttendance(info, "attendance/addattendance").then((res)=>{
                          if(!absent.contains(students[i]['id']) && !present.contains(students[i]['id'])){
                            setState((){
                              present.add(students[i]['id']);
                            })
                          }else if(present.contains(students[i]['id'])){
                            setState((){
                              present.remove(students[i]['id']);
                              absent.add(students[i]['id']);
                            })
                          }else if(absent.contains(students[i]['id'])){
                            setState((){
                              absent.remove(students[i]['id']);
                            })
                          }
                        });
                      },
                      child: GridTile(
                        child: Card(
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                        child: Stack(
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
                                    backgroundImage: NetworkImage('${ServerUrl.url}/img/students/' + students[i]['image']),
                                    radius: 60.0
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0.0,
                              left: 0.0,
                              bottom: 0.0,
                              child: Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: (!absent.contains(students[i]['id']) && !present.contains(students[i]['id'])) ? Colors.grey.withOpacity(0.7) : absent.contains(students[i]['id']) ? Colors.red.withOpacity(0.7) : present.contains(students[i]['id']) ? Colors.green.withOpacity(0.7) : null,
                                  ),
                                  child: Text(
                                    (!absent.contains(students[i]['id']) && !present.contains(students[i]['id'])) ? "غير مسجل" : absent.contains(students[i]['id']) ? "غائب" : present.contains(students[i]['id']) ? "حاضر" : null,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  margin: EdgeInsets.only(bottom: 8),
                                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ),
                      ),
                    ),
                    Text("${students[i]['name']}",textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
