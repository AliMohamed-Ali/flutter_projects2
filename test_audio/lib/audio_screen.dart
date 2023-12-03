import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _filePath = '';

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      setState(() {
        _filePath = filePath;
      });
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.stop();
    } else {
      _audioPlayer.play(DeviceFileSource(_filePath));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // void _playAudio(String filePath) {
  //   if (_isPlaying) {
  //     _audioPlayer.stop();
  //     setState(() {
  //       _isPlaying = false;
  //     });
  //   } else {
  //     _audioPlayer.play(DeviceFileSource(filePath));
  //     setState(() {
  //       _isPlaying = true;
  //       _filePath = filePath;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _filePath.isNotEmpty
                ? Text('Selected Audio: $_filePath')
                : Text('No audio selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAudio,
              child: Text(' pickAudio'),
            ),
            ElevatedButton(
              onPressed: _togglePlayPause,
              child: Text(_isPlaying ? 'Stop' : ' Play'),
            ),
          ],
        ),
      ),
    );
  }
}
