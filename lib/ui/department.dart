import 'package:flutter/material.dart';
import 'package:my_bakery/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const radius = 12.0;
    const padding = 16.0;

    return DefaultTabController(
      length: 4,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const Image(
            width: 200.0,
            height: 200.0,
            image: AssetImage('images/apple_pie.webp'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Text(
              'Choose products under the depertments',
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: padding),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              shadows: const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 3),
                  spreadRadius: -6,
                ),
              ],
            ),
            child: const TabBar(
              isScrollable: true,
              tabs: [
                CustomTab(label: 'Bread', image: 'images/bread.svg'),
                CustomTab(label: 'Hand Biscuit', image: 'images/cookie.svg'),
                CustomTab(label: 'Cake', image: 'images/cake.svg'),
                CustomTab(label: 'Sweet', image: 'images/candy.svg'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                Text('Hello'),
                Text('Hello'),
                Text('Hello'),
                Text('Hello'),
              ],
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

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
