import 'package:flutter/material.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(context) {
    return const MyWidget();
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
    _controller = TabController(length: 6, vsync: this);
    _controller.addListener(() {
      debugPrint(_controller.index.toString());
    });

    // _views = List.generate(
    //     _tabs.length, (index) => Center(child: Text('Page$index')));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        const Image(
          width: 200.0,
          height: 200.0,
          image: AssetImage('images/apple_pie.webp'),
        ),
        Container(
          height: 85,
          decoration: const BoxDecoration(
              // color: Color(0xfff4f6fa),
              // borderRadius: BorderRadius.circular(25.0),
              ),
          child: TabBar(
            // padding: EdgeInsets.symmetric(horizontal: 12.0),
            // indicatorPadding: EdgeInsets.symmetric(vertical: 3.0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Color(0xff303338),
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xff303338),
            isScrollable: true,
            controller: _controller,
            tabs: const [
              Tab(child: Text('Tab 1')),
              Tab(child: Text('Tab 2'), icon: Icon(Icons.train)),
              Tab(child: Text('Tab 3')),
              Tab(child: Text('Tab 4')),
              Tab(child: Text('Tab 5')),
              Tab(child: Text('Tab 6')),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: const [
              Text('Hello'),
              Text('Hello'),
              Text('Hello'),
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
