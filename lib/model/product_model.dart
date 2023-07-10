import 'requirement_model.dart';

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
}
