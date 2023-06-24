import 'package:flutter/material.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(context) {
    return Column(
      children: const [
        Image(
          width: 200.0,
          height: 200.0,
          image: AssetImage('images/apple_pie.webp'),
        ),
        SizedBox(height: 20.0),
        MyWidget(),
      ],
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  // late final List<Tab> _tabs;
  // late final List<Widget> _views;

  @override
  void initState() {
    super.initState();
    // _tabs = List.generate(
    //     3,
    //     (index) => Tab(
    //           text: 'Buiscuit$index',
    //         ));
    // _controller = TabController(length: _tabs.length, vsync: this);

    // _views = List.generate(
    //     _tabs.length, (index) => Center(child: Text('Page$index')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          controller: _controller,
          tabs: const [
            Tab(child: Text('Tab 1')),
            Tab(child: Text('Tab 2')),
            Tab(child: Text('Tab 3')),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: const [
              Text('Hello'),
              Text('Hello'),
              Text('Hello'),
            ],
          ),
        ),
      ],
    );
  }
}
