import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/lecture.dart';

class LecturesPage extends StatefulWidget {
  @override
  _LecturesPageState createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage> {
  Lecture lecture = new Lecture();
  List lectures = [];

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
        title: Text("المحاضرات",style: GoogleFonts.tajawal(),),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesome5Solid.plus, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, "/addlecture").then((value) => {
              lecture.getMyLectures().then((value) => {
                setState(() {
                  lectures = value;
                })
              })
            })
          ),
        ],
      ),
      body: FutureBuilder(
          future: lecture.getMyLectures(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            lectures = snapshot.data;
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: lectures.length,
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
                                    width: 1.0, color: Colors.black54))),
                        child: Icon(Feather.book, color: Color(0xFF7fcd91)),
                      ),
                      title: Text(
                        lectures[i]['name'],
                        style: TextStyle(
                            color: Color(0xFF4d4646), fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Feather.file,size: 17, color: Color(0xFF7fcd91)),
                          Expanded(
                            child: Text(" ${lectures[i]['file']}",
                                style: TextStyle(color: Colors.black)),
                          )
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_left,
                          color: Color(0xFF4d4646), size: 30.0),
                      onTap: () {
                        Navigator.pushNamed(context, "/lecturepage",arguments: {'lecture': lectures[i]});
                      },
                    ),
                  ),
                );
              },
            );
          },
        )
    );
  }
}
