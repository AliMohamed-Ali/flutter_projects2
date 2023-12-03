import 'package:flutter/material.dart';
import 'package:flutter_pick_image/image_picker.dart';
import 'package:flutter_pick_image/video_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ImagePickerScreen(),
    );
  }
}
