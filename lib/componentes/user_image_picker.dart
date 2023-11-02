import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class userImagePicker extends StatefulWidget {
  final void Function(File image) onImagePick;
  const userImagePicker({super.key, required this.onImagePick});

  @override
  State<userImagePicker> createState() => _userImagePickerState();
}

class _userImagePickerState extends State<userImagePicker> {
  File? _image;

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Galeria'),
                  onTap: () {
                    _pickImage1();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Câmera'),
                  onTap: () {
                    _pickImage2();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage1() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage != null)
      setState(() {
        _image = File(pickedImage.path);
      });
    widget.onImagePick(_image!);
  }

  Future<void> _pickImage2() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage != null)
      setState(() {
        _image = File(pickedImage.path);
      });
    widget.onImagePick(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        TextButton(
          onPressed: () => _showImagePicker(context),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: Color.fromARGB(255, 192, 40, 91),
              ),
              SizedBox(width: 10),
              Text('Adicionar imagem'),
            ],
          ),
        ),
      ],
    );
  }
}
