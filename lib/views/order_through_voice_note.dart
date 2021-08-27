import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tbo_the_best_one/views/simple_player.dart';

class OrderThroughVoiceNote extends StatefulWidget {
  static const id = 'order_through_voice_notes';

  @override
  _OrderThroughVoiceNoteState createState() => _OrderThroughVoiceNoteState();
}

class _OrderThroughVoiceNoteState extends State<OrderThroughVoiceNote>
    with SingleTickerProviderStateMixin {
  final flutterSound = FlutterSoundRecorder();
  final soundPlayer = FlutterSoundPlayer();
final String address_id = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Color _color = Colors.grey[500];
  bool isRecording = false;

  Future<void> changeColorController;
  @override
  void dispose() {
    super.dispose();
  }

  bool disposed = false;

  String recorderAudioPath = "foo";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Order Through Voice Note"),
        ),
        body: SimpleRecorder(),
      ),
    );
  }

  void recordAudio() async {
    // Request Microphone permission if needed
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted)
      throw RecordingPermissionException("Microphone permission not granted");

    await flutterSound.startRecorder(
      toFile: 'temp',
    ); // A temporary file named 'foo'
  }

  void stopRecording() async {
    await flutterSound.stopRecorder().then((value) => {flutterSound});
  }
}
