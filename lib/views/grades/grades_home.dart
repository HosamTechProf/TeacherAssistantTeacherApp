import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/grades.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class GradesHome extends StatefulWidget {
  @override
  _GradesHomeState createState() => _GradesHomeState();
}

class _GradesHomeState extends State<GradesHome> {
  var classId;
  List students;
  List allGrades;

  Grades grades = new Grades();

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) classId = arguments['classId'];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          backgroundColor: Color(0xFF7fcd91),
          title: Text("الدرجات",style: GoogleFonts.tajawal()),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(FontAwesome5Solid.plus, color: Colors.white),
                onPressed: ()=> Navigator.pushNamed(context, "/addgrade", arguments: {"classId":classId}).then((value) => {
                  grades.getGradesForGradeHome(classId).then((res)=>{
                    setState((){
                      students = res['students'];
                      allGrades = res['grades'];
                    })
                  })
                })
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top:1),
          child: FutureBuilder(
            future: grades.getGradesForGradeHome(classId),
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
                    var myData = snapshot.data;
                    students = myData['students'];
                    allGrades = myData['grades'];
                    return StickyHeadersTable(
                      columnsLength: allGrades.length,
                      rowsLength: students.length,
                      columnsTitleBuilder: (i) => TableCell.stickyRow(
                          Text(allGrades[i]['title'],style: TextStyle(
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),),
                      ),
                      rowsTitleBuilder: (i) => TableCell.stickyColumn(
                          Column(
                            children: [
                              Text(students[i]['name']),
                            ],
                          ),
                      ),
                      contentCellBuilder: (i, j) => TableCell.content(
                          FutureBuilder(
                            future: grades.getStudentGrade(students[j]['id'], students[j]['gradess'][i]['id']),
                            builder: (context, snapshot){
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Center(child: CircularProgressIndicator(),);
                                default:
                                  if (snapshot.hasError) {
                                    return Text('');
                                  } else {
                                    List grade = snapshot.data;
                                    return grade.isNotEmpty
                                        ?
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 20,
                                            child: TextFormField(
                                              keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                                              initialValue: grade[0]['pivot']['grade'],
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                ),
                                              onFieldSubmitted: (value){
                                                var info = {
                                                  "grade_id" : grade[0]['pivot']['grade_id'].toString(),
                                                  "student_id" : grade[0]['pivot']['student_id'].toString(),
                                                  "grade" : value.toString(),
                                                };
                                                grades.editStudentGrade(info, "editstudentgrade").then((res)=>{
                                                });
                                              },
                                            )
                                        ),
                                        Text(" / ${grade[0]['max_grade']}"),
                                      ],
                                    )
                                        :
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 20,
                                            child: TextFormField(
                                              keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                                              initialValue: 0.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                              ),
                                              onFieldSubmitted: (value){
                                                var info = {
                                                  "grade_id" : students[j]['gradess'][i]['id'].toString(),
                                                  "student_id" : students[j]['id'].toString(),
                                                  "grade" : value.toString(),
                                                };
                                                grades.addStudentGrade(info, "addstudentgrade").then((res)=>{
                                                });
                                              },
                                            )
                                        ),
                                        Text(" / ${students[j]['gradess'][i]['max_grade']}"),
                                      ],
                                    );
                                  }
                              }
                            },
                          )
                      ),
                      legendCell: TableCell.legend(Text('الطلاب',style: GoogleFonts.tajawal(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17))),
                    );
                  }
              }
            },
          ),
        ),
    );
  }
}

class TableCell extends StatelessWidget {
  TableCell.content(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.white,
        this.onTap,
      })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Color(0xFF7fcd91),
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.legend(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = const Color(0xFF7fcd91),
        this.onTap,
      })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Color(0xFF7fcd91),
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.only(left: 24.0);

  TableCell.stickyRow(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = const Color(0xFF7fcd91),
        this.onTap,
      })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Color(0xFF7fcd91),
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.stickyColumn(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.white,
        this.onTap,
      })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Color(0xFF7fcd91),
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.zero;

  final CellDimensions cellDimensions;

  final Widget text;
  final Function onTap;

  final double cellWidth;
  final double cellHeight;

  final Color colorBg;
  final Color _colorHorizontalBorder;
  final Color _colorVerticalBorder;

  final TextAlign _textAlign;
  final EdgeInsets _padding;

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        padding: _padding,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: text,
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.1,
              color: _colorVerticalBorder,
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: _colorHorizontalBorder),
              right: BorderSide(color: _colorHorizontalBorder),
            ),
            color: colorBg),
      ),
    );
  }
}

