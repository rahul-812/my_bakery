import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ui/purchase_history.dart';
import 'ui/current_stock.dart';
import 'theme.dart';
import 'ui/department.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.light,
      home: const UiPageHolder(),
    );
  }
}

extension StringDate on DateTime {
  String get asString => DateFormat('EEEE, d MMM y').format(this);
}

class UiPageHolder extends StatefulWidget {
  const UiPageHolder({super.key});

  @override
  State<UiPageHolder> createState() => _UiPageHolderState();
}

class _UiPageHolderState extends State<UiPageHolder> {
  late final List<Widget> _uiPages;

  @override
  void initState() {
    super.initState();
    _uiPages = [
      CurrentStockPage(),
      const DepartmentsPage(),
      PurchaseHistoryPage(),
    ];
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _uiPages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Ingredient'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          )
        ],
      ),
    );
  }
}
