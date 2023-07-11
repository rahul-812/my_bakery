import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_bakery/backend/db_functions.dart';
import 'package:my_bakery/colors.dart';
import 'package:my_bakery/util.dart';

import '../model/purchase_record_model.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  @override
  void initState() {
    super.initState();
    AppFutures.futurePurchaseHistory ??= fetchPurchaseRecords();
  }

  @override
  Widget build(context) {
    return FutureBuilder<List<PurchaseRecord>>(
      future: AppFutures.futurePurchaseHistory,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else if (snapshot.hasData) {
          PurchaseRecords.data ??= snapshot.data!;

          return ListView(
            children: [
              const SizedBox(height: 30),
              SvgPicture.asset('icons/history.svg', height: 80),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  'Purchase History',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              HistoryTable(history: PurchaseRecords.data!),
            ],
          );
        }
        return const Center(
          child: RepaintBoundary(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class HistoryTable extends StatelessWidget {
  const HistoryTable({super.key, required this.history});

  final List<PurchaseRecord> history;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataTextStyle: const TextStyle(fontSize: 12.5, color: LightColors.text),
      headingTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontSize: 13, color: LightColors.main),
      dividerThickness: 1.0,
      showBottomBorder: true,
      columnSpacing: 10,
      columns: const [
        DataColumn(label: Text('DATE')),
        DataColumn(label: Text('NAME')),
        DataColumn(label: Text('QUANTITY')),
        DataColumn(label: Text('ADDED')),
        DataColumn(label: Text('RATE')),
        DataColumn(label: Text('TOTAL')),
      ],
      rows: history.map((currentItem) {
        return DataRow(cells: [
          DataCell(Text(currentItem.date)),
          DataCell(
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  currentItem.name,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          DataCell(Text('${currentItem.previousQuantity}')),
          DataCell(Text(
            '${currentItem.addedQuantity}',
            style: const TextStyle(color: LightColors.main),
          )),
          DataCell(Text('₹${currentItem.rate}')),
          DataCell(Text(
            '₹${currentItem.totalPrice}',
            style: const TextStyle(color: LightColors.main),
          )),
        ]);
      }).toList(),
    );
  }
}
