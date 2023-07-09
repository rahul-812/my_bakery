import 'package:flutter/material.dart';
import 'package:my_bakery/backend/db_functions.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../model/ingredient_model.dart';
import 'my_widgets.dart';
import '../util.dart';

class CurrentStockPage extends StatefulWidget {
  const CurrentStockPage({Key? key}) : super(key: key);

  @override
  State<CurrentStockPage> createState() => _CurrentStockPageState();
}

class _CurrentStockPageState extends State<CurrentStockPage> {
  late final Future<Iterable<Ingredient>> _futureStock;

  @override
  void initState() {
    super.initState();
    _futureStock = fetchIngredientsData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<Ingredient>>(
      future: _futureStock,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error, color: Colors.red);
        } else if (snapshot.hasData) {
          // Globally accessible
          Ingredients.data ??= snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 18.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Ingredient in stock',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                StockList(list: snapshot.data!),
              ],
            ),
          );
        }
        return const Center(
          child: RepaintBoundary(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class StockList extends StatelessWidget {
  const StockList({super.key, required this.list});

  final Iterable<Ingredient> list;

  @override
  Widget build(BuildContext context) {
    final accentColors = AccentColors();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
      itemCount: list.length,
      itemBuilder: (context, index) => GoodsTile(
        ingredient: list.elementAt(index),
        avatarColor: accentColors.next,
      ),
      separatorBuilder: (_, __) => const Divider(),
    );
  }
}

class GoodsTile extends StatelessWidget {
  const GoodsTile({
    super.key,
    required this.ingredient,
    required this.avatarColor,
  });

  final Ingredient ingredient;
  final Color avatarColor;

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

    return ChangeNotifierProvider.value(
      value: ingredient,
      child: ListTile(
        onTap: () => _openEditDialog(context),
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
          children: [
            Text('Rate :', style: textTheme.bodyMedium),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(
                Icons.currency_rupee_rounded,
                size: 15.0,
                color: LightColors.main,
              ),
            ),
            Consumer<Ingredient>(
              builder: (context, ingredient, child) => Text(
                '${ingredient.averageRate}/${ingredient.unit}',
                style: textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        trailing: Consumer<Ingredient>(
          builder: (context, ingredient, child) => ingredient.quantity == 0
              ? const Icon(
                  Icons.warning_rounded,
                  color: LightColors.warning,
                  size: 30.0,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${ingredient.quantity}',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    child!,
                  ],
                ),
          child: Text(
            ingredient.unit,
            style: textTheme.bodyMedium?.copyWith(
              color: LightColors.main,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
  final TextEditingController costController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _onDone(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final totalPrice = costController.text.toNum;
    final addedQuantity = quantityController.text.toNum;

    Navigator.of(context).pop();

    final num averageRate =
        (((ingredient.averageRate * ingredient.quantity) + totalPrice) /
                (ingredient.quantity + addedQuantity))
            .toStringAsFixed(2)
            .toNum;

    addIngredientStockls(ingredient, addedQuantity, totalPrice, averageRate)
        .then((_) {
      ingredient.increaseQuantity(addedQuantity);
      ingredient.updateAverageRate(averageRate);
      ingredient.updateLatestRate(
        (totalPrice / addedQuantity).toStringAsFixed(2).toNum,
      );
    });
  }

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
        style: textTheme.titleLarge?.copyWith(color: LightColors.text),
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
                  controller: costController,
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
          onPressed: () => _onDone(context),
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
