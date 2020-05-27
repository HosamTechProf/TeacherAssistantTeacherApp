import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/calendar_week.dart';
import 'package:flutter_calendar_week/model/decoration_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/attendance.dart';
import 'package:teacherAssistant/providers/myClass.dart';
import 'package:intl/intl.dart';
import 'package:teacherAssistant/views/attendance/take_attendance.dart';

class AttendanceHomePage extends StatefulWidget {
  AttendanceHomePage(this.selectedClass);
  final selectedClass;

  @override
  _AttendanceHomePageState createState() => _AttendanceHomePageState();
}

class _AttendanceHomePageState extends State<AttendanceHomePage> {
  MyClass myClass = new MyClass();
  Attendance attendance = new Attendance();
  List lectures = [];
  var classData;
  var info;
  String _selectedDate = new DateFormat("yyyy-MM-dd").format(DateTime.now());

//  Future<void> _selectDate(BuildContext context) async {
//    final DateTime d = await showDatePicker(
//      context: context,
//      initialDate: DateTime.now(),
//      firstDate: DateTime(2000),
//      lastDate: DateTime(2100),
//    );
//    if (d != null)
//      setState(() {
//        _selectedDate = new DateFormat("yyyy-MM-dd").format(d);
//      });
//  }

  @override
  void initState() {
    super.initState();
    if(widget.selectedClass == 0){

    }else{
      myClass.getAllClassData(widget.selectedClass).then((res) async=>{
        setState((){
          classData = res;
        }),
        setState((){
          info = {
            'class_id' : res['class_data']['id'].toString(),
            'date' : _selectedDate
          };
        }),
        attendance.getDayLectures(info, "attendance/getdaylectures").then((value)=>{
          setState((){
            lectures = value;
          })
        })
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return classData == null ? Scaffold(body: Center(child: CircularProgressIndicator(),),) :
    Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFF7fcd91),
        title: Text("${classData['class_data']['name']}",style: GoogleFonts.tajawal()),
      ),
      body: Column(
        children: [
          Container(
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    0.0,
                    2.0,
                  ),
                )
              ],
            ),
            child: CalendarWeek(
              height: 80,
              minDate: DateTime.now().add(
                Duration(days: -365),
              ),
              maxDate: DateTime.now().add(
                Duration(days: 365),
              ),
              onDatePressed: (DateTime datetime) {
                setState(() {
                  _selectedDate = new DateFormat("yyyy-MM-dd").format(datetime);
                });
                setState((){
                  info = {
                    'class_id' : classData['class_data']['id'].toString(),
                    'date' : _selectedDate
                  };
                });
                attendance.getDayLectures(info, "attendance/getdaylectures").then((res)=>{
                  setState((){
                    lectures = res;
                  })
                });
              },
              onDateLongPressed: (DateTime datetime) {
                setState(() {
                  _selectedDate = new DateFormat("yyyy-MM-dd").format(datetime);
                });
                setState((){
                  info = {
                    'class_id' : classData['class_data']['id'].toString(),
                    'date' : _selectedDate
                  };
                });
                attendance.getDayLectures(info, "attendance/getdaylectures").then((res)=>{
                  setState((){
                    lectures = res;
                  })
                });
              },
              dayOfWeekStyle:
              TextStyle(color: Color(0xFF7fcd91), fontWeight: FontWeight.w600),
              dayOfWeekAlignment: FractionalOffset.bottomCenter,
              dateStyle:
              TextStyle(color: Color(0xFF7fcd91), fontWeight: FontWeight.w400),
              dateAlignment: FractionalOffset.topCenter,
              todayDateStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              todayBackgroundColor: Colors.black.withOpacity(0.10),
              pressedDateBackgroundColor: Color(0xFF7fcd91),
              pressedDateStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              dateBackgroundColor: Colors.transparent,
              backgroundColor: Colors.white,
              dayOfWeek: ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعه', 'السبت', 'الأحد'],
              spaceBetweenLabelAndDate: 0,
              dayShapeBorder: CircleBorder(),
              decorations: [
                  DecorationItem(
                      decorationAlignment: FractionalOffset.bottomRight,
                      date: DateTime.now(),
                      decoration: Icon(
                        Icons.today,
                        color: Color(0xFF7fcd91),
                      )),
              ],
            ),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                      "إضافة غياب جديد",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    )
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text(
                    "  غياب يوم  $_selectedDate",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                lectures.isEmpty
                    ?
                Column(
                  children: [
                    Center(
                      child: Opacity(
                        opacity: 0.4,
                        child: Image.asset("assets/date.png", width: 150,),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text(
                      "لا يوجد محاضرات في هذا اليوم",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.0
                      ),
                    )
                  ],
                )
                    :
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: lectures.length,
                  itemBuilder: (context, i){
                    return ListTile(
                        title: Text(
                          lectures[i]['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        trailing: Container(
                          width: 80,
                          height: 40,
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TakeAttendancePage(classData['students'], lectures[i]['id'])),
                                );
                              },
                              child: Center(
                                child: Text("عرض",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        )
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
