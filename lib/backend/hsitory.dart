import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;
final ingredientCollectionRef = db.collection('raw-materials');

Future<dynamic> addPurchaseRecord(
  String rawMaterialName,
  num previousQuantity,
  num addedQuantity,
  num rate,
) async {
  try {
    CollectionReference collectionRef = db.collection('purchase-history');
    var docRef = await collectionRef.add({
      "date": DateTime.now(),
      "name": rawMaterialName,
      "previousQuantity": previousQuantity,
      "addedQuantity": addedQuantity,
      "pricePerUnit": rate,
    });
    print('New record added with ID: ${docRef.id}');
    return docRef.id;
  } catch (error) {
    print('Error adding record: $error');
  }
}

Future<dynamic> addIngredientStock(String ingredientName, num previousQuantity,
    num addedQuantity, num previousRate, num totalPrice) async {
  try {
    num newRate = double.parse((totalPrice / addedQuantity).toStringAsFixed(2));
    num avarageRate = double.parse(
      (((previousRate * previousQuantity) + totalPrice) /
              (previousQuantity + addedQuantity))
          .toStringAsFixed(2),
    );

    await ingredientCollectionRef.doc(ingredientName).update({
      'quantity': FieldValue.increment(addedQuantity),
      'pricePerUnit': avarageRate,
    });

    await addPurchaseRecord(
        ingredientName, previousQuantity, addedQuantity, newRate);
    return true;
  } catch (error) {
    return error;
  }
}
