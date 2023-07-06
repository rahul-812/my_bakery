import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_bakery/backend/cloud_storage.dart';
import 'package:my_bakery/model/ingredient_model.dart';
import 'package:my_bakery/ui/current_stock.dart';
import 'package:provider/provider.dart';

import './colors.dart';
import 'theme.dart';
import 'ui/department.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

extension ToNumber on String {
  num get toNum => num.parse(this);
  int get toInt => int.parse(this);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.light,
      home: const UiPageHolder(
        screens: [
          CurrentStockPage(),
          DepartmentsPage(),
        ],
      ),
    );
  }
}

class UiPageHolder extends StatefulWidget {
  const UiPageHolder({super.key, required this.screens});

  final List<Widget> screens;

  @override
  State<UiPageHolder> createState() => _UiPageHolderState();
}

class _UiPageHolderState extends State<UiPageHolder> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: _currentIndex == 1 ? const Color(0xFFF5F5F5) : null,
      appBar: AppBar(
        // toolbarHeight: 0.0,
        centerTitle: true,
        title: const Text('Swadesh Bakery'),
        // bottom: const TabBar(
        //   tabs: [
        //     Tab(child: Text('Stock')),
        //     Tab(child: Text('Department')),
        //   ],
        // ),
      ),
      // body: const TabBarView(
      //   children: [
      //     CurrentStockPage(),
      //     DepartmentsPage(),
      //   ],
      // ),
      body: IndexedStack(
        index: _currentIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex != 0
                  ? Icons.factory_outlined
                  : Icons.factory_rounded,
            ),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex != 1 ? Icons.cookie_outlined : Icons.cookie_rounded,
            ),
            label: 'Products',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     _currentIndex != 2
          //         ? Icons.access_time_sharp
          //         : Icons.access_time_filled,
          //   ),
          //   label: 'History',
          // )
        ],
      ),
    );
  }
}
