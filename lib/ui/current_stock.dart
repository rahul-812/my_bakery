import 'package:flutter/material.dart';
import 'package:my_bakery/backend/cloud_storage.dart';

// common type of the best quantity

import '../colors.dart';
import 'stock_widgets.dart';

class CurrentStockPage extends StatelessWidget {
  CurrentStockPage({Key? key}) : super(key: key);
  final Future<List<Ingredient>> stock = fetchIngredientsData();

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
          FutureBuilder<List<Ingredient>>(
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

  final List<Ingredient> list;

  @override
  Widget build(BuildContext context) {
    final accentColors = AccentColors();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: list.length,
      itemBuilder: (context, index) => GoodsTile(
        ingredient: list[index],
        avatarColor: accentColors.next,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 5.0),
    );
  }
}

class GoodsTile extends StatelessWidget {
  GoodsTile({super.key, required this.ingredient, required this.avatarColor});

  final Ingredient ingredient;
  final Color avatarColor;
  final ingredientKey = GlobalKey<IngredientMonitorState>();

  void _openEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EditStockDialog(
          ingredient: ingredient,
          quantityKey: ingredientKey,
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
      subtitle: IngredientMonitor(key: ingredientKey, ingredient: ingredient),
    );
  }
}

class EditStockDialog extends StatelessWidget {
  EditStockDialog({
    super.key,
    required this.ingredient,
    required this.quantityKey,
  });
  final Ingredient ingredient;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final GlobalKey<IngredientMonitorState> quantityKey;

  final _formKey = GlobalKey<FormState>();

  Widget _buildTextField({
    Key? key,
    required TextEditingController controller,
    required String label,
    TextStyle? inputTextStyle,
    String? Function(String?)? validator,
    Widget? suffix,
    Widget? prefix,
  }) {
    return TextFormField(
      key: key,
      validator: validator,
      style: inputTextStyle,
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        border: const OutlineInputBorder(),
        prefix: prefix,
        suffix: suffix,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final inputTextStyle = textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w500,
    );
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
                _buildTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter additional quantity';
                    }
                    return null;
                  },
                  controller: quantityController,
                  label: 'Incoming Quantity',
                  inputTextStyle: inputTextStyle,
                  suffix: Text(
                    ingredient.subUnit,
                    style: extremeTextStyle,
                  ),
                ),
                const SizedBox(height: 10.0),
                _buildTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required total cost money';
                    }
                    return null;
                  },
                  controller: priceController,
                  label: 'Total Price',
                  inputTextStyle: inputTextStyle,
                  prefix: const Text(
                    '₹',
                    style: extremeTextStyle,
                  ),
                  suffix: Text(
                    '(per ${ingredient.subUnit})',
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
              (((ingredient.rate * ingredient.quantity) + totalPrice) /
                      (ingredient.quantity + addedQuantity))
                  .toStringAsFixed(2),
            );

            updateIngredientDetails(
              ingredient,
              addedQuantity,
              totalPrice,
              averageRate,
            );

            Navigator.of(context).pop();
            ingredient.quantity += addedQuantity;
            ingredient.rate = averageRate;
            quantityKey.currentState!.updateUi();
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
