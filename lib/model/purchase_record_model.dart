import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class PurchaseRecord {
  final String name;
  final String date;
  final num previousQuantity;
  final num addedQuantity;
  final num totalPrice;
  final num rate;

  const PurchaseRecord(
    this.name,
    this.date,
    this.previousQuantity,
    this.addedQuantity,
    this.rate,
    this.totalPrice,
  );

  factory PurchaseRecord.fromMap(Map<String, dynamic> map) {
    return PurchaseRecord(
      map['name'],
      DateFormat('MMM dd, yyyy').format((map['date'] as Timestamp).toDate()),
      map['previousQuantity'],
      map['addedQuantity'],
      map['rate'],
      map['addedQuantity'] * map['rate'],
    );
  }
}

class PurchaseRecords extends ChangeNotifier {
  static List<PurchaseRecord>? data;
}
