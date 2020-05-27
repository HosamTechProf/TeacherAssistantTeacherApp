import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:teacherAssistant/providers/assignment.dart';

class AssignmentsHomePage extends StatefulWidget {
  @override
  _AssignmentsHomePageState createState() => _AssignmentsHomePageState();
}

class _AssignmentsHomePageState extends State<AssignmentsHomePage> {
  var classId;
  Assignment assignment = new Assignment();

  List assignments;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) classId = arguments['myClassData'];

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Color(0xFF7fcd91),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.1,
        backgroundColor: Color(0xFF7fcd91),
        title: Text("Assignments"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesome5Solid.plus, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, "/addassignment", arguments: {"myClassData":classId}).then((value) => {
              assignment.getAllAssignments(classId).then((res)=>{
                setState((){
                  assignments = res;
                })
              })
            }),
          ),
        ],
      ),
      body: FutureBuilder(
        future: assignment.getAllAssignments(classId),
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
                assignments = snapshot.data;
                return ListView.builder(
                  itemCount: assignments.length,
                  itemBuilder: (context, i){
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
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.black54))),
                            child: Icon(Ionicons.md_paper, color: Color(0xFF7fcd91)),
                          ),
                          title: Text(
                            assignments[i]['title'],
                            style: TextStyle(
                                color: Color(0xFF4d4646), fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Icon(EvilIcons.calendar, color: Color(0xFF7fcd91)),
                              Text(" ${assignments[i]['assignmentDate']}",
                                  style: TextStyle(color: Colors.black))
                            ],
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Color(0xFF4d4646), size: 30.0),
                          onTap: () {
                            print('test');
                          },
                        ),
                      ),
                    );
                  }
                );
              }
          }
        },
      ),
    );
  }
}
