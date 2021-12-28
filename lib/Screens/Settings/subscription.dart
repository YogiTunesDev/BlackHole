import 'dart:async';
import 'dart:io';

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
  List<String> lstStr = [
    'A personal library for your favourite music Simple tools to create your own yoga playlist',
    'Largest selection of yoga music from artists around the world.',
    "Curated playlists by top global yoga dj's",
    'Offline streaming',
    'Ad free',
    'High quality audio',
    'Performance rights',
  ];

  List<String> lstDescription = [
    'YogiTunes will enable an auto-renewing subscription, with the following standard iTunes terms:',
    '· Payment will be charged to iTunes Account at confirmation of purchase.',
    '· Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.',
    '· Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal.',
    "· Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase.",
    '· Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.'
  ];
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

    Set<String> _kIds;
    if (Platform.isIOS) {
      _kIds = <String>{
        'com.yogitunes.subscription.monthly',
      };
    } else {
      _kIds = <String>{
        'teachermth',
      };
    }
    print('_kIds :: ${_kIds}');
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    await Future.delayed(const Duration(seconds: 2));
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
      print('Error ');
    }
    products = response.productDetails;
    if (products.isNotEmpty) {
      print(products[0].price);
    }
    print('products :: ' + products.length.toString());
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
      child: GradientContainer(
        child: Scaffold(
          appBar: AppBar(),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lstStr.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.check, color: Colors.green),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      lstStr[index],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lstDescription.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                lstDescription[index],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        if (products.isNotEmpty)
                          Text(
                            'You will be charges at ' + products[0].price,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        if (products.isNotEmpty)
                          InkWell(
                            onTap: () async {
                              final PurchaseParam purchaseParam =
                                  PurchaseParam(productDetails: products[0]);

                              InAppPurchase.instance.buyNonConsumable(
                                  purchaseParam: purchaseParam);
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
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
