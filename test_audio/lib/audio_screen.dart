import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late FlutterSoundRecorder _recorder;
  bool _isRecording = false;
  bool _isPlaying = false;
  String _filePath = '';

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _recorder.closeRecorder();
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

  void _togglePlayPause() async {
    if (_isRecording) {
      await _recorder.stopRecorder();
    } else if (_isPlaying) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.play(DeviceFileSource(_filePath));
    }
    setState(() {
      _isPlaying = !_isPlaying;
      _isRecording = false;
    });
  }

  void _startRecording() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    try {
      await _recorder.openRecorder();
      String directory = (await getExternalStorageDirectory())!.path;
      _filePath = '$directory/recorded_audio.aac';
      await _recorder.startRecorder(toFile: _filePath);
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _filePath.isNotEmpty
                ? Text('Selected Audio: $_filePath')
                : const Text('No audio selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAudio,
              child: const Text(' pickAudio'),
            ),
            ElevatedButton(
              onPressed: _togglePlayPause,
              child: Text(_isPlaying ? 'Stop' : ' Play'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isRecording) {
                  _stopRecording();
                } else {
                  _startRecording();
                }
              },
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
