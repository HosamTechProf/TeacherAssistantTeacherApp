import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/myClass.dart';

class MyClassesPage extends StatefulWidget {
  @override
  _MyClassesPageState createState() => _MyClassesPageState();
}

class _MyClassesPageState extends State<MyClassesPage> {
  MyClass myClass = new MyClass();
  List classes;
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
          title: Text("الفصول",style: GoogleFonts.tajawal()),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesome5Solid.plus, color: Colors.white),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AddClass();
                    }).then((value) => {
                      myClass.getMyClasses().then((value) => {
                            setState(() {
                              classes = value;
                            })
                          })
                    });
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: myClass.getMyClasses(),
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
                  classes = snapshot.data;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: classes.length,
                    itemBuilder: (context, i) {
                      return Card(
                        elevation: 8.0,
                        margin:
                        new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              padding: EdgeInsets.only(left: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      left: new BorderSide(
                                          width: 1.0, color: Colors.black54))),
                              child: Icon(MaterialCommunityIcons.google_classroom,
                                  color: Color(0xFF7fcd91)),
                            ),
                            title: Text(
                              classes[i]['name'],
                              style: TextStyle(
                                  color: Color(0xFF4d4646),
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.keyboard_arrow_left,
                                color: Color(0xFF4d4646), size: 30.0),
                            onTap: () {
                              Navigator.pushNamed(context, "/myclass",arguments: {'class': classes[i]});
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
            }
          },
        ));
  }
}

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  MyClass myClass = new MyClass();
  final TextEditingController _nameController = new TextEditingController();

  submit() {
    var info = {'name': _nameController.text};
    myClass.addClass(info, 'classes/add').then((res) => {
          if (res['status'] == true)
            {
              Navigator.pop(context),
              Fluttertoast.showToast(
                  msg: "تم إضافة الفصل بنجاح",
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
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'إضافة فصل جديد',
                style: TextStyle(color: Colors.black54, fontSize: 17, letterSpacing: 1.0,fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "إسم الفصل",
                  labelStyle: TextStyle(
                    color: Colors.black45
                  ),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xFF7fcd91),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                  //fillColor: Colors.green
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
