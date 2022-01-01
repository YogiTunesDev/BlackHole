import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/model/subscription_status_response.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      try {
        setState(() {
          isLoading = true;
        });
        await Future.delayed(Duration(seconds: 5));
        redirectAfterAuthentication(context);
      } catch (e, stack) {
        print(e.toString());
        debugPrint(stack.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/splash.png'),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
        : Container();
  }
}

Future<void> redirectAfterAuthentication(BuildContext context) async {
  print(" apiTokenBox.get('token')  ->" + apiTokenBox.get('token').toString());
  SubscriptionStatusResponse? subscriptionStatusResponse =
      await YogitunesAPI().subscriptionStatus();
  if (apiTokenBox.get('token') != null) {
    // bool val = await SubscriptionStatus.subscriptionStatus(
    //     Platform.isIOS ? iosInAppPackage : androidInAppPackage,
    //     const Duration(days: 30),
    //     const Duration(days: 0));
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return;
    if (subscriptionStatusResponse != null) {
      if (subscriptionStatusResponse.status!) {
        if (subscriptionStatusResponse.validMobileSubscription ?? false) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/subscription', (route) => false,
              arguments: {
                'isFirstTime': true,
              });
          // Navigator.pushNamed(context, '/subscription');
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/subscription', (route) => false,
            arguments: {
              'isFirstTime': true,
            });
        // Navigator.pushNamed(context, '/subscription');
      }
    } else {
      // Navigator.pushNamedAndRemoveUntil(
      //     context, '/subscription', (route) => false,
      //     arguments: {
      //       'isFirstTime': true,
      //     });
    }
    // return HomePage();
  } else {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    // Navigator.pushNamed(context, '/login');
    // return AuthScreen();
  }
}
