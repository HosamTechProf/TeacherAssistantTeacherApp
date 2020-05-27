import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/myClass.dart';
import 'package:teacherAssistant/providers/student.dart';

class StudentGradesPage extends StatefulWidget {
  StudentGradesPage(this.studentId);
  final studentId;

  @override
  _StudentGradesPageState createState() => _StudentGradesPageState();
}

class _StudentGradesPageState extends State<StudentGradesPage> {

  int selectedClass;
  MyClass myClass = new MyClass();
  Student student = new Student();

  List grades = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("صفحة الدرجات", style: GoogleFonts.tajawal(),),
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
                        student.getStudentGradesForClass(selectedClass, widget.studentId).then((res) => {
                          setState((){
                            grades = res;
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
            grades.isNotEmpty ?
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, i) {
                  return grades[i]['pivot'] != null ? Divider(height: 3,thickness: 1.5,)
                  : Container();
                },
                shrinkWrap: true,
                itemCount: grades.length,
                itemBuilder: (context, i){
                  return grades[i]['pivot'] != null ? ListTile(
                    title: Text(grades[i]['mygrade']['title']),
                    trailing: Text("${grades[i]['pivot']['grade']} / ${grades[i]['mygrade']['max_grade']}"),
                  )
                  : Container();
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
