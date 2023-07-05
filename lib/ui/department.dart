import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_bakery/colors.dart';
import 'package:my_bakery/ui/productoin.dart';

import '../backend/cloud_storage.dart';
import 'my_widgets.dart';

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
      length: 2,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),
          SvgPicture.asset(
            'images/candy.svg',
            width: 150.0,
            height: 150.0,
          ),
          const SizedBox(height: 10.0),
          const CustomCard(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: TabBar(
              isScrollable: true,
              padding: EdgeInsets.symmetric(vertical: 6.0),
              tabs: [
                CustomTab(label: 'Hand Biscuit', image: 'images/bread.svg'),
                CustomTab(label: 'Machine Biscuit', image: 'images/cookie.svg'),
              ],
            ),
          ),
          Expanded(
            child: CustomCard(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(10.0),
              child: TabBarView(
                children: [
                  ProductList(
                    iconPath: 'images/bread.svg',
                    products: departments.elementAt(0).products,
                    theme: textTheme,
                  ),
                  ProductList(
                    iconPath: 'images/cookie.svg',
                    products: departments.elementAt(1).products,
                    theme: textTheme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  const CustomTab({super.key, required this.label, required this.image});

  final String label;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: SvgPicture.asset(
        image,
        height: 24.0,
        width: 24.0,
        excludeFromSemantics: true,
      ),
      child: Text(label),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.child,
    this.height,
    this.margin,
    this.padding,
  });

  final Widget? child;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: LightColors.shadow,
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: -1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.iconPath,
    required this.products,
    required this.theme,
  });

  final String iconPath;
  final TextTheme theme;
  final Iterable<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final product = products.elementAt(index);
        return ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProductionPage(product: product),
            ));
          },
          leading: SvgPicture.asset(
            iconPath,
            excludeFromSemantics: true,
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
