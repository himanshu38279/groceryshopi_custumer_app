import 'package:flutter/material.dart';

const String kRupeeSymbol = "₹";
const String kPlayStoreLink =
    "https://play.google.com/store/apps/details?id=com.ssoftwares.groceryshopi";

String accessToken;
String fcmToken;

const Color kAccentColor = Color(0xFF68A041);
const Color kAppBarColor = Color(0xFF85B92B); //wait addinhg colors
const Color kLightYellow = Color(0xFFFEFBC6);

final kAppTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'ProductSans',
).copyWith(
  primaryColor: kAccentColor,
  accentColor: kAccentColor,
  appBarTheme: AppBarTheme(
    color: kAppBarColor,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  iconTheme: IconThemeData(color: Colors.black),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    },
  ),
);
