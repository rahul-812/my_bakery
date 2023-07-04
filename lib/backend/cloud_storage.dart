import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final db = FirebaseFirestore.instance;
final ingredientCollectionRef = db.collection('Ingredients');

class Ingredient {
  Ingredient(
      this.name, this.unit, this.quantity, this.averageRate, this.latestRate);
  final String name;
  final String unit;
  num quantity;
  num averageRate;
  num latestRate;
}

Future<List<List<dynamic>>> fetchIngredientsData() async {
  final querySnapshot = await ingredientCollectionRef.get();

  return [
    querySnapshot.docs
        .map(
          (doc) => Ingredient(doc.id, doc['unit'], doc['quantity'],
              doc['averageRate'], doc['latestRate']),
        )
        .toList(),
    querySnapshot.docs
        .map((doc) => ingredientCollectionRef.doc(doc.id).snapshots())
        .toList(),
  ];
}

Map<String, Ingredient> formatIngredientsData(List<Ingredient> ingredientList) {
  Map<String, Ingredient> ingredientMap = {};
  for (Ingredient i in ingredientList) {
    ingredientMap[i.name] = i;
  }
  return ingredientMap;
}

Future<Ingredient> fetchAIngredientData(String ingredientName) async {
  final documentSnapshot =
      await ingredientCollectionRef.doc(ingredientName).get();
  return Ingredient(
      documentSnapshot.id,
      documentSnapshot.data()?['unit'],
      documentSnapshot.data()?['quantity'],
      documentSnapshot.data()?['avarageRate'],
      documentSnapshot.data()?['latestRate']);
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
    "rate": rate,
  });
}

Future<void> updateIngredientDetails(
  Ingredient ingredient,
  num addedQuantity,
  num totalPrice,
  num averageRate,
) async {
  num latestRate =
      double.parse((totalPrice / addedQuantity).toStringAsFixed(2));

  await ingredientCollectionRef.doc(ingredient.name).update({
    'quantity': FieldValue.increment(addedQuantity),
    'averageRate': averageRate,
    'latestRate': latestRate
  });

  await addPurchaseRecord(ingredient, addedQuantity, latestRate);
}

class Product {
  final String key;
  final String name;
  final num quantity;
  final num rate;
  final Map<String, dynamic> requirements;

  const Product(
    this.key,
    this.name,
    this.quantity,
    this.rate,
    this.requirements,
  );

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
  final List<Product> products;

  const Department(this.name, this.products);

  static List<Product> makeProductList(Map<String, dynamic> data) {
    // final l = <Product>[];
    // data.forEach((key, value) {
    //   l.add(Product(
    //     key,
    //     value['name'],
    //     value['quantity'],
    //     value['rate'],
    //     value['requirement'],
    //   ));
    // });
    // return l;
    return data.entries.map((e) {
      debugPrint('${e.key}');
      return Product(
        e.key,
        e.value['name'],
        e.value['quantity'],
        e.value['rate'],
        e.value['requirement'],
      );
    }).toList();
  }
}

Future<List<Department>> fetchDepartmentData() async {
  final querySnapshot = await db.collection('departments').get();

  return querySnapshot.docs
      .map(
        (department) => Department(
          department.id,
          Department.makeProductList(department.data()),
        ),
      )
      .toList();

  // return [
  //   querySnapshot.docs
  //       .map(
  //         (department) => Department(
  //           department.id,
  //           Department.makeProductList(department.data()),
  //         ),
  //       )
  //       .toList(),
  //   querySnapshot.docs
  //       .map((doc) => ingredientCollectionRef.doc(doc.id).snapshots())
  //       .toList(),
  // ];
}

bool isValidValue(num v) {
  if ((double.parse("$v") > 0.0)) {
    return true;
  } else {
    return false;
  }
}

Future<void> calculateRequirementsAndPrice(
    Map<String, dynamic> ingredientRequirements, num batch) async {
  Map<String, Ingredient> ingredientsMap =
      formatIngredientsData((await fetchIngredientsData()).cast<Ingredient>());
  Map<String, TextEditingController> quantityControllers = {
    'Maida': TextEditingController()
  };
  Map<String, TextEditingController> priceControllers = {
    'Maida': TextEditingController()
  };
  Future<void> calculateRequirementsAndPrice(
      Map<String, dynamic> ingredientRequirements, num batch) async {
    Map<String, Ingredient> ingredientsMap = formatIngredientsData(
        (await fetchIngredientsData()).cast<Ingredient>());
    ingredientRequirements.forEach((key, value) {
      if (ingredientsMap[key]!.quantity >= value * batch) {
        quantityControllers[key]?.text = value * batch;
        priceControllers[key]?.text =
            (ingredientsMap[key]!.latestRate * value * batch)
                .toStringAsFixed(2);
      } else {
        //showWarning(insufficient '$key');
      }
    });
  }

  num calculateRate(num packates) {
    num totalCost = 0;
    priceControllers.forEach((key, value) {
      totalCost += num.parse(value.text);
    });
    return double.parse((totalCost / packates).toStringAsFixed(2));
  }

  Future<void> deductIngredients() async {
    quantityControllers.forEach((key, value) async {
      await ingredientCollectionRef.doc(key).update(
          {'quantity': FieldValue.increment(int.parse(value.text) * -1)});
    });
  }

  Future<dynamic> addNewIngredient(String name, String unit) async {
    return await ingredientCollectionRef.doc(name).set({
      "unit": unit,
      "quantity": 0,
      "averageRate": 0.00,
      "latestRate": 0.00,
    });
  }
}
