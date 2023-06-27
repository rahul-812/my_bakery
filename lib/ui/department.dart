import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_bakery/colors.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 4,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),
          SvgPicture.asset(
            'images/cookie.svg',
            width: 150.0,
            height: 150.0,
            // image: AssetImage('images/apple_pie.webp'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: Text(
              'Choose products under the depertments',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: LightColors.shadowColor,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                  spreadRadius: -1,
                ),
              ],
            ),
            child: const TabBar(
              isScrollable: true,
              padding: EdgeInsets.symmetric(vertical: 6.0),
              tabs: [
                CustomTab(label: 'Bread', image: 'images/bread.svg'),
                CustomTab(label: 'Hand Biscuit', image: 'images/cookie.svg'),
                CustomTab(label: 'Cake', image: 'images/cake.svg'),
                CustomTab(label: 'Sweet', image: 'images/candy.svg'),
              ],
            ),
          ),
          Expanded(
            child: CustomCard(
              child: TabBarView(
                children: [
                  ProductList(
                    iconPath: 'images/cake.svg',
                    theme: textTheme,
                  ),
                  ProductList(
                    iconPath: 'images/cake.svg',
                    theme: textTheme,
                  ),
                  ProductList(
                    iconPath: 'images/cake.svg',
                    theme: textTheme,
                  ),
                  ProductList(
                    iconPath: 'images/cake.svg',
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
  const CustomCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: LightColors.shadowColor,
            blurRadius: 4,
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
    required this.theme,
  });

  final String iconPath;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      padding: const EdgeInsets.all(12.0),
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) => ListTile(
        onTap: () {
          debugPrint('opening bottom sheet...');
        },
        leading: SvgPicture.asset(
          iconPath,
          excludeFromSemantics: true,
        ),
        title: Text(
          'Pastry Cake',
          style: theme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Rate  ₹120',
          style: theme.bodySmall?.copyWith(
            fontSize: 14.0,
          ),
        ),
        trailing: Column(
          children: [
            const Text(
              '40',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                color: LightColors.secondary,
              ),
            ),
            Text(
              'packet',
              style: theme.bodySmall?.copyWith(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
