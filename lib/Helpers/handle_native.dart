import 'dart:io';

import 'package:flutter/services.dart';

// ignore: avoid_classes_with_only_static_members
class NativeMethod {
  static const MethodChannel sharedTextChannel =
      MethodChannel('com.app.yogitunes/sharedTextChannel');
  static const MethodChannel registermediaChannel =
      MethodChannel('com.app.yogitunes/registerMedia');
  static const MethodChannel intentChannel =
      MethodChannel('com.app.yogitunes/intentChannel');

  static Future<void> handleIntent() async {
    // final _intent = await sharedTextChannel.invokeMethod('getSharedText');
    // if (_intent != null) {
    //   debugPrint('IntentHandler: Result: $_intent');
    // } else {
    //   debugPrint('intent is null');
    // }
  }

  static Future<void> handleAudioIntent(String audioPath) async {
    if (await File(audioPath).exists()) {
      intentChannel.invokeMethod('openAudio', {'audioPath': audioPath});
    }
  }
}
