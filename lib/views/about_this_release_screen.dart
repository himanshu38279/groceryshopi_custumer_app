import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';

class AboutThisReleaseScreen extends StatelessWidget {
  static const id = 'about_this_release';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: id,
          title: Text("About This Release"),
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Text(
              "Non-members can now avail SBC membership directly by tapping on the lock strip shown below of every product\n",
            ),
            Text(
              "We have made it easy to initiate new searches for frequently bought together items.",
            ),
          ],
        ),
      ),
    );
  }
}
