import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/my_button.dart';

import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber;
  String countryCode;

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: LoginScreen.id,
          title: Text("Login"),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login-background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                ),
                child: Column(
                  children: [
                    Text(
                      "We will send an SMS with a confirmation code to this number.",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: IntlPhoneField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        controller: _controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintText: "Enter mobile number",
                        ),
                        onChanged: (PhoneNumber phone) {
                          phoneNumber = phone.number;
                          countryCode = phone.countryCode;
                        },
                        initialCountryCode: "IN",
                        showDropdownIcon: false,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(height: 15),
                    MyButton(
                      text: "Log In",
                      width: double.infinity,
                      onTap: () async {
                        // print("done");
                        // print(phoneNumber);
                        if (phoneNumber == null || phoneNumber.trim() == "") {
                          Fluttertoast.showToast(
                            msg: "Please enter a valid phone number",
                          );
                        } else {
                          _controller.clear();
                          Navigator.pushNamed(
                            context,
                            OTPScreen.id,
                            arguments: {
                              'phoneNumber': phoneNumber,
                              'countryCode': countryCode,
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
