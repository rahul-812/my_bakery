import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/department_model.dart';
import '../model/purchase_record_model.dart';
import '../util.dart';
import '../model/ingredient_model.dart';

final db = FirebaseFirestore.instance;
final ingredientsCollectionRef = db.collection('Ingredients');
final departmentsCollectionRef = db.collection('departments');
final purchaseRecordsCollectionRef = db.collection('purchase-history');

Future<Iterable<Ingredient>> fetchIngredientsData() async {
  return (await ingredientsCollectionRef.get()).docs.map(
        (document) => Ingredient.fromMap(document.id, document.data()),
      );
}

Future<Ingredient> fetchAIngredientData(String ingredientName) async {
  final document = await ingredientsCollectionRef.doc(ingredientName).get();
  return Ingredient(
    document.id,
    document['unit'],
    document['quantity'],
    document['avarageRate'],
    document['latestRate'],
  );
}

Future<void> addIngredientStock(
  Ingredient ingredient,
  num addedQuantity,
  num totalPrice,
  num averageRate,
) async {
  num latestRate = (totalPrice / addedQuantity).toStringAsFixed(2).toNum;

  await ingredientsCollectionRef.doc(ingredient.name).update({
    'quantity': FieldValue.increment(addedQuantity),
    'averageRate': averageRate,
    'latestRate': latestRate
  });

  await addPurchaseRecord(ingredient, addedQuantity, latestRate);
}

Future<void> useIngredient(Ingredient ingredient, num usedQuantity) async {
  debugPrint('useIngredient($ingredient , $usedQuantity)');
  if (usedQuantity > 0) {
    await ingredientsCollectionRef.doc(ingredient.name).update({
      'quantity': FieldValue.increment(usedQuantity * -1),
    });
  } else {
    await ingredientsCollectionRef.doc(ingredient.name).update({
      'quantity': FieldValue.increment(usedQuantity),
    });
  }
}

Future<Iterable<PurchaseRecord>> fetchPurchaseRecords(
  DateTime startDate,
  DateTime endDate,
) async {
  final querySnapshot = await purchaseRecordsCollectionRef
      .where('date', isGreaterThanOrEqualTo: startDate)
      .where('date', isLessThanOrEqualTo: endDate)
      .orderBy('date', descending: true)
      .get();

  return querySnapshot.docs.map((document) => PurchaseRecord.fromMap(
        document.data(),
      ));
}

Future<void> addPurchaseRecord(
  Ingredient ingredient,
  num addedQuantity,
  num rate,
) async {
  final collectionRef = purchaseRecordsCollectionRef;
  await collectionRef.add({
    "date": DateTime.now(),
    "name": ingredient.name,
    "previousQuantity": ingredient.quantity,
    "addedQuantity": addedQuantity,
    "rate": rate,
  });
}

Future<Iterable<Department>> fetchDepartmentsData() async {
  final querySnapshot = await departmentsCollectionRef.get();

  return querySnapshot.docs.map((department) => Department(
        department.id,
        Department.makeProductList(department.data()),
      ));
}

bool isValidValue(num v) {
  if ((double.parse("$v") > 0.0)) {
    return true;
  } else {
    return false;
  }
}

Future<void> addProductStock(
    String departmentName, String productKey, num quantity, num rate) async {
  await departmentsCollectionRef.doc(departmentName).update({
    '$productKey.quantity': FieldValue.increment(quantity),
    '$productKey.rate': rate
  });
}

Future<dynamic> addNewIngredient(String name, String unit) async {
  return await ingredientsCollectionRef.doc(name).set({
    "unit": unit,
    "quantity": 0,
    "averageRate": 0.00,
    "latestRate": 0.00,
  });
}
