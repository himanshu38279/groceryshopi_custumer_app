import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:tbo_the_best_one/views/search_page.dart';

class MySearchField extends StatefulWidget {
  final Color color;
  final bool autoFocus;
  final bool showPrefix;
  final bool showUnderline;
  final bool readOnly;
  final void Function(String) onChanged;
  final TextEditingController controller;

  const MySearchField({
    this.onChanged,
    this.color = Colors.black,
    this.autoFocus = false,
    this.showPrefix = true,
    this.showUnderline = false,
    this.readOnly = false,
    this.controller,
  });

  @override
  _MySearchFieldState createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  TextEditingController _controller = TextEditingController();
  bool _dialogPopped = false;

  StateSetter _stateSetter;

  // PLUGIN BUG: calls setRecognitionCompleteHandler twice
  int _onCompleteCallCount = 0;

  @override
  void initState() {
    this.initSpeechRecognizer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _speechRecognition?.cancel();
    super.dispose();
  }

  void initSpeechRecognizer() async {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) {
        print(result);
        setState(() => _isAvailable = result);
      },
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => _stateSetter(() => _controller.text = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      (speech) {
        _controller.text = speech;
        _onCompleteCallCount++;
        if (_onCompleteCallCount == 2) {
          _onCompleteCallCount = 0;
          if (!_dialogPopped) Navigator.pop(context);
        }
        setState(() => _isListening = false);
        return this.widget.onChanged(_controller.text);
      },
    );

    final granted = await Permission.microphone.isGranted;
    final res = await _speechRecognition.activate();
    if (!granted) {
      _isAvailable = false;
    } else
      _isAvailable = res;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.widget.controller ?? _controller,
      onTap: this.widget.readOnly
          ? () => Navigator.pushNamed(context, SearchPage.id)
          : null,
      onChanged: this.widget.onChanged,
      autofocus: widget.autoFocus,
      style: TextStyle(color: this.widget.color),
      decoration: InputDecoration(
        prefixIcon: widget.showPrefix
            ? Icon(
                Icons.search,
                size: 20,
                color: this.widget.color,
              )
            : null,
        suffixIcon: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.mic,
            size: 20,
            color: this.widget.color,
          ),
          onPressed: _isListening
              ? null
              : () async {
                  if (!_isAvailable) {
                    final status = await Permission.microphone.request();
                    if (status.isUndetermined)
                      _isAvailable =
                          await Permission.microphone.request().isGranted;
                    else if (status.isDenied)
                      Fluttertoast.showToast(
                          msg: "Microphone permission denied");
                    else if (status.isRestricted)
                      Fluttertoast.showToast(msg: "Microphone not available");
                    else if (status.isPermanentlyDenied) {
                      openAppSettings();
                      Fluttertoast.showToast(
                          msg: "Please enable microphone permission");
                    } else
                      // permission granted
                      _isAvailable = true;

                    setState(() {});
                  }

                  if (_isAvailable) _showVoiceDialog();
                },
        ),
        border:
            widget.showUnderline ? UnderlineInputBorder() : InputBorder.none,
        hintText: "Search for products",
        hintStyle: TextStyle(color: this.widget.color),
      ),
      readOnly: widget.readOnly,
      cursorColor: this.widget.color,
      textAlignVertical: TextAlignVertical.center,
    );
  }

  void _showVoiceDialog() {
    _isListening = true;
    _controller.clear();
    _dialogPopped = false;
    setState(() {});
    _speechRecognition.listen(locale: "en_US");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, _dialogSetState) {
            _stateSetter = _dialogSetState;
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      "assets/lottie/listening.json",
                      height: 250,
                    ),
                    FittedBox(
                      child: Text(
                        "Catching your voice",
                        style: TextStyle(fontFamily: 'Pacifico', fontSize: 22),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _controller.text ?? "",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) async {
      // dialog closed
      _isListening = false;
      _dialogPopped = true;
      await _speechRecognition?.stop();
      await _speechRecognition?.cancel();
      setState(() {});
    });
  }
}
