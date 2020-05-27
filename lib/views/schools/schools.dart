import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/school.dart';

class SchoolsPage extends StatefulWidget {
  @override
  _SchoolsPageState createState() => _SchoolsPageState();
}

class _SchoolsPageState extends State<SchoolsPage> {
  School school = new School();
  List schools;
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
          title: Text("جميع المدارس",style: GoogleFonts.tajawal()),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(FontAwesome5Solid.plus, color: Colors.white),
                onPressed: () =>
                    Navigator.pushNamed(context, "/addschool").then((value) {
                      school.getSchools().then((value) => {
                            setState(() {
                              schools = value;
                            })
                          });
                    })),
          ],
        ),
        body: FutureBuilder(
          future: school.getSchools(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            schools = snapshot.data;
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: schools.length,
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
                        padding: EdgeInsets.only(left: 14.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                left: new BorderSide(
                                    width: 1.0, color: Colors.black54))),
                        child: Icon(FontAwesome5Solid.school, color: Color(0xFF7fcd91)),
                      ),
                      title: Text(
                        schools[i]['name'],
                        style: TextStyle(
                            color: Color(0xFF4d4646), fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(EvilIcons.location, color: Color(0xFF7fcd91)),
                          Text(" ${schools[i]['address']}",
                              style: TextStyle(color: Colors.black))
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_left,
                          color: Color(0xFF4d4646), size: 30.0),
                      onTap: () {
                        print('test');
                      },
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
