import 'package:flutter/foundation.dart';

class NewNotificationNotifier extends ChangeNotifier{
  bool istherenewnotification = false;
  void newnotification(){
    istherenewnotification = true;
    notifyListeners();
  }
}