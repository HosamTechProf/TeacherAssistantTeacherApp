import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherAssistant/providers/myClass.dart';

class SearchPage extends StatefulWidget {
  final String search;

  const SearchPage(this.search);
  @override
  _SearchPageState createState() => _SearchPageState(this.search);
}

class _SearchPageState extends State<SearchPage> {
  _SearchPageState(String search);
  MyClass myClass = new MyClass();
  final TextEditingController _searchController = new TextEditingController();
  List classes;
  @override
  void initState() {
    super.initState();
    setState(() {
      _searchController.text = widget.search;
    });
  }

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
        title: Text("بحث",style: GoogleFonts.tajawal()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Hero(
                tag: "DemoTag",
                child: Material(
                  type: MaterialType.transparency,
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (val){
                      myClass.search(val).then((value) => {
                        setState(() {
                          classes = value;
                        })
                      });
                    },
                    autofocus: true,
                    decoration: new InputDecoration(
                      suffixIcon: Icon(
                        FontAwesome.search,
                        color: Colors.black38,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      hintText: ' البحث عن فصول',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: myClass.search(_searchController.text),
                builder: (context, snapshot){
                  classes = snapshot.data;
                  if(classes == [{}] || classes == null){
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Opacity(child: Image.asset('assets/nodata.png',width: 150,),opacity: 0.5,),
                          SizedBox(height: 30,),
                          Text(
                            "لا يوجد فصل بهذا الاسم",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.0
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: classes == null ? 0 : classes.length,
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
                                child: Icon(MaterialCommunityIcons.google_classroom, color: Color(0xFF7fcd91)),
                              ),
                              title: Text(
                                classes[i]['name'],
                                style: TextStyle(
                                    color: Color(0xFF4d4646), fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_left,
                                  color: Color(0xFF4d4646), size: 30.0),
                              onTap: () {
                                Navigator.pushNamed(context, "/myclass", arguments: {"class":classes[i]});
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
              ),
            )
          ],
        ),
      ),
    );
  }
}
