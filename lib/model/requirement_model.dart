import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TextEditingController;

import './ingredient_model.dart';

class Requirement extends ChangeNotifier {
  Requirement({
    required this.name,
    this.quantity,
    this.ingredient,
    this.qController,
    this.pController,
    this.hasEnough,
  });

  final String name;
  final num? quantity;
  Ingredient? ingredient;
  TextEditingController? qController;
  bool? hasEnough;
  TextEditingController? pController;

  void canDeductFromStock(bool value) {
    if (value == hasEnough) return;
    hasEnough = value;
    notifyListeners();
  }
}
