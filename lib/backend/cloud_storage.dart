import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final db = FirebaseFirestore.instance;
// final ingredientCollectionRef = db.collection('raw-materials');
final ingredientCollectionRef = db.collection('stock');

class Ingredient {
  Ingredient(this.name, this.subUnit, this.quantity, this.rate);

  final String name;
  final String subUnit;
  num quantity;
  num rate;
}

Future<List<Ingredient>> fetchIngredientsData() async {
  final querySnapshot = await ingredientCollectionRef.get();

  return querySnapshot.docs
      .map(
        (doc) => Ingredient(doc.id, doc['unit'], doc['quantity'], doc['price']),
      )
      .toList();
}

Future<dynamic> updateIngredients(
    String goodsName, num newQuantity, num? price) async {
  return await db
      .collection('stock')
      .doc(goodsName)
      .update({'quantity': newQuantity, if (price != null) 'price': price});
}

class PurchaseHistory {
  final String name;
  final String date;
  final num previousQuantity;
  final num addedQuantity;
  final num totalPrice;
  final num rate;

  const PurchaseHistory(
    this.name,
    this.date,
    this.previousQuantity,
    this.addedQuantity,
    this.rate,
    this.totalPrice,
  );

  factory PurchaseHistory.fromMap(Map<String, dynamic> map) {
    return PurchaseHistory(
      map['name'],
      DateFormat('d MMMM, yyyy').format(map['date'] as DateTime),
      map['previousQuantity'],
      map['addedQuantity'],
      map['pricePerUnit'],
      map['addedQuantity'] * map['pricePerUnit'],
    );
  }
}

Future<List<PurchaseHistory>> fetchPurchaseRecords(
    DateTime startDate, DateTime endDate) async {
  final querySnapshot = await db
      .collection('purchase-record')
      .where('date', isGreaterThanOrEqualTo: startDate)
      .where('date', isLessThanOrEqualTo: endDate)
      .orderBy('date')
      .get();

  return querySnapshot.docs
      .map(
        (document) => PurchaseHistory.fromMap(document.data()),
      )
      .toList();
}
