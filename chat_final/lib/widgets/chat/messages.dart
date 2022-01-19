import 'package:chat_final/widgets/chat/msg_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats/p2IdEP4sStan3bNsJSHS/messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final chatDocs = snapShot.data!.docs;
        final User? userData = FirebaseAuth.instance.currentUser;
        return Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(12),
          height: 600,
          decoration: BoxDecoration(
              // color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              type: chatDocs[index]['type'],
              msg: chatDocs[index]['text'],
              isMe: chatDocs[index]['userId'] == userData!.uid,
              key: ValueKey(
                chatDocs[index].id,
              ),
              userId: userData.uid,
            ),
          ),
        );
      },
    );
  }
}
