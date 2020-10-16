import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';

class MessageStream extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.docs;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: FirebaseAuth.instance.currentUser.email == messageSender,
            );
            messageWidgets.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              children: messageWidgets,
              reverse: true,
            ),
          );
        }
        return null;
      },
    );
  }
}
