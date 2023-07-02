import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_bakery/colors.dart';
import 'package:my_bakery/ui/my_widgets.dart';
import 'backend/cloud_storage.dart';
import 'ui/purchase_history.dart';
import 'ui/current_stock.dart';
import 'theme.dart';
import 'ui/department.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
//    List<Map<String,String>> ingredientList = [
//   {"name":"Maida","unit":"KG"},
//   {"name":"Butter","unit":"KG"},
//   {"name":"Salt","unit":"KG"},
//   {"name":"Egg","unit":"Pcs"},
//   {"name":"Rasui Dalda","unit":"KG"},
//   {"name":"Margarin Dalda","unit":"KG"},
//   {"name":"Oil","unit":"L"},
//   {"name":"Sugar","unit":"KG"}
// ];
// for(Map<String,String> i in ingredientList){
//   await addNewIngredient(i['name']!,i['unit']!);
// }
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
      home: Scaffold(
        body: Center(
          child: Builder(builder: (context) {
            return TextButton(
              onPressed: () {
                showModalBottomSheet(
                  elevation: 0.0,
                  context: context,
                  builder: (_) => const MakeProductSheet(),
                );
              },
              child: const Text('Open'),
            );
          }),
        ),
      ),
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
      backgroundColor: _currentIndex == 1 ? const Color(0xFFF5F5F8) : null,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Swadesh Bakery'),
        actions: const [
          Icon(
            Icons.cake,
            color: LightColors.main,
          ),
          SizedBox(width: 30.0),
        ],
      ),
      body: _uiPages[_currentIndex],
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
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex != 2
                  ? Icons.access_time_sharp
                  : Icons.access_time_filled,
            ),
            label: 'History',
          )
        ],
      ),
    );
  }
}
