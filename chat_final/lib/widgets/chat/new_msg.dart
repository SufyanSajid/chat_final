import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = TextEditingController();

  void selectAndSendImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    var _pickedImage;
    final pickedImageFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });

    //String fileName= U
    final ref =
        FirebaseStorage.instance.ref().child('chatImages').child('123.jpg');
    await ref.putFile(_pickedImage);
    final imageURl = await ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection('chats/p2IdEP4sStan3bNsJSHS/messages')
        .add({
      'text': imageURl,
      'createdAt': Timestamp.now(),
      'type': 'img',
      'userId': user!.uid,
    });
  }

  void _sendMsg() {
    User? user = FirebaseAuth.instance.currentUser;
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection('chats/p2IdEP4sStan3bNsJSHS/messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'type': 'text',
      'userId': user!.uid,
    });
    _enteredMessage = '';
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 30,
              left: 15,
              right: 5,
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(105, 92, 34, 1),
                borderRadius: BorderRadius.circular(20)),
            child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Enter your Message',
                    labelStyle: TextStyle(color: Colors.yellow),
                    suffixIcon: IconButton(
                        onPressed: selectAndSendImage,
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                        ))),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
                onSubmitted: (value) => value.trim().isEmpty ? null : _sendMsg),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            bottom: 30,
            right: 5,
          ),
          child: IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMsg,
            icon: Icon(
              Icons.send,
              color: Colors.yellow,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
