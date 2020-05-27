import 'package:flutter/material.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:teacherAssistant/providers/lecture.dart';

class LecturePage extends StatefulWidget {
  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  Lecture myLecture = new Lecture();
  @override
  void initState() {
    super.initState();
  }

  var lecture;
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) lecture = arguments['lecture'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.1,
        backgroundColor: Color(0xFF7fcd91),
        title: Text("${lecture['name']}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Lecture Name : ${lecture['name']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    fontSize: 17
                  ),
                ),
                SizedBox(height: 30,),
                Text(
                  "Lecture Description : ${lecture['description']}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      fontSize: 17
                  ),
                ),
                SizedBox(height: 30,),
                RaisedButton(
                  onPressed: (){
                    PdftronFlutter.openDocument("${myLecture.serverUrl}/files/${lecture['file']}");
                    print("${myLecture.serverUrl}/files/${lecture['file']}");
                  },
                  child: Text(lecture['file']),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
