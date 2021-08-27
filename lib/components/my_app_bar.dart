import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/cart_icon.dart';
import 'package:tbo_the_best_one/views/about_this_release_screen.dart';
import 'package:tbo_the_best_one/views/about_us_screen.dart';
import 'package:tbo_the_best_one/views/login_screen.dart';
import 'package:tbo_the_best_one/views/my_cart_screen.dart';
import 'package:tbo_the_best_one/views/otp_screen.dart';
import 'package:tbo_the_best_one/views/place_order_screen.dart';
import 'package:tbo_the_best_one/views/search_page.dart';

class MyAppBar extends PreferredSize {
  final String screenId;
  final Widget title;

  const MyAppBar({
    @required this.screenId,
    this.title,
  });

  @override
  Size get preferredSize => Size.fromHeight(55);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title: this.title,
      actions: (screenId != LoginScreen.id &&
              screenId != AboutThisReleaseScreen.id &&
              screenId != AboutUsScreen.id &&
              screenId != PlaceOrderScreen.id &&
              screenId != OTPScreen.id)
          ? [
              if (screenId != SearchPage.id)
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(context, SearchPage.id);
                  },
                ),
              if (screenId != MyCart.id) CartIcon(),
            ]
          : null,
    );
  }
}
