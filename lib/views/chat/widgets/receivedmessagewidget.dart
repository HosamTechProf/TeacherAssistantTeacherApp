import 'package:flutter/material.dart';
import 'package:teacherAssistant/providers/serve_url.dart';

import 'mycircleavatar.dart';

class ReceivedMessagesWidget extends StatefulWidget {
  ReceivedMessagesWidget(this.message);
  final message;

  @override
  _ReceivedMessagesWidgetState createState() => _ReceivedMessagesWidgetState();
}

class _ReceivedMessagesWidgetState extends State<ReceivedMessagesWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.message['sender']['name'].toString(),
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 3,),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.grey.withOpacity(0.1))
                  ],
                ),
                child: Text(
                  "${widget.message['message']}",
                  style: Theme.of(context).textTheme.body1.apply(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 15),
          widget.message['user_id'] == null
              ?
          MyCircleAvatar(
            imgUrl: "${ServerUrl.url}/img/students/${widget.message['sender']['image']}",
          )
              :
          MyCircleAvatar(
            imgUrl: "${ServerUrl.url}/img/users/${widget.message['sender']['image']}",
          )
          ,
//          Text(
//            "time",
//            style: Theme.of(context).textTheme.body2.apply(color: Colors.grey),
//          ),
        ],
      ),
    );
  }
}
