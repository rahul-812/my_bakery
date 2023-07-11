import 'requirement_model.dart';
import 'package:flutter/foundation.dart';

class Product extends ChangeNotifier {
  Product(
    this.key,
    this.name,
    this.quantity,
    this._rate,
    this.requirements,
  );

  final String key;
  final String name;
  num quantity;
  num _rate;
  final List<Requirement> requirements;

  num get rate => _rate;

  void increasePackets(num value) {
    quantity += value;
    notifyListeners();
  }

  set rate(num value) {
    if (_rate == value) return;
    _rate = value;
  }
}
