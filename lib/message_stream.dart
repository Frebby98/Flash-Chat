import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';

final Firestore _firestore = Firestore.instance;
FirebaseUser _firebaseUser;

class MessagesStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      }

      final messages = snapshot.data.documents.reversed;
      List<MessageBubble> messageBubbles = [];
      for (var message in messages) {
        final messageText = message.data['text'];
        final messageSender = message.data['sender'];
        var currentUser = _firebaseUser.email;
        final messageBubble = MessageBubble(
          text: messageText, sender: messageSender,
          isMe: currentUser == messageSender,);
        messageBubbles.add(messageBubble);
      }
      return Expanded(
        flex: 1,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: messageBubbles,
        ),
      );
    },
      stream: _firestore.collection('messages').snapshots(),
    );
  }
}