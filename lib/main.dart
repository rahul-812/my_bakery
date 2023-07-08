import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/current_stock.dart';

import 'theme.dart';
import 'colors.dart';
import 'ui/department.dart';
import 'ui/signin.dart';
import 'backend/cloud_storage.dart';
import 'model/ingredient_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(isLoggedIn: prefs.getBool('logged_in') ?? false));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.light,
      routes: {
        'home': (_) => const UiPageHolder(
              screens: [
                CurrentStockPage(),
                DepartmentsPage(),
              ],
            ),
        'signin': (_) => const AdminSignInPage(),
      },
      initialRoute: isLoggedIn ? 'home' : 'signin',
      home: const AdminSignInPage(),
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
      drawer: Drawer(
        width: 230.0,
        elevation: 0.0,
        child: SafeArea(
          child: Column(
            children: const [
              Text('Swadesh Bakery'),
              Text('rsk8529@gmail.com'),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        showUnselectedLabels: false,
        unselectedItemColor: LightColors.lightText,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.factory_outlined),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cookie_outlined,
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
