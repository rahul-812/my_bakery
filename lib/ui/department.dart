import 'package:flutter/material.dart';
import 'package:my_bakery/colors.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const Image(
            width: 200.0,
            height: 200.0,
            image: AssetImage('images/apple_pie.webp'),
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            color: LightColors.blueGrey,
            child: const TabBar(
              labelPadding: EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 8.0,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(color: LightColors.bluishBlack),
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: LightColors.bluishBlack,
              tabs: [
                CustomTab(label: 'Lollipop', image: 'images/lollipop.webp'),
                CustomTab(label: 'Hand Cookies', image: 'images/cookie.webp'),
                CustomTab(label: 'Cake', image: 'images/cake.webp'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
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
      icon: Image(
        height: 34.0,
        width: 34.0,
        image: AssetImage(image),
      ),
      child: Text(label),
    );
  }
}
