import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_bakery/backend/cloud_storage.dart';

// common type of the best quantity

import '../colors.dart';
import 'my_widgets.dart';

class CurrentStockPage extends StatelessWidget {
  CurrentStockPage({Key? key}) : super(key: key);
  final stock = fetchIngredientsData();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(padding),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: const [
          // Expanded(
          //   child: SubmitBox(
          //     total: 22,
          //     desc: 'Items Stored In Good Quantity',
          //     background: LightColors.main,
          //     color: Colors.white,
          //   ),
          // ),
          // SizedBox(width: 14.0),
          // Expanded(
          //   child: SubmitBox(
          //     total: 3,
          //     desc: 'Items Finished Or Almost Finished',
          //     background: LightColors.red,
          //     color: Colors.white,
          //   ),
          // ),
          //   ],
          // ),
          // ),
          // const Image(
          //   width: 160.0,
          //   height: 160.0,
          //   image: AssetImage('images/cake.webp'),
          // ),
          // const SizedBox(height: 20.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
            child: Row(
              children: [
                Text(
                  'Ingredient in stock',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<dynamic>>(
            future: stock,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Icon(Icons.error, color: Colors.red);
              } else if (snapshot.hasData) {
                return StockList(list: snapshot.data!);
              }
              return const RepaintBoundary(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StockList extends StatelessWidget {
  const StockList({super.key, required this.list});

  final List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    final accentColors = AccentColors();

    final ingredientList = list[0] as List<Ingredient>;
    final snapshots = list[1] as List<Stream>;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: ingredientList.length,
      itemBuilder: (context, index) => GoodsTile(
        ingredient: ingredientList[index],
        stream: snapshots[index],
        avatarColor: accentColors.next,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 5.0),
    );
  }
}

class GoodsTile extends StatelessWidget {
  const GoodsTile({
    super.key,
    required this.ingredient,
    required this.stream,
    required this.avatarColor,
  });

  final Ingredient ingredient;
  final Color avatarColor;
  final Stream stream;

  void _openEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EditStockDialog(
          ingredient: ingredient,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      onTap: () => _openEditDialog(context),
      // tileColor: isOutOfStock ? LightColors.lightRed : null,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      leading: CircleAvatar(
        radius: 20.0,
        backgroundColor: avatarColor,
        child: Text(
          ingredient.name[0],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      title: Text(
        ingredient.name,
        style: textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Rate :',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(width: 5.0),
          const Text(
            '₹',
            style: TextStyle(color: LightColors.main, fontSize: 15.0 , ),
          ),
          StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final latestRate = (snapshot.data! as DocumentSnapshot<
                    Map<String, dynamic>>)['latestRate'] as num;
                return Text(
                  '$latestRate/${ingredient.unit}',
                  style: textTheme.bodyMedium,
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(width: 10.0),
          Text(
            'Avg :',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(width: 5.0),
          const Text(
            '₹',
            style: TextStyle(color: LightColors.main, fontSize: 15.0 , ),
          ),
          StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final avgRate = (snapshot.data! as DocumentSnapshot<
                    Map<String, dynamic>>)['averageRate'] as num;
                return Text(
                  '$avgRate/${ingredient.unit}',
                  style: textTheme.bodyMedium,
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      trailing: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final quantity = (snapshot.data!
                as DocumentSnapshot<Map<String, dynamic>>)['quantity'] as num;

            return quantity == 0
                ? const Icon(
                    Icons.warning_rounded,
                    color: LightColors.warningColor,
                    size: 30.0,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$quantity',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        ingredient.unit,
                        style: textTheme.bodyMedium?.copyWith(
                          color: LightColors.main,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class EditStockDialog extends StatelessWidget {
  EditStockDialog({
    super.key,
    required this.ingredient,
  });
  final Ingredient ingredient;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const extremeTextStyle = TextStyle(
      color: LightColors.main,
      fontSize: 16.0,
    );

    return AlertDialog(
      title: Text(
        ingredient.name,
        textAlign: TextAlign.center,
        style: textTheme.titleLarge?.copyWith(color: LightColors.textColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'You can add incoming ingredients in your inventory or edit current price per unit',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Form(
            key: _formKey,
            child: Column(
              children: [
                MyTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter additional quantity';
                    }
                    return null;
                  },
                  controller: quantityController,
                  label: 'Purchased Quantity',
                  suffix: Text(
                    ingredient.unit,
                    style: extremeTextStyle,
                  ),
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required total cost money';
                    }
                    return null;
                  },
                  controller: priceController,
                  label: 'Total Price',
                  prefix: const Text(
                    '₹',
                    style: extremeTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: LightColors.main,
                ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            final totalPrice = num.parse(priceController.text);
            final addedQuantity = num.parse(quantityController.text);

            num averageRate = double.parse(
              (((ingredient.averageRate * ingredient.quantity) + totalPrice) /
                      (ingredient.quantity + addedQuantity))
                  .toStringAsFixed(2),
            );

            Navigator.of(context).pop();

            updateIngredientDetails(
              ingredient,
              addedQuantity,
              totalPrice,
              averageRate,
            ).then((_) {
              ingredient.quantity += addedQuantity;
              ingredient.averageRate = averageRate;
              ingredient.latestRate = double.parse((totalPrice/addedQuantity).toStringAsFixed(2));
            });

            // quantityKey.currentState!.updateUi();
          },
          child: Text(
            'Done',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: LightColors.main,
                ),
          ),
        ),
      ],
    );
  }
}
