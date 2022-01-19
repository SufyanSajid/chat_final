import 'package:chat_final/widgets/appbar.dart';
import 'package:chat_final/widgets/chat/messages.dart';
import 'package:chat_final/widgets/chat/new_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/images/bg.png',
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CustomAppbar(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Text(
                  'Alex Martin',
                  style: TextStyle(
                      color: Color.fromRGBO(241, 211, 33, 1),
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Text(
                  'Pro Client',
                  style: TextStyle(
                      color: Color.fromRGBO(241, 211, 33, 1),
                      fontStyle: FontStyle.italic),
                ),
              ),
              Expanded(
                child: Messages(),
              ),
              NewMessage(),
            ],
          ),
        ),
      ),
    );
  }
}

// AppBar(
//           actions: [
//             IconButton(
//               onPressed: () {
//                 FirebaseAuth.instance.signOut();
//               },
//               icon: Icon(Icons.logout),
//             ),
//           ],
//           title: const Center(
//             child: Text('Chat Screen'),
//           ),
//         ),