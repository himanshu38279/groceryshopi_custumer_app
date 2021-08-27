import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/controllers/wallet_controller.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/services/location_service.dart';
import 'package:tbo_the_best_one/services/one_time_showcase.dart';
import 'package:tbo_the_best_one/services/push_notification_service.dart';
import 'package:tbo_the_best_one/utilities/shared_prefs.dart';
import 'package:tbo_the_best_one/views/home_page_screen.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getState();
  }

  void getState() async {
    // initialize current location
    Provider.of<LocationService>(context, listen: false).getCurrentLocation();

    // initialize shared prefs
    await SharedPrefs.initialize();

    // initialize firebase messaging
    await PushNotificationService.initialize();

    // initialize showcase
    await OneTimeShowcase.initialize();

    final _user = Provider.of<User>(context, listen: false);

    // force login for emulator
    // await _user.login(phoneNumber: "1234567890");

    // initialize user
    await _user.update();

    // initialize if user is logged in
    if (_user.isLoggedIn) {
      Provider.of<CartController>(context, listen: false).update();
      Provider.of<AddressController>(context, listen: false).update();
      Provider.of<WalletController>(context, listen: false).update();
    }

    Navigator.pushReplacementNamed(context, HomePage.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/app-logo.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 50),
              CustomLoader(color: Color(0xFFFEFBC6)),
            ],
          ),
        ),
      ),
    );
  }
}
