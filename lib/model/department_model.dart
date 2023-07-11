import 'product_model.dart';
import 'requirement_model.dart';

class Department {
  final String name;
  final List<Product> products;

  const Department(this.name, this.products);

  static List<Product> makeProductList(Map<String, dynamic> data) {
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
    }).toList();
  }
}
