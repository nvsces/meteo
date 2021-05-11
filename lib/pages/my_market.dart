import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class MyMarket extends StatefulWidget {
  MyMarket();

  @override
  _MyMarketState createState() => _MyMarketState();
}

class _MyMarketState extends State<MyMarket> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Продукты для продажи
  List<ProductDetails> _products = [];

  /// Прошлые покупки
  List<PurchaseDetails> _purchases = [];

  /// Обновления для покупок
  StreamSubscription _subscription;

  final String testID = 'subscription';

  void _initialize() async {
    _getProducts();
    _getPastPurchases();

    // Слушайте новые покупки
    _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
          print(data);
          print('NEW PURCHASE');
          _purchases.addAll(data);
          _verifyPurchase();
        }));
  }

  /// Ваша собственная бизнес-логика для настройки расходного материала
  void _verifyPurchase() {
    PurchaseDetails purchase = _purchases.firstWhere(
      (purchase) => purchase.productID == testID,
      orElse: () => _purchases[0],
    );
    // Проверка на стороне сервера TODO и запись расходных материалов в базу данных

    if (purchase.status == PurchaseStatus.purchased) {
      print('Всё ок, платёж прошёл');
    } else if (purchase.status == PurchaseStatus.error) {
      print("Ошибка покупки");
    } else {
      print("Платёж обрабатывается");
    }
  }

  /// Получить прошлые покупки
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.completePurchase(purchase);
      }
    }

    setState(() {
      _purchases = response.pastPurchases;
      if (_purchases.isNotEmpty) print(_purchases[0].toString());
      print(_purchases);
    });
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  /// Получите все продукты, доступные для продажи
  Future<void> _getProducts() async {
    Set<String> ids = {testID};
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
      print(_products);
      //print(_purchases);
    });
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Купить Товар')),
                for (var prod in _products) ...[
                  Text(prod.title),
                  ElevatedButton(
                    onPressed: () => _buyProduct(prod),
                    child: Text(prod.price),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
