import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickerScreen extends StatefulWidget {
  const VideoPickerScreen({super.key});

  @override
  _VideoPickerScreenState createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  VideoPlayerController? _controller;
  File? _videoFile;

  Future<void> _pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
        _controller = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      });
    }
  }

  void _playPauseVideo() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_videoFile != null)
              SizedBox(
                height: 300,
                width: 300,
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              const Text('No video selected.'),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickVideo,
                  child: const Text('Pick Video'),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: _controller != null ? _playPauseVideo : null,
                  child: Text(
                      _controller?.value.isPlaying == true ? 'Pause' : 'Play'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
