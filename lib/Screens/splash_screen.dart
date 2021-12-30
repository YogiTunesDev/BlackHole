import 'dart:io';

import 'package:blackhole/Services/subscription_status.dart';
import 'package:blackhole/util/const.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      redirectAfterAuthentication(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void redirectAfterAuthentication(BuildContext context) async {
  print(" apiTokenBox.get('token')  ->" + apiTokenBox.get('token').toString());
  if (apiTokenBox.get('token') != null) {
    bool val = await SubscriptionStatus.subscriptionStatus(
        Platform.isIOS ? iosInAppPackage : androidInAppPackage,
        const Duration(days: 30),
        const Duration(days: 0));
    if (val) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, '/subscription', (route) => false,
          arguments: {
            'isFirstTime': true,
          });
      // Navigator.pushNamed(context, '/subscription');
    }
    // return HomePage();
  } else {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    // Navigator.pushNamed(context, '/login');
    // return AuthScreen();
  }
}
