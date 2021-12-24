import 'dart:async';

import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool isLoading = false;
  late List<ProductDetails> products;
  late StreamSubscription<dynamic> _subscription;

  @override
  void initState() {
    fetchDate();

    super.initState();
  }

  Future<void> fetchDate() async {
    setState(() {
      isLoading = true;
    });

    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(List<PurchaseDetails>.from(
          List.from(purchaseDetailsList as Iterable<dynamic>)));
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });

    ///=========

    const Set<String> _kIds = <String>{
      'teachermth',
    };
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    await Future.delayed(const Duration(seconds: 2));
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
      print("Error ");
    }
    products = response.productDetails;
    if (products.isNotEmpty) {
      print(products[0].price);
    }
    print("products :: " + products.length.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GradientContainer(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Keep the music playing with the YogiTunes subscription.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      products[0].price,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final PurchaseParam purchaseParam =
                            PurchaseParam(productDetails: products[0]);

                        InAppPurchase.instance
                            .buyNonConsumable(purchaseParam: purchaseParam);
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
                            'Subscribe',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails) as bool;
          if (valid) {
            // _deliverProduct(purchaseDetails);
          } else {
            // _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }
}
