import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/views/home_page_screen.dart';

class MyRewardsScreen extends StatelessWidget {
  static const id = 'my_rewards_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: id,
          title: Text("My Gifts"),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your rewards will appear here",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Keep shopping on The Best One to earn awesome rewards",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () => Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.id,
            (route) => false,
          ),
          child: Container(
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.all(10),
            child: Text(
              "Start Shopping",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
