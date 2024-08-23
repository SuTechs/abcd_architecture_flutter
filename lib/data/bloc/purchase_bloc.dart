import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum StoreState {
  loading,
  available,
  notAvailable,
}

const storeKeyPremium = 'premium_subscription';

class PurchaseBloc extends ChangeNotifier {
  static final InAppPurchase _iap = InAppPurchase.instance;

  //
  StoreState storeState = StoreState.loading;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];

  List<ProductDetails> get products => _products;

  // network
  late StreamSubscription<List<ConnectivityResult>> _networkSubscription;
  bool _isOffline = true;

  bool get isOffline => _isOffline;

  /// Constructor
  PurchaseBloc() {
    _initialize();
  }

  /// Initialize
  void _initialize() {
    try {
      _subscription = _iap.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: _updateStreamOnDone,
        onError: _updateStreamOnError,
      );

      loadProducts();
      restorePurchases();

      _networkSubscription = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> result) {
        try {
          final oldState = _isOffline;
          _isOffline = result.contains(ConnectivityResult.none);

          if (oldState && !_isOffline && _products.isEmpty) {
            loadProducts();
          }

          notifyListeners();
        } catch (e) {
          debugPrint('Error in network listener: $e');
        }
      });
    } catch (e) {
      debugPrint('Error in _initialize: $e');
    }
  }

  /// restore purchases
  void restorePurchases() {
    try {
      _iap.restorePurchases().then((_) {
        debugPrint('Restore Purchase Done');
      }).catchError((error) {
        debugPrint('Error restoring purchases: $error');
      });
    } catch (e) {
      debugPrint('Error in restorePurchases: $e');
    }
  }

  ///  Load all products
  Future<void> loadProducts() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        storeState = StoreState.notAvailable;
        notifyListeners();
        return;
      }

      final response = await _iap.queryProductDetails({storeKeyPremium});

      debugPrint('\nProduct Details: ${response.productDetails}');
      debugPrint('Load Products Response: ######################');
      if (response.productDetails.isNotEmpty) {
        for (final ProductDetails p in response.productDetails) {
          debugPrint("Product ID: ${p.id}\n"
              "Title: ${p.title}\n"
              "Description: ${p.description}\n"
              "Price: ${p.price}\n"
              "Currency: ${p.currencyCode}\n"
              "Symbol: ${p.currencySymbol}\n"
              "----------------------");
        }
      }
      debugPrint('Not Found IDs: ${response.notFoundIDs}');
      debugPrint('Error: ${response.error}');
      debugPrint('End Load Purchases Response:######################\n');

      _products = List.from(response.productDetails);
      storeState = StoreState.available;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in loadProducts: $e');
      storeState = StoreState.notAvailable;
      notifyListeners();
    }
  }

  /// Handle purchase
  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    try {
      debugPrint("\nPurchase Details List: $purchaseDetailsList\n");

      for (var purchaseDetails in purchaseDetailsList) {
        await _handlePurchase(purchaseDetails);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error in _onPurchaseUpdate: $e');
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    try {
      debugPrint("Purchase Details: ID ${purchaseDetails.purchaseID}\n"
          "Status: ${purchaseDetails.status}\n"
          "Product ID: ${purchaseDetails.productID}\n"
          "Transaction Date: ${purchaseDetails.transactionDate}\n"
          "Local Verification Data: ${purchaseDetails.verificationData.localVerificationData}\n"
          "Server Verification Data: ${purchaseDetails.verificationData.serverVerificationData}\n"
          "Verification Source: ${purchaseDetails.verificationData.source}");

      /// handle the purchased product
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // verify the purchase from the server
        // final valid = await verifyPurchase(purchaseDetails);
        // if (valid) {} -> for now skipping the verification

        debugPrint(
            '######### -----  Purchase Verified: ${purchaseDetails.productID} ----- #########');

        // handle the purchase
        switch (purchaseDetails.productID) {
          case storeKeyPremium:
            _applyPremium();
          // handle subscription
          // monthly
          // yearly
        }
      }

      /// handle the restored purchase
      if (purchaseDetails.status == PurchaseStatus.restored) {
        // handle the restored purchase
        debugPrint('Restored Purchase: ${purchaseDetails.productID}');
        _applyPremium();
      }

      /// handle the pending purchase
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    } catch (e) {
      debugPrint('Error in _handlePurchase: $e');
    }
  }

  /// Buy product (subscription)
  Future<void> buyProduct(ProductDetails product) async {
    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Error in buyProduct: $e');
    }
  }

  @override
  void dispose() {
    try {
      _subscription.cancel();
      _networkSubscription.cancel();
      super.dispose();
    } catch (e) {
      debugPrint('Error in dispose: $e');
    }
  }

  void _updateStreamOnDone() {
    try {
      _subscription.cancel();
    } catch (e) {
      debugPrint('Error in _updateStreamOnDone: $e');
    }
  }

  void _updateStreamOnError(dynamic error) {
    debugPrint('Error In Purchase Stream #332: $error');
  }

  /// Premium Subscription

  bool _isPremium = false;

  bool get isPremium => _isPremium;

  void _applyPremium() {
    try {
      _isPremium = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in _applyPremium: $e');
    }
  }
}
