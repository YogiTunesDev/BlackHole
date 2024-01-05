import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Widget emptyScreen(
  BuildContext context,
  int turns,
  String text1,
  double size1,
  String text2,
  double size2,
  String text3,
  double size3, {
  bool useWhite = false,
  bool useOfflineMode = false,
}) {
  // for offline status
  String offlineButtonText = 'Go to Downloads';
  String offlineButtonRoute = '/downloads';
  String message =
      'It appears your device is in offline mode. Please connect to the internet or use the button below to go to your downloads.';
  String? route = ModalRoute.of(context)?.settings.name;

  Future<bool> isConnected;

  Future<bool> connectivityCheck() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    return connectivityResult == ConnectivityResult.none ? false : true;
  }

  isConnected = connectivityCheck();

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      FutureBuilder<bool>(
        future: isConnected,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData &&
              snapshot.data == false &&
              useOfflineMode == true &&
              route != '/downloads') {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Text(
                        AppLocalizations.of(context)!.offlineMode,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 100,
                          color: useWhite
                              ? Colors.white
                              : Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.offlineModeMessage,
                          style: TextStyle(
                            fontSize: 60,
                            color: useWhite
                                ? Colors.white
                                : Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          text3,
                          style: TextStyle(
                            fontSize: size3,
                            fontWeight: FontWeight.w600,
                            color: useWhite ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 100,
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 18,
                          color: useWhite
                              ? Colors.white
                              : Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Center(
                          child: InkWell(
                            onTap: () async {
                              await Navigator.pushNamed(
                                  context, offlineButtonRoute);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: Center(
                                child: Text(
                                  offlineButtonText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotatedBox(
                quarterTurns: turns,
                child: Text(
                  text1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: size1,
                    color: useWhite
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    text2,
                    style: TextStyle(
                      fontSize: size2,
                      color: useWhite
                          ? Colors.white
                          : Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    text3,
                    style: TextStyle(
                      fontSize: size3,
                      fontWeight: FontWeight.w600,
                      color: useWhite ? Colors.white : null,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ],
  );
}
