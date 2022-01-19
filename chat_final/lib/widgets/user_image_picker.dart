import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({required this.imagePickerFn});
  final void Function(File imageFile) imagePickerFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  var _pickedImage;

  Future<void> imagePicker() async {
    final pickedImageFile =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickerFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage as File) : null,
        ),
        TextButton.icon(
          onPressed: imagePicker,
          icon: const Icon(Icons.preview),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
