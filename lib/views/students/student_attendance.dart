import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/myClass.dart';
import 'package:teacherAssistant/providers/student.dart';

class StudentAttendancePage extends StatefulWidget {
  StudentAttendancePage(this.studentId);
  final studentId;

  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {

  int selectedClass;
  MyClass myClass = new MyClass();
  Student student = new Student();

  List attendance = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("صفحة غياب", style: GoogleFonts.tajawal(),),
        centerTitle: true,
        backgroundColor: Color(0xFF7fcd91),
        elevation: 0.0,
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: Column(
          children: [
            DropdownButtonHideUnderline(
              child: Container(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: FutureBuilder(
                  future: myClass.getMyClasses(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.data == null){
                      return CircularProgressIndicator();
                    }
                    List classes = snapshot.data;
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
                        student.getStudentAttendanceForClass(selectedClass, widget.studentId).then((res) => {
                          setState((){
                            attendance = res;
                          }),
                        });
                      },
                      hint: Text("برجاء تحديد فصل",style: GoogleFonts.tajawal()),
                      items: classes.map<DropdownMenuItem>((value) {
                        return DropdownMenuItem(
                          value: value['id'],
                          child: value['id']==0 ? Text(value['name'],style: TextStyle(fontWeight: FontWeight.bold),) : Text(value['name']),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 13,),
            attendance.isNotEmpty ?
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(height: 3,thickness: 1.5,);
                },
                shrinkWrap: true,
                itemCount: attendance.length,
                itemBuilder: (context, i){
                  return ListTile(
                    leading: Container(
                      constraints: new BoxConstraints(
                        minHeight: 50.0,
                        minWidth: 50.0,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: attendance[i]['pivot']['type'] == "0" ? Colors.redAccent : Colors.green),
                      ),
                    ),
                    title: attendance[i]['pivot']['type'] == "0" ? Text("غائب",style: TextStyle(fontWeight: FontWeight.bold),) : Text("حاضر", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${attendance[i]['lecture']['name']} , ${attendance[i]['lecture']['lectureDate']} , ${attendance[i]['lecture']['lectureTime']}"),
                  );
                },
              ),
            )
                :
                Container()
          ],
        ),
      ),
    );
  }
}
