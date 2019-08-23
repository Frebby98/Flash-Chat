import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
final bool isMe;
  MessageBubble({this.text, this.sender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding:  EdgeInsets.fromLTRB(70, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(sender, style: TextStyle(color: Colors.black),),
          Material(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(text, style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0),),
            ),),
        ],
      ),
    );
  }
}
