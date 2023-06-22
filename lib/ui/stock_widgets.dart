import 'package:flutter/material.dart';
import 'package:my_bakery/backend/cloud_storage.dart';

import '../colors.dart';

class IngredientMonitor extends StatefulWidget {
  const IngredientMonitor({
    super.key,
    required this.ingredient,
  });

  final Ingredient ingredient;

  @override
  State<IngredientMonitor> createState() => IngredientMonitorState();
}

class IngredientMonitorState extends State<IngredientMonitor> {
  void updateUi() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isOutOfStock = widget.ingredient.quantity == 0;
    final ingredient = widget.ingredient;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              '₹',
              style: TextStyle(color: LightColors.main, fontSize: 16.0),
            ),
            Text(
              '${ingredient.rate}/${ingredient.subUnit}',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
        isOutOfStock
            ? const Icon(
                Icons.warning_rounded,
                color: LightColors.brown,
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
                  Text(
                    ingredient.subUnit,
                    style: textTheme.bodyMedium?.copyWith(
                      color: LightColors.main,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
