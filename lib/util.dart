import 'package:flutter/foundation.dart';

import 'model/department_model.dart';
import 'model/ingredient_model.dart';
import 'model/purchase_record_model.dart';

mixin AppFutures {
  static Future<List<Ingredient>>? futureStock;
  static Future<List<Department>>? futureDepartment;
  static Future<List<PurchaseRecord>>? futurePurchaseHistory;
}

extension ToNumber on String {
  num get toNum => num.parse(this);
  int get toInt => int.parse(this);
}

class LoadingOverlay extends ChangeNotifier {
  bool _show = false;
  bool get show => _show;
  set show(bool value) {
    if (_show == value) return;
    _show = value;
    notifyListeners();
  }
}
