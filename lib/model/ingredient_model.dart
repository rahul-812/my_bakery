import 'package:flutter/foundation.dart';

class Ingredient with ChangeNotifier {
  Ingredient(
    this.name,
    this.unit,
    num quantity,
    num averageRate,
    num latestRate,
  )   : _quantity = quantity,
        _averageRate = averageRate,
        _latestRate = latestRate;

  factory Ingredient.fromMap(String name, Map<String, dynamic> data) {
    return Ingredient(
      name,
      data['unit'],
      data['quantity'],
      data['averageRate'],
      data['latestRate'],
    );
  }

  final String name;
  final String unit;
  num _quantity;
  num _averageRate;
  num _latestRate;

  num get quantity => _quantity;
  num get latestRate => _latestRate;
  num get averageRate => _averageRate;

  void increaseQuantity(num value) {
    _quantity += value;
    notifyListeners();
  }

  void updateAverageRate(num rate, {bool notify = false}) {
    if (rate == _averageRate) return;
    _averageRate = rate;
    if (notify) notifyListeners();
  }

  void updateLatestRate(num rate, {bool notify = false}) {
    if (rate == _latestRate) return;
    _latestRate = rate;
    if (notify) notifyListeners();
  }
}

class Ingredients {
  static Iterable<Ingredient>? data;
}
