import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:flutter/material.dart';

popupLoader(BuildContext context, String message) {
  Dialog mainDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    child: Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.width / 2,
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: GradientContainer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 7,
                    width: MediaQuery.of(context).size.width / 7,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                      strokeWidth: 5,
                    ),
                  ),
                  Text(
                    message,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => WillPopScope(
      onWillPop: () async => false,
      child: mainDialog,
    ),
  );
}