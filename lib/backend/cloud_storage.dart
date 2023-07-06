import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_bakery/main.dart';

import '../model/ingredient_model.dart';
import '../model/requirement_model.dart';

final db = FirebaseFirestore.instance;
final ingredientCollectionRef = db.collection('Ingredients');

Future<Iterable<Ingredient>> fetchIngredientsData() async {
  return (await ingredientCollectionRef.get()).docs.map(
        (document) => Ingredient.fromMap(document.id, document.data()),
      );
}

// Map<String, Ingredient> formatIngredientsData(List<Ingredient> ingredientList) {
//   Map<String, Ingredient> ingredientMap = {};
//   for (Ingredient i in ingredientList) {
//     ingredientMap[i.name] = i;
//   }
//   return ingredientMap;
// }

Future<Ingredient> fetchAIngredientData(String ingredientName) async {
  final document = await ingredientCollectionRef.doc(ingredientName).get();
  return Ingredient(
    document.id,
    document['unit'],
    document['quantity'],
    document['avarageRate'],
    document['latestRate'],
  );
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
      DateFormat('MMM dd, yyyy').format((map['date'] as Timestamp).toDate()),
      map['previousQuantity'],
      map['addedQuantity'],
      map['rate'],
      map['addedQuantity'] * map['rate'],
    );
  }
}

Future<Iterable<PurchaseHistory>> fetchPurchaseRecords(
  DateTime startDate,
  DateTime endDate,
) async {
  final querySnapshot = await db
      .collection('purchase-history')
      .where('date', isGreaterThanOrEqualTo: startDate)
      .where('date', isLessThanOrEqualTo: endDate)
      .orderBy('date', descending: true)
      .get();

  return querySnapshot.docs.map((document) => PurchaseHistory.fromMap(
        document.data(),
      ));
}

Future<void> addPurchaseRecord(
  Ingredient ingredient,
  num addedQuantity,
  num rate,
) async {
  final collectionRef = db.collection('purchase-history');
  await collectionRef.add({
    "date": DateTime.now(),
    "name": ingredient.name,
    "previousQuantity": ingredient.quantity,
    "addedQuantity": addedQuantity,
    "rate": rate,
  });
}

Future<void> updateIngredientDetails(
  Ingredient ingredient,
  num addedQuantity,
  num totalPrice,
  num averageRate,
) async {
  num latestRate = (totalPrice / addedQuantity).toStringAsFixed(2).toNum;

  await ingredientCollectionRef.doc(ingredient.name).update({
    'quantity': FieldValue.increment(addedQuantity),
    'averageRate': averageRate,
    'latestRate': latestRate
  });

  await addPurchaseRecord(ingredient, addedQuantity, latestRate);
}

Future<void> useIngredient(
  Ingredient ingredient,
  num usedQuantity
) async {
  debugPrint('useIngredient($ingredient , $usedQuantity)');
  if(usedQuantity>0){
  await ingredientCollectionRef.doc(ingredient.name).update({
    'quantity': FieldValue.increment(usedQuantity * -1),
  });

  }

}



class Product {
  const Product(
    this.key,
    this.name,
    this.quantity,
    this.rate,
    this.requirements,
  );

  final String key;
  final String name;
  final num quantity;
  final num rate;
  final List<Requirement> requirements;

  // static Map<String, dynamic> formatRequirements(
  //     Map<String, dynamic> requirements) {
  //   Map<String, dynamic> formattedRequirements = {
  //     "ingredients": {},
  //     "others": []
  //   };
  //   requirements.forEach((key, value) {
  //     if (value == null) {
  //       formattedRequirements["others"].add(key);
  //     } else {
  //       formattedRequirements["ingredients"][key] = value;
  //     }
  //   });
  //   return formattedRequirements;
  // }
}

class Department {
  final String name;
  final Iterable<Product> products;

  const Department(this.name, this.products);

  static Iterable<Product> makeProductList(Map<String, dynamic> data) {
    return data.entries.map((e) {
      final Map<String, dynamic> requirementMap = e.value['requirement'];
      final requirements = requirementMap.entries
          .map<Requirement>(
            (entry) => Requirement(name: entry.key, quantity: entry.value),
          )
          .toList();

      return Product(
        e.key,
        e.value['name'],
        e.value['quantity'],
        e.value['rate'],
        requirements,
      );
    });
  }
}

Future<Iterable<Department>> fetchDepartmentData() async {
  final querySnapshot = await db.collection('departments').get();

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

// Future<void> calculateRequirementsAndPrice(
//     Map<String, dynamic> ingredientRequirements, num batch) async {
//   Map<String, Ingredient> ingredientsMap =
//       formatIngredientsData((await fetchIngredientsData()).cast<Ingredient>());
//   Map<String, TextEditingController> quantityControllers = {
//     'Maida': TextEditingController()
//   };
//   Map<String, TextEditingController> priceControllers = {
//     'Maida': TextEditingController()
//   };
//   Future<void> calculateRequirementsAndPrice(
//       Map<String, dynamic> ingredientRequirements, num batch) async {
//     Map<String, Ingredient> ingredientsMap = formatIngredientsData(
//         (await fetchIngredientsData()).cast<Ingredient>());
//     ingredientRequirements.forEach((key, value) {
//       if (ingredientsMap[key]!.quantity >= value * batch) {
//         quantityControllers[key]?.text = value * batch;
//         priceControllers[key]?.text =
//             (ingredientsMap[key]!.latestRate * value * batch)
//                 .toStringAsFixed(2);
//       } else {
//         //showWarning(insufficient '$key');
//       }
//     });
//   }

  // num calculateRate(num packates) {
  //   num totalCost = 0;
  //   priceControllers.forEach((key, value) {
  //     totalCost += num.parse(value.text);
  //   });
  //   return double.parse((totalCost / packates).toStringAsFixed(2));
  // }

//   Future<void> deductIngredients() async {
//     quantityControllers.forEach((key, value) async {
//       await ingredientCollectionRef.doc(key).update(
//           {'quantity': FieldValue.increment(int.parse(value.text) * -1)});
//     });
//   }
// }

Future<dynamic> addNewIngredient(String name, String unit) async {
  return await ingredientCollectionRef.doc(name).set({
    "unit": unit,
    "quantity": 0,
    "averageRate": 0.00,
    "latestRate": 0.00,
  });
}
