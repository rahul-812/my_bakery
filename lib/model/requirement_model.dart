import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TextEditingController;

import './ingredient_model.dart';

class Requirement extends ChangeNotifier {
  Requirement({
    required this.name,
    this.quantity,
    this.associatedIngredient,
    this.qController,
    this.isEnough,
    this.pController
  });

  final String name;
  final num? quantity;
  Ingredient? associatedIngredient;
  TextEditingController? qController;
  bool? isEnough;
  TextEditingController? pController;
  // final TextEditingController qController;

  void haveEnoughInStock(bool value) {
    if (value == isEnough) return;
    isEnough = value;
    notifyListeners();
  }
}
