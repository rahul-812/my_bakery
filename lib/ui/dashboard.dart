import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _HomePageState();
}

class _HomePageState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 20.0,
        title: const Text('Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 12.0,
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        children: const [
          GridComponent(label: 'Current Stock', image: 'current_stock'),
          GridComponent(label: 'Profit/Loss', image: 'profit_loss'),
          GridComponent(label: 'Raw Materials', image: 'rice_bag'),
          GridComponent(label: 'Payment', image: 'payment'),
        ],
      ),
    );
  }
}

class MainGridOption extends StatelessWidget {
  const MainGridOption({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16.0),
      color: color,
    );
  }
}

class GridComponent extends StatelessWidget {
  const GridComponent({
    Key? key,
    required this.label,
    required this.image,
  }) : super(key: key);

  final String label;
  final String image;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16.0);
    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: const BorderSide(color: Color(0xffd1dbfe)),
          // side: const BorderSide(color: const Color(0xffd1dbfe)),
        ),
        child: InkWell(
          onTap: () {},
          highlightColor: const Color(0xfff2f3ff),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                width: 74,
                height: 74,
                image: AssetImage('images/$image.webp'),
              ),
              const SizedBox(height: 14.0),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
