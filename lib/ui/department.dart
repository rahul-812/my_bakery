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
          // const SizedBox(height: 20.0),
          // SvgPicture.asset(
          //   'images/cookie.svg',
          //   width: 150.0,
          //   height: 150.0,
          //   // image: AssetImage('images/apple_pie.webp'),
          // ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          //   child: Text(
          //     'Choose products under the depertments',
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          // const SizedBox(height: 10.0),
          const CustomCard(
            height: 100.0,
            margin: EdgeInsets.all(10.0),
            child: Text('Check card'),
          ),
          const CustomCard(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: TabBar(
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
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(10.0),
              child: TabBarView(
                children: [
                  ProductList(
                    iconPath: 'images/bread.svg',
                    theme: textTheme,
                  ),
                  ProductList(
                    iconPath: 'images/cookie.svg',
                    theme: textTheme,
                  ),
                  ProductList(
                    iconPath: 'images/cake.svg',
                    theme: textTheme,
                  ),
                  ProductList(
                    iconPath: 'images/candy.svg',
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
            color: LightColors.shadowColor,
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
    required this.theme,
  });

  final String iconPath;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 12,
      // padding: const EdgeInsets.all(12.0),
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) => ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => const SizedBox(height: 40),
          );
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
