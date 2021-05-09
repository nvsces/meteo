import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

final String testID = 'product_test';

class MarketScreen extends StatefulWidget {
  createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription _subscription;

  /// Consumable credits the user can buy
  int _credits = 0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Initialize data

  /// Initialize data
  void _initialize() async {
    // ... omitted

    // Listen to new purchases
    _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
          print(data);
          print('NEW PURCHASE');
          _purchases.addAll(data);
          _verifyPurchase();
        }));
  }

  void _spendCredits(PurchaseDetails purchase) async {
    /// Decrement credits
    setState(() {
      _credits--;
    });

    /// TODO update the state of the consumable to a backend database

    // Mark consumed when credits run out
    if (_credits == 0) {
      var res = await _iap.consumePurchase(purchase);
      await _getPastPurchases();
    }
  }

  /// Purchase a product
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  /// Get all products available for sale
  Future<void> _getProducts() async {
    //Set<String> ids = Set.from([testID, 'test_a']);
    Set<String> ids = {testID, 'pr_1'};
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
      print(_purchases);
    });
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.completePurchase(purchase);
      }
    }

    setState(() {
      _purchases = response.pastPurchases;
      print(_purchases);
    });
  }

  /// Returns purchase of specific product ID
  bool _hasPurchased(String productID) {
    if (_purchases.isEmpty) {
      return false;
    } else
      return true;
    // var purchas= _purchases.firstWhere(
    //   (purchase) => purchase.productID == productID,
    //   orElse: ()=>flag=true;
    // );
  }

  /// Your own business logic to setup a consumable
  void _verifyPurchase() {
    PurchaseDetails purchase =
        // _hasPurchased(testID);
        _purchases.firstWhere(
      (purchase) => purchase.productID == testID,
    );
    // TODO serverside verification & record consumable in the database

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      _credits = 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(available ? 'Open for Business' : 'Not Available'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Test'),
              ElevatedButton(
                  onPressed: () {
                    _getPastPurchases();
                    _getProducts();
                  },
                  child: Text('Получить товар')),
              for (var prod in _products)

                // UI if already purchased
                if (_hasPurchased(prod.id)) ...[
                  Text(' $_credits', style: TextStyle(fontSize: 60)),
                  FlatButton(
                      child: Text('Consume'),
                      color: Colors.green,
                      onPressed: null
                      // _spendCredits(_hasPurchased(prod.id)),
                      )
                ]

                // UI if NOT purchased
                else ...[
                  Text(prod.title),
                  Text(prod.description),
                  Text(prod.price,
                      style:
                          TextStyle(color: Colors.greenAccent, fontSize: 60)),
                  FlatButton(
                    child: Text('Buy It'),
                    color: Colors.green,
                    onPressed: () => _buyProduct(prod),
                  ),
                ]
            ],
          ),
        ),
      ),
    );
  }
  // Private methods go here

}
