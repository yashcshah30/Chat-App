import 'package:Chat/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, streamSnapShot) {
            if (streamSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapShot.data.documents;
            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) => MessageBubble(
                documents[index]['text'],
                documents[index]['username'],
                documents[index]['userImage'],
                documents[index]['userId'] == snapShot.data.uid,
                key: ValueKey(documents[index].documentID),
              ),
              itemCount: documents.length,
            );
          },
        );
      },
    );
  }
}
