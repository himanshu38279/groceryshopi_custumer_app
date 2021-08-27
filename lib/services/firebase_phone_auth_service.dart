import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';
import 'package:tbo_the_best_one/controllers/orders_controller.dart';
import 'package:tbo_the_best_one/controllers/products_controller.dart';
import 'package:tbo_the_best_one/controllers/wallet_controller.dart';
import 'package:tbo_the_best_one/models/user.dart' as MyUser;

class FirebasePhoneAuthService extends ChangeNotifier {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  String _phoneNumber;
  String _countryCode;
  String _verificationId;
  Timer _timer;
  bool codeSent = false;

  int get timerCount => _timeoutDuration.inSeconds - _timer?.tick ?? 0;

  bool get timerIsActive => _timer?.isActive ?? false;
  static const _timeoutDuration = const Duration(seconds: 60);

  Future<void> validatePhoneNumberWithOTP({
    @required BuildContext context,
    @required String otp,
  }) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: otp,
    );
    await loginUser(context, authCredential: credential);
  }

  void clear() {
    this.codeSent = false;
    _timer?.cancel();
    _timer = null;
    _phoneNumber = null;
    _countryCode = null;
    _verificationId = null;
  }

  Future<void> initAuth({
    @required BuildContext context,
    @required String phoneNumber,
    @required String countryCode,
  }) async {
    this.clear();
    _phoneNumber = phoneNumber;
    _countryCode = countryCode;

    this.codeSent = false;
    await Future.delayed(Duration.zero, () {
      notifyListeners();
    });

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) async {
      Fluttertoast.showToast(
        msg: "Auto fetched OTP. Logging in",
        gravity: ToastGravity.CENTER,
      );
      await loginUser(context, authCredential: authCredential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      Fluttertoast.showToast(
        msg: "An error occurred. Please check the number or try again later",
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
      );
      Navigator.pop(context);
      print('Auth Exception is ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Provider.of<LoadingController>(context, listen: false).stopLoading();
      _verificationId = verificationId;
      print("code sent ");
      Fluttertoast.showToast(msg: "Code sent successfully");

      this.codeSent = true;
      notifyListeners();

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timer.tick == _timeoutDuration.inSeconds) _timer.cancel();
        notifyListeners();
      });
      notifyListeners();
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      Provider.of<LoadingController>(context, listen: false).stopLoading();
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "$_countryCode$_phoneNumber",
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: _timeoutDuration,
      );
    } catch (e) {
      print(e);
    } finally {
      Provider.of<LoadingController>(context, listen: false).stopLoading();
    }
  }

  Future<void> loginUser(
    BuildContext context, {
    PhoneAuthCredential authCredential,
  }) async {
    Provider.of<LoadingController>(context, listen: false).startLoading();
    try {
      final authResult = await _auth.signInWithCredential(authCredential);
      if (authResult?.user != null) {
        final success =
            await Provider.of<MyUser.User>(context, listen: false).login(
          phoneNumber: _phoneNumber,
        );
        if (success) {
          FocusScope.of(context).unfocus();
          await Future.wait([
            Provider.of<CartController>(context, listen: false).update(),
            Provider.of<AddressController>(context, listen: false).update(),
            Provider.of<OrdersController>(context, listen: false).update(),
            Provider.of<ProductsController>(context, listen: false).update(),
            Provider.of<WalletController>(context, listen: false).update(),
          ]);
          Fluttertoast.showToast(msg: "Logged in successfully");
          // pop OTPScreen
          Navigator.pop(context);
          // pop LoginScreen
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: "An error occurred while logging in");
        }
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Please enter a valid OTP");
    } finally {
      Provider.of<LoadingController>(context, listen: false).stopLoading();
    }
  }

  Future<void> updateUserprofile({
    @required BuildContext context,
    @required String name,
    @required String email,
  }) async {
    User _user = _auth.currentUser;
    Provider.of<LoadingController>(context, listen: false).startLoading();
    try {
      await _user.updateProfile(displayName: name);
      // _user.updateEmail(email);

      final AuthCredential credential = AuthCredential(
        providerId: PhoneAuthProvider.PROVIDER_ID,
        signInMethod: PhoneAuthProvider.PHONE_SIGN_IN_METHOD,
      );

      await _user.reauthenticateWithCredential(credential);
      await _user.reload();

      Provider.of<LoadingController>(context, listen: false).stopLoading();
    } catch (e) {
      print(e);
    } finally {
      Provider.of<LoadingController>(context, listen: false).stopLoading();
    }
  }

  Future<void> signOut() async {
    this.clear();
    await _auth.signOut();
    notifyListeners();
  }
}
