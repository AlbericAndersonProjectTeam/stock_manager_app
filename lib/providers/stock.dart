import 'package:flutter/foundation.dart';
import 'package:stock_manager_app/models/stock.dart';

class StockUpdateNotifier extends ChangeNotifier{
  Stock stock = Stock.simple();

  void setStock(Stock newStock){
    stock = newStock;
    notifyListeners();
  }
}