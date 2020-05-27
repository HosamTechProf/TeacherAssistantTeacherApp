import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/myClass.dart';
import 'package:teacherAssistant/providers/subject.dart';

class MySubjectsPage extends StatefulWidget {
  @override
  _MySubjectsPageState createState() => _MySubjectsPageState();
}

class _MySubjectsPageState extends State<MySubjectsPage> {
  Subject subject = new Subject();
  var subjects;
  List subjectsKeys = [];
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
          title: Text("المواد",style: GoogleFonts.tajawal()),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesome5Solid.plus, color: Colors.white),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AddSubject();
                    }).then((value) => {
                      subject.getMySubjects().then((value) => {
                            setState(() {
                              subjects = value;
                            })
                          })
                    });
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: subject.getMySubjects(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(),);
              default:
                if (snapshot.hasError) {
                  return new Text(
                      'Error: ${snapshot.error}');
                } else {
                  subjects = snapshot.data;
                  if(subjects.isNotEmpty)
                    subjectsKeys = Map<String, dynamic>.from(subjects).keys.toList();
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: subjects.length,
                    itemBuilder: (context, i) {
                      return Card(
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
                              child: Icon(MaterialCommunityIcons.book_open,
                                  color: Color(0xFF7fcd91)),
                            ),
                            title: Text(
                              subjectsKeys[i],
                              style: TextStyle(
                                  color: Color(0xFF4d4646),
                                  fontWeight: FontWeight.bold),
                            ),
                            initiallyExpanded: true,
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  for(var subject in subjects[subjectsKeys[i]])
                                    subject['class_name'] == subjectsKeys[i]
                                        ?
                                    ListTile(
                                      title: Text(subject['name']),
                                      onTap: (){},
                                    )
                                        : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
            }
          },
        )

//            Center(
//              child: Text(
//                "There Is No Subjects",
//                style: TextStyle(
//                  color: Colors.black.withOpacity(0.5),
//                  fontSize: 20,
//                  letterSpacing: 1.0
//                ),
//              ),
//            )
    );
  }
}

class AddSubject extends StatefulWidget {
  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  Subject subject = new Subject();
  MyClass myClass = new MyClass();
  final TextEditingController _nameController = new TextEditingController();
  var selectedClass;

  submit() {
    var info = {'name': _nameController.text,'class_id': selectedClass.toString()};
    subject.addSubject(info, 'subject/add').then((res) => {
          if (res['status'] == true)
            {
              Navigator.pop(context),
              Fluttertoast.showToast(
                  msg: "تم اضافة المادة بنجاح",
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
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'إضافة مادة جديدة',
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
            DropdownButtonHideUnderline(
              child: Container(
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
                child: FutureBuilder(
                  future: myClass.getMyClasses(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List classes = snapshot.data;
                    if (snapshot.data == null) {
                      return CircularProgressIndicator();
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
                      },
                      hint: Text("الفصول"),
                      items: classes.map<DropdownMenuItem>((value) {
                        return DropdownMenuItem(
                          value: value['id'],
                          child: Text(value['name']),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "إسم المادة",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xFF7fcd91),
                    ),
                  ),
                  labelStyle: TextStyle(
                      color: Colors.black45
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: 95,
                      height: 45,
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
                          onTap: ()=> submit(),
                          child: Center(
                            child: Text("إضافة",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    child: Container(
                      width: 95,
                      height: 45,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.red[300],
                            Colors.redAccent,
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
                          onTap: ()=> Navigator.pop(context),
                          child: Center(
                            child: Text("إلغاء",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
