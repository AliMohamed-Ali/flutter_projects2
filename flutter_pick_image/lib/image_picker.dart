import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final List<File> _images = [];

  Future _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),  
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_images.isEmpty)
              const Text('No images selected.')
            else
              Column(
                children: [
                  for (int i = 0; i < _images.length; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.file(
                          _images[i],
                          height: 100.0,
                          width: 100.0,
                        ),
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: () => _removeImage(i),
                          child: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                ],
              ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera),
              child: const Text('Take Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
