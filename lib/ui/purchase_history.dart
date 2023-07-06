import 'package:flutter/material.dart';
import 'package:my_bakery/backend/cloud_storage.dart';

class PurchaseHistoryPage extends StatelessWidget {
  PurchaseHistoryPage({super.key});
  
  final Future<Iterable<PurchaseHistory>> _futurePurchaseHistory =
      fetchPurchaseRecords(DateTime(2023, 6, 13), DateTime.now());

  @override
  Widget build(context) {
    return FutureBuilder<Iterable<PurchaseHistory>>(
      future: _futurePurchaseHistory,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Icon(Icons.error);
        } else if (snapshot.hasData) {
          debugPrint("List: ${snapshot.data!.length}");
          return ListView(
            children: [
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  'Purchase History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.deepPurpleAccent,
                      ),
                ),
              ),
              HistoryTable(history: snapshot.data!),
            ],
          );
        }
        return const RepaintBoundary(child: CircularProgressIndicator());
      },
    );
  }
}

class HistoryTable extends StatelessWidget {
  const HistoryTable({super.key, required this.history});

  final Iterable<PurchaseHistory> history;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataTextStyle: const TextStyle(
        fontSize: 12.5,
        color: Colors.grey,
      ),
      headingTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
          color: Colors.deepPurpleAccent),
      dividerThickness: 0.0,
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
      rows: List.generate(history.length, (index) {
        final currentItem = history.elementAt(index);
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
          DataCell(Text('${currentItem.addedQuantity}')),
          DataCell(Text('₹${currentItem.rate}')),
          DataCell(Text('₹${currentItem.totalPrice}')),
        ]);
      }),
    );
  }
}
