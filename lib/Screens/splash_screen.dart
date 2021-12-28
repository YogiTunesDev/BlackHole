import 'dart:io';

import 'package:blackhole/Services/subscription_status.dart';
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
    // bool val = await SubscriptionStatus.subscriptionStatus(
    //     Platform.isIOS ? 'com.yogitunes.subscription.monthly' : 'teachermth',
    //     const Duration(days: 30),
    //     const Duration(days: 0));
    // if (val) {
    Navigator.pushNamed(context, '/home');
    // } else {
    //   Navigator.pushNamed(context, '/subscription', arguments: {
    //     'isFirstTime': true,
    //   });
    // }
    // return HomePage();
  } else {
    Navigator.pushNamed(context, '/login');
    // return AuthScreen();
  }
}
