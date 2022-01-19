import 'dart:io';

import 'package:chat_final/widgets/auth/authform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLoding = false;

  void _submitAuthForm(
    String email,
    String pass,
    String userName,
    File userImageFile,
    bool islogin,
    BuildContext ctx,
  ) async {
    setState(() {
      isLoding = true;
    });
    UserCredential? _authResult;
    try {
      print(islogin);
      if (islogin) {
        _authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass);
        setState(() {
          isLoding = false;
        });
      } else {
        _authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);

        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child(_authResult.user!.uid + '.jpg');
        await ref
            .putFile(
              userImageFile,
            )
            .whenComplete(() => print('uploaded'));

        final imageUrl = await ref.getDownloadURL();
        print(imageUrl);

        await FirebaseFirestore.instance
            .collection('user')
            .doc(_authResult.user!.uid)
            .set({
          'name': userName,
          'email': email,
          'imageUrl': imageUrl,
        }).then((value) => print('Data updated'));
        setState(() {
          isLoding = false;
        });
      }
    } on PlatformException catch (error) {
      setState(() {
        isLoding = false;
      });
      var message = 'An error Occurred ! Please Check your credentionals';

      if (error.message != null) {
        message = error.message!;
      }
      showDialog(
          context: (ctx),
          builder: (ctx) => AlertDialog(
                title: const Text('An Error Occurred'),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text(
                      'Okay!',
                    ),
                  ),
                ],
              ));
    } catch (err) {
      // setState(() {
      //   isLoding = false;
      // });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm((_submitAuthForm), isLoding),
    );
  }
}
