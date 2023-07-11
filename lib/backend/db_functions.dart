import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/department_model.dart';
import '../model/purchase_record_model.dart';
import '../util.dart';
import '../model/ingredient_model.dart';

final db = FirebaseFirestore.instance;
final ingredientsCollectionRef = db.collection('Ingredients');
final departmentsCollectionRef = db.collection('departments');
final purchaseRecordsCollectionRef = db.collection('purchase-history');

Future<List<Ingredient>> fetchIngredientsData() async {
  return (await ingredientsCollectionRef.get())
      .docs
      .map((document) => Ingredient.fromMap(document.id, document.data()))
      .toList();
}

Future<PurchaseRecord> addIngredientStock(
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

  return await addPurchaseRecord(ingredient, addedQuantity, latestRate);
}

Future<void> useIngredient(Ingredient ingredient, num usedQuantity) async {
  await ingredientsCollectionRef.doc(ingredient.name).update({
    'quantity': FieldValue.increment(-usedQuantity),
  });
  ingredient.deductQuantity(usedQuantity);
}

Future<List<PurchaseRecord>> fetchPurchaseRecords() async {
  final querySnapshot = await purchaseRecordsCollectionRef
      .orderBy('date', descending: true)
      .get();

  return querySnapshot.docs
      .map((document) => PurchaseRecord.fromMap(
            document.data(),
          ))
      .toList();
}

Future<PurchaseRecord> addPurchaseRecord(
  Ingredient ingredient,
  num addedQuantity,
  num rate,
) async {
  final collectionRef = purchaseRecordsCollectionRef;
  final data = <String, dynamic>{
    "date": Timestamp.fromDate(DateTime.now()),
    "name": ingredient.name,
    "previousQuantity": ingredient.quantity,
    "addedQuantity": addedQuantity,
    "rate": rate,
  };
  await collectionRef.add(data);
  return PurchaseRecord.fromMap(data);
}

Future<List<Department>> fetchDepartmentsData() async {
  final querySnapshot = await departmentsCollectionRef.get();

  return querySnapshot.docs
      .map((department) => Department(
            department.id,
            Department.makeProductList(department.data()),
          ))
      .toList();
}

Future<void> addToProductStock(
    String departmentName, String productKey, num quantity, num rate) async {
  await departmentsCollectionRef.doc(departmentName).update({
    '$productKey.quantity': FieldValue.increment(quantity),
    '$productKey.rate': rate,
  });
}
