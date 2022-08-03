import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          isLoading = true;
        });

        redirectAfterAuthentication(context);
        ;
      } catch (e, stack) {
        print(e.toString());
        debugPrint(stack.toString());
      } finally {}
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/splash_white.png'
                      : 'assets/splash.png',
                  cacheHeight: 300,
                  cacheWidth: 1000,
                ),
                // const Center(
                //   child: CircularProgressIndicator(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> redirectAfterAuthentication(BuildContext context) async {
  print(" apiTokenBox.get('token')  ->" + apiTokenBox.get('token').toString());

  if (apiTokenBox.get('token') != null) {
    // bool val = await SubscriptionStatus.subscriptionStatus(
    //     Platform.isIOS ? iosInAppPackage : androidInAppPackage,
    //     const Duration(days: 30),
    //     const Duration(days: 0));
    // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    // return;
    final subscriptionStatusResponse =
        await YogitunesAPI().subscriptionStatus();
    if (subscriptionStatusResponse != null) {
      if (subscriptionStatusResponse.status ?? false) {
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
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
