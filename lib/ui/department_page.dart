import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_bakery/colors.dart';
import '../model/department_model.dart';
import '../model/product_model.dart';
import 'production_page.dart';

import '../backend/db_functions.dart';

class DepartmentsPage extends StatefulWidget {
  const DepartmentsPage({super.key});

  @override
  State<DepartmentsPage> createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  late final Future<Iterable<Department>> _futureDepartment;

  @override
  void initState() {
    super.initState();
    _futureDepartment = fetchDepartmentsData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<Department>>(
      future: _futureDepartment,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _DepertmentUi(departments: snapshot.data!);
        }
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Center(child: Icon(Icons.error));
        }
        return const Center(
          child: RepaintBoundary(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _DepertmentUi extends StatelessWidget {
  const _DepertmentUi({required this.departments});

  final Iterable<Department> departments;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: departments.length,
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 25.0,
            ),
            decoration: BoxDecoration(
              color: LightColors.blueAccent,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: TabBar(
              padding: const EdgeInsets.all(2.0),
              isScrollable: true,
              tabs: departments
                  .map((department) => Tab(child: Text(department.name)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20.0),
          SvgPicture.asset('images/recipe_book.svg', height: 184.0),
          const SizedBox(height: 10.0),
          Expanded(
            child: TabBarView(
              children: departments
                  .map((department) => ProductList(
                        products: department.products,
                        theme: textTheme,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.products,
    required this.theme,
  });

  final TextTheme theme;
  final Iterable<Product> products;

  @override
  Widget build(BuildContext context) {
    final accentColors = AccentColors();

    return ListView.separated(
      itemCount: products.length,
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
      itemBuilder: (_, index) {
        final product = products.elementAt(index);
        return ListTile(
          tileColor: LightColors.blueAccent,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProductionPage(product: product),
            ));
          },
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: accentColors.next,
            child: Text(
              product.name[0],
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 26.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          title: Text(
            product.name,
            style: theme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'Rate : ₹${product.rate}/packet',
            style: theme.bodyMedium,
          ),
          trailing: Column(
            children: [
              Text(
                '${product.quantity}',
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  color: LightColors.main,
                ),
              ),
              Text(
                'Packet',
                style: theme.bodySmall?.copyWith(
                  fontSize: 12.0,
                  color: LightColors.main,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
