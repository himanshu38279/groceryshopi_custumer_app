import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';

void showMyAlertDialog(
  BuildContext context, {
  @required String title,
  @required String content,
  @required VoidCallback continueButtonOnPressed,
}) {
  showDialog(
    context: context,
    builder: (context) => _MyAlertDialog(
      title: title,
      content: content,
      continueButtonOnPressed: continueButtonOnPressed,
    ),
  );
}

class _MyAlertDialog extends StatelessWidget {
  final String title, content;
  final Function continueButtonOnPressed;

  _MyAlertDialog({
    @required this.title,
    @required this.content,
    @required this.continueButtonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomLoadingScreen(
      child: AlertDialog(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("$content\n\nThis action is irreversible !"),
          ],
        ),
        actions: [
          FlatButton(
            textColor: Theme.of(context).accentColor,
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            textColor: Theme
                .of(context)
                .accentColor,
            child: Text("Continue"),
            onPressed: continueButtonOnPressed,
          ),
        ],
      ),
    );
  }
}
