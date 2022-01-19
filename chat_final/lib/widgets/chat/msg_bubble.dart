import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.msg,
    required this.isMe,
    required this.key,
    required this.type,
    required this.userId,
  });
  String msg;
  bool isMe;
  String? userId;
  String type;
  Key key;
  @override
  Widget build(BuildContext context) {
    print(userId);
    return type == 'text'
        ? Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                //  height: 60,
                width: 240,
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 15,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isMe ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomRight: !isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(0),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('user')
                                .doc(userId)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapShot) {
                              return Text(
                                'UserName',
                                //  snapShot.data['name'],
                                style: TextStyle(
                                    color: isMe ? Colors.black : Colors.white),
                              );
                            }),
                        Text('8:02'),
                      ],
                    ),
                    Text(
                      msg,
                      style:
                          TextStyle(color: isMe ? Colors.black : Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                width: 240,
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 15,
                ),
                height: 100,
                decoration: BoxDecoration(
                  color: isMe ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomRight: !isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(0),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(0)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomRight: !isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(0),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(0)),
                  child: msg == ''
                      ? Center(
                          child:
                              CircularProgressIndicator(color: Colors.orange))
                      : Image.network(
                          msg,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          );
  }
}
