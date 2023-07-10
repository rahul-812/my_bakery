import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_bakery/ui/purchase_history_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'theme.dart';
import 'colors.dart';
import 'ui/ingredient_page.dart';
import 'ui/department_page.dart';
import 'ui/signin_page.dart';

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
                PurchaseHistoryPage(),
              ],
            ),
        'signin': (_) => const AdminSignInPage(),
      },
      initialRoute: isLoggedIn ? 'home' : 'signin',
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
      appBar: AppBar(),
      body: widget.screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // onTap: (index) => setState(() => _currentIndex = index),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.warehouse, size: 20.0),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.cookie,
            ),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.calendarDays,
            ),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
