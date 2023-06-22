import 'package:flutter/material.dart';
import 'package:my_bakery/backend/cloud_storage.dart';
import 'package:my_bakery/colors.dart';

class PurchaseHistoryPage extends StatelessWidget {
  PurchaseHistoryPage({super.key});

  final Future<List<PurchaseHistory>> _futurePurchaseHistory =
      fetchPurchaseRecords(DateTime(2023, 6, 19), DateTime(2023, 6, 13));

  @override
  Widget build(context) {
    return FutureBuilder<List<PurchaseHistory>>(
      future: _futurePurchaseHistory,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Icon(Icons.error);
        } else if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: 5,
            itemBuilder: (context, index) => PurchaseHistoryTile(
              history: snapshot.data![index],
            ),
          );
        }
        return const RepaintBoundary(child: CircularProgressIndicator());
      },
    );
  }
}

class PurchaseHistoryTile extends StatelessWidget {
  const PurchaseHistoryTile({super.key, required this.history});

  final PurchaseHistory history;

  // Widget _buildTile({required Widget leading, required Widget trailing}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [leading, trailing],
  //     ),
  //   );
  // }

  // Widget _buildTemplateProps({
  //   required String key,
  //   required String value,
  //   TextTheme? textTheme,
  // }) {
  //   return _buildTile(
  //     leading: Text(key, style: textTheme?.bodyMedium),
  //     trailing: Text(
  //       value,
  //       style: textTheme?.bodyMedium?.copyWith(
  //         color: LightColors.green,
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFB8B7B9), offset: Offset(0, 2), blurRadius: 9.0)
        ],
        color: LightColors.cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Brown Sugar',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HistoryTable(history: history),
          )
          // const Divider(),
          // _buildTemplateProps(key: 'Incoming Amount', value: '+23 KG'),
          // _buildTemplateProps(key: 'Stock Amount', value: '345 KG'),
          // _buildTemplateProps(key: 'Rate', value: '₹345/kg'),
          // _buildTemplateProps(key: 'Total Price', value: '₹898'),
        ],
      ),
    );
  }
}

class HistoryTable extends StatelessWidget {
  const HistoryTable({super.key, required this.history});

  final PurchaseHistory history;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Incoming Amount')),
        DataColumn(label: Text('Stock Amount')),
        DataColumn(label: Text('Rate')),
        DataColumn(label: Text('Total Pri)ce')),
      ],
      rows: List.generate(
          4,
          (index) => DataRow(cells: [
                DataCell(Text(history.name)),
                DataCell(Text('₹564/Lit')),
                DataCell(Text('₹564/Lit')),
                DataCell(Text('₹564/Lit')),
                DataCell(Text('₹564/Lit')),
              ])),
    );
  }
}
