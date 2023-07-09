import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_bakery/colors.dart';
import 'package:my_bakery/ui/productoin_page.dart';

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
    _futureDepartment = fetchDepartmentData();
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
          child: RepaintBoundary(
            child: CircularProgressIndicator(),
          ),
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
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.blueGrey.shade50),
                ),
              ),
              child: TabBar(
                isScrollable: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 2.0,
                ),
                tabs: departments
                    .map((department) => Tab(child: Text(department.name)))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          SvgPicture.asset(
            'images/candy.svg',
            width: 150.0,
            height: 150.0,
          ),
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
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final product = products.elementAt(index);
        return ListTile(
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
            'Rate : ₹${product.rate}',
            style: theme.bodySmall?.copyWith(
              fontSize: 14.0,
            ),
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
