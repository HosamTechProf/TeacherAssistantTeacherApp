import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teacherAssistant/providers/auth.dart';
import 'package:teacherAssistant/providers/chat.dart';
import 'package:teacherAssistant/views/chat/widgets/widgets.dart';
import 'dart:math' as math;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = new ScrollController();

  bool _showBottom = false;
  TextEditingController messageBoxController = TextEditingController();
  Color myGreen = Color(0xff4bb17b);

  int isEditable = 0;
  var editableMessage;

  Auth auth = new Auth();
  Chat chat = new Chat();
  List messages = [];
  var classData;
  var user;

  @override
  void initState() {
    super.initState();
    auth.getUserData().then((value) => {
      user = value
    });
  }
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) classData = arguments['myClassData'];

    return Scaffold(
      appBar: isEditable == 0
          ?
      AppBar(
        elevation: 5.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: myGreen,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          classData['name'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold
          ),
          overflow: TextOverflow.clip,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Octicons.info),
            onPressed: () {},
          ),
        ],
      )
          :
      AppBar(
        elevation: 5.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            setState(() {
              isEditable = 0;
              editableMessage = null;
            });
          },
        ),
        backgroundColor: Color(0xFF7fcd91).withOpacity(0.6),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(MaterialIcons.content_copy),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: editableMessage['message']));
              Fluttertoast.showToast(
                  msg: "تم نسخ الرساله",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
              setState(() {
                isEditable = 0;
                editableMessage = null;
              });
            },
          ),
          IconButton(
            icon: Icon(Octicons.trashcan),
            onPressed: () {
              chat.deleteMessage(editableMessage['id']).then((res)=>{
                if(res['status'] == true){
                  setState((){
                    messages.remove(editableMessage);
                    isEditable = 0;
                    editableMessage = null;
                  }),
                  Fluttertoast.showToast(
                      msg: "تم مسح الرساله",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0),
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: FutureBuilder(
                    future: chat.getMessages(classData['id']),
                    builder: (context, snapshot){
                      if(snapshot.data != null){
                        messages = snapshot.data;
                        messages = messages.reversed.toList();
                        return ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          padding: const EdgeInsets.all(15),
                          itemCount: messages.length,
                          itemBuilder: (ctx, i) {
                            if(user.isNotEmpty){
                              if(user[0]['id'] == messages[i]['user_id']){
                                return Container(
                                  decoration: BoxDecoration(
                                    color: isEditable == messages[i]['id'] ? Colors.blueGrey.withOpacity(0.4) : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: InkWell(
                                    child: SentMessageWidget(messages[i]),
                                    onLongPress: (){
                                      setState(() {
                                        isEditable = messages[i]['id'];
                                        editableMessage = messages[i];
                                      });
                                    },
                                  ),
                                );
                              }else{
                                return Container(
                                  decoration: BoxDecoration(
                                    color: isEditable == messages[i]['id'] ? Colors.blueGrey.withOpacity(0.4) : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: InkWell(
                                    child: ReceivedMessagesWidget(messages[i]),
                                    onLongPress: (){
                                      setState(() {
                                        isEditable = messages[i]['id'];
                                        editableMessage = messages[i];
                                      });
                                    },
                                  ),
                                );
                              }
                            }
                            return Container();
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  height: 61,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 2),
                                  blurRadius: 4,
                                  color: Colors.grey.withOpacity(0.7))
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 20,),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: messageBoxController,
                                  decoration: InputDecoration(
                                      hintText: "اكتب شئ ....",
                                      border: InputBorder.none),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.attach_file),
                                onPressed: () {
                                  setState(() {
                                    _showBottom = _showBottom ? false : true;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: myGreen, shape: BoxShape.circle),
                        child: InkWell(
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Icon(
                              MaterialIcons.send,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            var info = {
                              'class_id' : classData['id'].toString(),
                              'message' : messageBoxController.text,
                              'user_id' : user[0]['id'].toString()
                            };
                            setState(() {
                              messages.add(info);
                            });
                            messageBoxController.clear();
                            _scrollController.animateTo(
                              0.0,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                            chat.sendMessage(info, "sendmessage").then((res)=>{
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          _showBottom
              ? Positioned(
            bottom: 90,
            left: 25,
            right: 25,
            child: Container(
              padding: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 15.0,
                      color: Colors.grey)
                ],
              ),
              child: GridView.count(
                mainAxisSpacing: 21.0,
                crossAxisSpacing: 21.0,
                shrinkWrap: true,
                crossAxisCount: 3,
                children: List.generate(
                  icons.length,
                      (i) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[200],
                        border: Border.all(color: myGreen, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              icons[i],
                              color: myGreen,
                            ),
                            onPressed: () {},
                          ),
                          Text(
                            texts[i],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              letterSpacing: 0.7
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}

List<IconData> icons = [
  MaterialCommunityIcons.file_document_outline,
  Feather.image,
  AntDesign.sound
];
List<String> texts = [
  "ملف",
  "صورة",
  "صوت"
];