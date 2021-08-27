import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/address_bottom_sheet.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/controllers/orders_controller.dart';

typedef _Fn = void Function();

class SimpleRecorder extends StatefulWidget {
  @override
  _SimpleRecorderState createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  final String _mPath = 'audio_order.aac';
  String recorded_path = "";
  @override
  void initState() {
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    _mRecorder.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  void record() async {
    _mRecorder
        .startRecorder(
      toFile: _mPath,
      //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder.stopRecorder().then((value) {
      setState(() {
        recorded_path = value;
        _mplaybackReady = true;
      });
    });
  }

  void play() async {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder.isStopped &&
        _mPlayer.isStopped);
    _mPlayer
        .startPlayer(
            fromURI: _mPath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer.stopPlayer().then((value) {
      setState(() {});
    });
  }

  _Fn getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return null;
    }
    return _mRecorder.isStopped ? record : stopRecorder;
  }

  _Fn getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      return null;
    }
    return _mPlayer.isStopped ? play : stopPlayer;
  }

  bool getPlayerState() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      return false;
    } else {
      return true;
    }
  }

  bool getRecorderState() {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return true;
    } else {
      return false;
    }
  }

  bool _isLoading = false;
  String address_id = "";
  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(3),
              height: 130,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    getRecorderState() ? Color(0xFFFEE2E2) : Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: getRecorderState()
                      ? Color(0xffDC2626)
                      : Color(0xff059669),
                  width: 2,
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: getRecorderFn(),
                      //color: Colors.white,
                      //disabledColor: Colors.grey,
                      child: Text(_mRecorder.isRecording ? 'Stop' : 'Record'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(_mRecorder.isRecording
                        ? 'Recording in progress'
                        : 'Recorder is stopped'),
                  ]),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(3),
              height: 130,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xff6B7280),
                  width: 2,
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: getPlaybackFn(),
                      //color: Colors.white,
                      //disabledColor: Colors.grey,
                      child: Text(_mPlayer.isPlaying ? 'Stop' : 'Play'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(_mPlayer.isPlaying
                        ? 'Playback in progress'
                        : 'Player is stopped'),
                  ]),
            ),
          ),
        ],
      );
    }

    return CustomLoadingScreen(
      isLoading: _isLoading,
      child: Scaffold(
        body: makeBody(),
        bottomNavigationBar: MyButton(
            text: "Submit",
            onTap: () async {
              final files = List<File>();
              files.add(File.fromUri(Uri.parse(recorded_path)));
              if (recorded_path.isNotEmpty) {
                Fluttertoast.showToast(msg: "Please select Address");
                  showBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddressBottomSheet(fileLatest: files,type:"audio");
                    },
                  );
              } else {
                Fluttertoast.showToast(msg: "Please record any audio");
              }
            }),
      ),
    );
  }

//   Future<File> _getFile() async {
//     final directory = await getTemporaryDirectory();
//     final file = File("${directory.path}/data.json");

//     final doesExist = await file.exists();

//     if(!doseExist)
//        file = await file.create();

//     return file;
// }

}
