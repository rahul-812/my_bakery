import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final db = FirebaseFirestore.instance;
// final ingredientCollectionRef = db.collection('raw-materials');
final ingredientCollectionRef = db.collection('raw-materials');

class Ingredient {
  Ingredient(this.name, this.subUnit, this.quantity, this.rate);

  final String name;
  final String subUnit;
  num quantity;
  num rate;
}

// Future<List<Stream<DocumentSnapshot<Map<String, dynamic>>>>>
//     getIngredientSnapshots() async {
//   final querySnapshot = await ingredientCollectionRef.get();

//   return ;
// }

Future<List<List<dynamic>>> fetchIngredientsData() async {
  final querySnapshot = await ingredientCollectionRef.get();

  return [
    querySnapshot.docs
        .map(
          (doc) => Ingredient(
              doc.id, doc['unit'], doc['quantity'], doc['pricePerUnit']),
        )
        .toList(),
    querySnapshot.docs
        .map((doc) => ingredientCollectionRef.doc(doc.id).snapshots())
        .toList(),
  ];
}

Future<Ingredient> fetchAIngredientData(String ingredientName) async {
  final documentSnapshot =
      await ingredientCollectionRef.doc(ingredientName).get();
  return Ingredient(documentSnapshot.id, documentSnapshot.data()?['subUnit'],
      documentSnapshot.data()?['quantity'], documentSnapshot.data()?['rate']);
}

// Future<dynamic> updateIngredients(
//     String goodsName, num newQuantity, num? price) async {
//   return await db
//       .collection('stock')
//       .doc(goodsName)
//       .update({'quantity': newQuantity, if (price != null) 'price': price});
// }

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
      DateFormat('MMM dd, yyyy').format((map['date'] as Timestamp).toDate()),
      map['previousQuantity'],
      map['addedQuantity'],
      map['pricePerUnit'],
      map['addedQuantity'] * map['pricePerUnit'],
    );
  }
}

Future<List<PurchaseHistory>> fetchPurchaseRecords(
  DateTime startDate,
  DateTime endDate,
) async {
  final querySnapshot = await db
      .collection('purchase-history')
      .where('date', isGreaterThanOrEqualTo: startDate)
      .where('date', isLessThanOrEqualTo: endDate)
      .orderBy('date', descending: true)
      .get();

  return querySnapshot.docs
      .map((document) => PurchaseHistory.fromMap(
            document.data(),
          ))
      .toList();
}

Future<void> addPurchaseRecord(
  Ingredient ingredient,
  num addedQuantity,
  num rate,
) async {
  CollectionReference collectionRef = db.collection('purchase-history');
  await collectionRef.add({
    "date": DateTime.now(),
    "name": ingredient.name,
    "previousQuantity": ingredient.quantity,
    "addedQuantity": addedQuantity,
    "pricePerUnit": rate,
  });
}

Future<void> updateIngredientDetails(
  Ingredient ingredient,
  num addedQuantity,
  num totalPrice,
  num averageRate,
) async {
  num newRate = double.parse((totalPrice / addedQuantity).toStringAsFixed(2));

  await ingredientCollectionRef.doc(ingredient.name).update({
    'quantity': FieldValue.increment(addedQuantity),
    'pricePerUnit': averageRate,
  });

  await addPurchaseRecord(ingredient, addedQuantity, newRate);
}
