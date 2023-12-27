import 'package:flutter/foundation.dart';
import 'package:stock_manager_app/models/product.dart';

class ProductUpdateNotifier extends ChangeNotifier{
  Product product = Product.simple();

  void setProduct(Product newProduct){
    product = newProduct;
    notifyListeners();
  }
}