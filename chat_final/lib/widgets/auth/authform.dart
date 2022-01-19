import 'dart:io';

import 'package:chat_final/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

enum mode {
  signUp,
  login,
}

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isloading);

  final Function(
    String email,
    String pass,
    String userName,
    File userImageFile,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  bool isloading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isLogin = true;
  String _email = '';

  String _pass = '';

  String _username = '';
  late File _userImageFile;

  final _formkey = GlobalKey<FormState>();

  void _pickedImage(File imageFile) {
    _userImageFile = imageFile;
  }

  void _trysubmit() {
    var isvalid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please Pick an Image')));
    }
    if (isvalid) {
      _formkey.currentState!.save();
      widget.submitFn(
        _email.trim(),
        _pass.trim(),
        _username.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              16,
            ),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      imagePickerFn: _pickedImage,
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _email = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'invallid email address';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(label: Text('Email Addresss')),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      onSaved: (value) {
                        _username = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'must be  4 charchters';
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('Username'),
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    onSaved: (value) {
                      _pass = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'must be  7 characters';
                      }
                    },
                    decoration: InputDecoration(
                      label: Text('Password'),
                    ),
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: widget.isloading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _trysubmit,
                            child: Text(_isLogin ? 'Login' : 'SignUp'),
                          ),
                  ),
                  widget.isloading
                      ? CircularProgressIndicator()
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create new Account'
                              : 'Already have an Account'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
