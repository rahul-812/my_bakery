import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ui/current_stock.dart';

import 'theme.dart';
import 'colors.dart';
import 'ui/department.dart';
import 'ui/admin_signin.dart';
import 'backend/cloud_storage.dart';
import 'model/ingredient_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      appBar: AppBar(
        shape: const Border(bottom: BorderSide(color: LightColors.greyCard)),
        centerTitle: true,
        title: const Text('Swadesh Bakery'),
      ),
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
