import 'package:in_app_purchase/in_app_purchase.dart';

import '../commands.dart';

class PurchaseCommand extends BaseAppCommand {
  Future<void> loadProducts() => purchaseBloc.loadProducts();

  Future<void> buyProduct(ProductDetails product) =>
      purchaseBloc.buyProduct(product);

  void restorePurchases() => purchaseBloc.restorePurchases();
}
