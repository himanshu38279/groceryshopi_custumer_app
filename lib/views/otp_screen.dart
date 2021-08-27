import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_text_field.dart';
import 'package:tbo_the_best_one/services/firebase_phone_auth_service.dart';

class OTPScreen extends StatefulWidget {
  static const id = 'otp_screen';
  final String phoneNumber;
  final String countryCode;

  const OTPScreen({
    @required this.phoneNumber,
    @required this.countryCode,
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String enteredOTP;

  FirebasePhoneAuthService _phoneAuthService;

  @override
  void initState() {
    print("called init");
    Provider.of<FirebasePhoneAuthService>(context, listen: false).initAuth(
      context: context,
      phoneNumber: widget.phoneNumber,
      countryCode: widget.countryCode,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _phoneAuthService = Provider.of<FirebasePhoneAuthService>(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          _phoneAuthService.clear();
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Verification Code"),
            actions: _phoneAuthService.codeSent
                ? [
                    TextButton(
                      child: Text(
                        _phoneAuthService.timerIsActive
                            ? "${_phoneAuthService.timerCount}s"
                            : "RESEND",
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                      onPressed: _phoneAuthService.timerIsActive
                          ? null
                          : () async {
                              await _phoneAuthService.initAuth(
                                context: context,
                                phoneNumber: widget.phoneNumber,
                                countryCode: widget.countryCode,
                              );
                            },
                    ),
                    SizedBox(width: 5),
                  ]
                : null,
          ),
          body: _phoneAuthService.codeSent
              ? CustomLoadingScreen(
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      Text(
                        "We've sent an SMS with a verification code to ${widget.countryCode}${widget.phoneNumber}",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        height: _phoneAuthService.timerIsActive ? null : 0,
                        child: Column(
                          children: [
                            SpinKitWave(color: Theme.of(context).accentColor),
                            SizedBox(height: 50),
                            Text(
                              "Listening for OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Divider(),
                            Text(
                              "OR",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Pacifico'),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                      Text(
                        "Enter Code Manually",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      MyTextField(
                        labelText: "OTP",
                        maxLength: 6,
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 30,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (String v) async {
                          this.enteredOTP = v;
                          if (this.enteredOTP.length == 6)
                            await _phoneAuthService.validatePhoneNumberWithOTP(
                              context: context,
                              otp: enteredOTP,
                            );
                        },
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SpinKitWave(color: Theme.of(context).accentColor),
                    SizedBox(height: 50),
                    Text(
                      "Sending OTP",
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
          floatingActionButton: _phoneAuthService.codeSent
              ? FloatingActionButton(
                  backgroundColor: Theme.of(context).accentColor,
                  child: Icon(Icons.check),
                  onPressed: () async {
                    if (enteredOTP == null || enteredOTP.length != 6) {
                      Fluttertoast.showToast(msg: "Please enter a valid OTP");
                    } else
                      await _phoneAuthService.validatePhoneNumberWithOTP(
                        context: context,
                        otp: enteredOTP,
                      );
                  },
                )
              : null,
        ),
      ),
    );
  }
}
