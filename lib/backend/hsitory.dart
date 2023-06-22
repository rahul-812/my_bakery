// import 'package:cloud_firestore/cloud_firestore.dart';

// final db = FirebaseFirestore.instance;
// final ingredientCollectionRef = db.collection('raw-materials');

// Future<dynamic> addIngredientStock(String ingredientName, num previousQuantity,
//     num addedQuantity, num previousRate, num totalPrice) async {
//   try {
//     num newRate = double.parse((totalPrice / addedQuantity).toStringAsFixed(2));
//     num avarageRate = double.parse(
//       (((previousRate * previousQuantity) + totalPrice) /
//               (previousQuantity + addedQuantity))
//           .toStringAsFixed(2),
//     );

//     await ingredientCollectionRef.doc(ingredientName).update({
//       'quantity': FieldValue.increment(addedQuantity),
//       'pricePerUnit': avarageRate,
//     });

//     await addPurchaseRecord(
//         ingredientName, previousQuantity, addedQuantity, newRate);
//     return true;
//   } catch (error) {
//     return error;
//   }
// }
