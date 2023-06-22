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
      ],
    );
  }
}
