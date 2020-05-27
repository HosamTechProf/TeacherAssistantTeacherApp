import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teacherAssistant/providers/city.dart';
import 'package:teacherAssistant/providers/school.dart';

class AddSchoolPage extends StatefulWidget {
  @override
  _AddSchoolPageState createState() => _AddSchoolPageState();
}

class _AddSchoolPageState extends State<AddSchoolPage> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();

  City city = new City();
  int myCity;

  final addressFocus = FocusNode();
  final cityFocus = FocusNode();

  School school = new School();
  addSchool(){
    setState(() {
      var info = {
        'name' : _nameController.text.trim(),
        'address' : _addressController.text.trim(),
        'city_id' : myCity.toString(),
      };
      if(_nameController.text.trim().toLowerCase().isNotEmpty &&
          _addressController.text.isNotEmpty && myCity != null){
        school.addSchool(info, 'school/add').then((res) =>{
          if(res['status'] == true){
            Navigator.pop(context),
            Fluttertoast.showToast(
                msg: "تم إضافة المدرسة بنجاح",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            )
          }else{
            _showDialog(res.toString()),
          }
        });
      }else{
        _showDialog('تحقق من البيانات المدخلة');
      }
    });
  }

  void _showDialog(String msg){
    showDialog(
        context:context ,
        builder:(BuildContext context){
          return AlertDialog(
            title: new Text('مشكلة'),
            content:  new Text(msg),
            actions: <Widget>[
              new RaisedButton(
                color: Colors.blue,
                child: new Text(
                  'غلق',
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "إضافة مدرسة جديدة",
        ),
        elevation: 0.1,
        backgroundColor: Color(0xFF7fcd91),
      ),
      body: SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/school.png",
              height: 130,
            ),
            SizedBox(height: 15,),
            Text(
              "اضف بيانات المدرسة",
              style: TextStyle(
                fontSize: 23,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v){
                FocusScope.of(context).requestFocus(addressFocus);
              },
              decoration: InputDecoration(
                labelText: "الإسم",
                fillColor: Colors.white,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(),
                ),
                //fillColor: Colors.green
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: _addressController,
              focusNode: addressFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v){
                FocusScope.of(context).requestFocus(cityFocus);
              },
              decoration: InputDecoration(
                labelText: "العنوان",
                fillColor: Colors.white,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(),
                ),
                //fillColor: Colors.green
              ),
            ),
            SizedBox(
              height: 40,
            ),
            DropdownButtonHideUnderline(
              child: Container(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
                child: FutureBuilder(
                  future: city.getCities(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    List cities = snapshot.data;
                    if(snapshot.data == null){
                      return CircularProgressIndicator();
                    }
                    return DropdownButton(
                      focusNode: cityFocus,
                      isExpanded: true,
                      value: myCity,
                      icon: Icon(AntDesign.downcircleo),
                      iconSize: 20,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      onChanged: (newValue) {
                        setState(() {
                          myCity = newValue;
                        });
                      },
                      hint: Text("المدينة"),
                      items: cities.map<DropdownMenuItem>((value) {
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
            SizedBox(height: 40,),
            InkWell(
              child: Container(
                width: 150,
                height: 54,
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
                    onTap: addSchool,
                    child: Center(
                      child: Text("إضافة المدرسة",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.0)),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
