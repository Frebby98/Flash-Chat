import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser _firebaseUser;
final _firestore = Firestore.instance;

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var textEditingController = TextEditingController();
  String messageText;
  final _auth = FirebaseAuth.instance;
   void getCurrentUser() async {
       final user = await _auth.currentUser();
       if (user != null) {
         _firebaseUser = user;
       }
   }


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void signOut() async{
    if(_firebaseUser != null){
      await _auth.signOut();
      Navigator.pushNamed(context, WelcomeScreen.id);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
//Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          // ignore: missing_return
            MessagesStream(),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textEditingController.clear();
                      //{
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': _firebaseUser.email
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(builder: (context, snapshot){
      if(!snapshot.hasData){
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      }
      final messages = snapshot.data.documents.reversed;
      List<MessageBubble> messageBubbles = [];
      for(var message in messages){
        final messageText = message.data['text'];
        final messageSender = message.data['sender'];
        final currentUser = _firebaseUser.email;
        final messageBubble = MessageBubble(text: messageText, sender: messageSender,
        isMe: currentUser == messageSender);
        messageBubbles.add(messageBubble);
      }
      return Expanded(
        flex: 1,
        child: ListView(
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: messageBubbles,
        ),
      );
    },
      stream: _firestore.collection('messages').snapshots(),
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  MessageBubble({this.text, this.sender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender, style: isMe ? TextStyle(color: Colors.black) :
              TextStyle(color: Colors.white)),
          Material(
            elevation: 5,
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
            : BorderRadius.only(topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(text, style: TextStyle(
                    fontSize: 15.0),),
              ),),
        ],
      ),
    );
  }
  }


