import 'package:flutter/material.dart';
import 'package:teacherAssistant/views/assignments/add_assignment.dart';
import 'package:teacherAssistant/views/assignments/assignments_home.dart';
import 'package:teacherAssistant/views/chat/chat_screen.dart';
import 'package:teacherAssistant/views/classes/my_class.dart';
import 'package:teacherAssistant/views/classes/my_classes.dart';
import 'package:teacherAssistant/views/grades/add_grade.dart';
import 'package:teacherAssistant/views/grades/grades_home.dart';
import 'package:teacherAssistant/views/home/home.dart';
import 'package:teacherAssistant/views/lectures/add_lecture.dart';
import 'package:teacherAssistant/views/lectures/lecture_page.dart';
import 'package:teacherAssistant/views/lectures/lectures.dart';
import 'package:teacherAssistant/views/profile/update_profile.dart';
import 'package:teacherAssistant/views/register/register.dart';
import 'package:teacherAssistant/views/login/Login.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacherAssistant/views/schools/add_school.dart';
import 'package:teacherAssistant/views/schools/schools.dart';
import 'package:teacherAssistant/views/students/add_student.dart';
import 'package:teacherAssistant/views/students/students.dart';
import 'package:teacherAssistant/views/subjects/my_subjects.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  bool isLoggedIn = false;
  final prefs = await SharedPreferences.getInstance();
  if (prefs.get('token') != null) {
    isLoggedIn = true;
  }
  runApp(MyHomeWidget(isLoggedIn));
}


class MyHomeWidget extends StatefulWidget {
  MyHomeWidget(this.isLoggedIn);
  final isLoggedIn;

  @override
  _MyHomeWidgetState createState() => _MyHomeWidgetState();
}

class _MyHomeWidgetState extends State<MyHomeWidget> {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar", "EG"),
      ],
      locale: Locale("ar", "EG"),
      theme: ThemeData(
          textTheme: GoogleFonts.tajawalTextTheme(textTheme).copyWith(
          )),
      debugShowCheckedModeBanner: false,
      title: 'Teacher Assistnat',
      home: widget.isLoggedIn ? HomePage() : LoginPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
        '/register': (BuildContext context) => RegisterPage(),
        '/schools': (BuildContext context) => SchoolsPage(),
        '/addschool': (BuildContext context) => AddSchoolPage(),
        '/myclasses': (BuildContext context) => MyClassesPage(),
        '/myclass': (BuildContext context) => MyClassPage(),
        '/subjects': (BuildContext context) => MySubjectsPage(),
        '/lectures': (BuildContext context) => LecturesPage(),
        '/addlecture': (BuildContext context) => AddLecturePage(),
        '/lecturepage': (BuildContext context) => LecturePage(),
        '/profile/update': (BuildContext context) => UpdateProfile(),
        '/students': (BuildContext context) => StudentsPage(),
        '/addstudent': (BuildContext context) => AddStudentPage(),
        '/chat': (BuildContext context) => ChatScreen(),
        '/gradeshome': (BuildContext context) => GradesHome(),
        '/addgrade': (BuildContext context) => AddGradePage(),
        '/assignments': (BuildContext context) => AssignmentsHomePage(),
        '/addassignment': (BuildContext context) => AddAssignmentPage(),
      },
    );
  }
}
