import 'dart:io';

import 'package:blackhole/Screens/Settings/subscription.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class SubscriptionStatus {
  SubscriptionStatus._();
  static final SubscriptionStatus instance = SubscriptionStatus._();
  static Future<bool> subscriptionStatus(String sku,
      [Duration duration = const Duration(days: 30),
      Duration grace = const Duration(days: 0)]) async {
    if (Platform.isIOS) {
      final history = await FlutterInappPurchase.instance.getPurchaseHistory();
      print("history :: ${history}");
      if (history != null) {
        for (var purchase in history) {
          print("history  --> :: ${purchase}");
          print("purchase.transactionDate :: ${purchase.transactionDate}");
          Duration difference =
              DateTime.now().difference(purchase.transactionDate!);
          if (difference.inMinutes <= (duration + grace).inMinutes &&
              purchase.productId == sku) return true;
        }
      }
      return false;
    } else if (Platform.isAndroid) {
      List<PurchasedItem>? purchases =
          await FlutterInappPurchase.instance.getAvailablePurchases();
      print("purchases :: ${purchases}");
      if (purchases != null) {
        for (var purchase in purchases) {
          if (purchase.productId == sku) return true;
        }
      }
      return false;
    }
    throw PlatformException(
        code: Platform.operatingSystem, message: "platform not supported");
  }
}
