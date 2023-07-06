import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_bakery/main.dart';
import 'package:my_bakery/model/requirement_model.dart';
import 'package:my_bakery/ui/current_stock.dart';
import 'package:my_bakery/ui/department.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../backend/cloud_storage.dart';
import '../colors.dart';
import '../model/ingredient_model.dart';
import 'my_widgets.dart';

class ProductionPage extends StatefulWidget {
  const ProductionPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final batchController = TextEditingController(text: '1');

  late final List<Requirement> _requirements;

  @override
  void initState() {
    super.initState();
    _requirements = widget.product.requirements;

    for (var requirement in _requirements) {
      if (requirement.quantity == null) continue;

      // Filtered only ingredients whose quantity is not null
      requirement.associatedIngredient = Ingredients.data!
          .singleWhere((ingredient) => ingredient.name == requirement.name);
      requirement.qController =
          TextEditingController(text: '${requirement.quantity}');
      requirement.isEnough =
          requirement.quantity! <= requirement.associatedIngredient!.quantity;
    }
  }

  @override
  void dispose() {
    for (var element in _requirements) {
      if (element.qController != null) {
        element.qController?.dispose();
        element.qController = null;
      }
    }
    super.dispose();
  }

  void _onTextChange(String text) {
    if (text.isEmpty) return;

    final batch = text.toInt;

    for (var requirement in _requirements) {
      // Ignore if not ingredient
      if (requirement.quantity == null) continue;

      final requiredQuantity = requirement.quantity! * batch;
      // If not enough stock for this ingredient
      if (requiredQuantity > requirement.associatedIngredient!.quantity) {
        requirement.haveEnoughInStock(false);
      } else {
        requirement.haveEnoughInStock(true);
      }

      requirement.qController!.text = '$requiredQuantity';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Production'),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.product.name,
                  style: textTheme.bodyLarge?.copyWith(fontSize: 22.0),
                ),
              ),
              Center(
                child: Wrap(
                  spacing: 3.5,
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Product stock',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 11.0),
                    SvgPicture.asset('icons/tag.svg'),
                    Text(
                      '46',
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Batches',
                      style: textTheme.bodyMedium?.copyWith(fontSize: 11.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35.0),
              Text(
                "Today's production",
                style: textTheme.bodyLarge?.copyWith(
                  fontSize: 15.0,
                  // color: LightColors.main,
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      onChanged: _onTextChange,
                      controller: batchController,
                      hint: 'Total batches',
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  const Expanded(child: MyTextField(hint: 'Packets')),
                ],
              ),
              const SizedBox(height: 35.0),
              Text(
                "Ingredients used",
                style: textTheme.bodyLarge?.copyWith(
                  fontSize: 15.0,
                  // color: LightColors.main,
                ),
              ),
              const SizedBox(height: 12.0),
              ListView.separated(
                padding: const EdgeInsets.only(bottom: 20.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _requirements.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                itemBuilder: (_, index) {
                  return RequirementCard(
                    _requirements[index],
                    textTheme: textTheme,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 40.0),
        child: MaterialButton(
          onPressed: () {},
          disabledColor: const Color(0xFFD8D8D8),
          elevation: 0.0,
          disabledTextColor: Colors.black,
          highlightElevation: 0.0,
          minWidth: double.infinity,
          shape: const StadiumBorder(),
          color: const Color(0xFF3E4341),
          height: 46.0,
          textColor: Colors.white,
          child: const Text('Make Product'),
        ),
      ),
    );
  }
}

class _RequirementTextField extends StatelessWidget {
  const _RequirementTextField({this.controller, this.style});

  final TextEditingController? controller;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      style: style,
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.all(0.0),
      ),
    );
  }
}

class RequirementCard extends StatelessWidget {
  const RequirementCard(
    this.requirement, {
    super.key,
    this.textTheme,
  });

  final TextTheme? textTheme;
  final Requirement requirement;

  @override
  Widget build(BuildContext context) {
    final isIngredient = requirement.qController != null;

    return Container(
      // height: 110.0,
      decoration: BoxDecoration(
        color: LightColors.greyCard,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFEBEDEE)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE4E7E9)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.wheatAwn, size: 15.0),
                  const SizedBox(width: 10.0),
                  Text(
                    requirement.name,
                    overflow: TextOverflow.fade,
                    style: textTheme?.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isIngredient)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Used', style: textTheme?.bodyMedium),
                  const Spacer(),
                  const Icon(
                    FontAwesomeIcons.arrowDown,
                    size: 12.0,
                    color: LightColors.warning,
                  ),
                  SizedBox(
                    width: 35.0,
                    child: ChangeNotifierProvider.value(
                      value: requirement,
                      child: Consumer<Requirement>(
                        builder: (_, requirement, __) {
                          return _RequirementTextField(
                            controller: requirement.qController,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: (requirement.isEnough ?? false)
                                      ? null
                                      : LightColors.warning,
                                ),
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    'KG',
                    style: textTheme?.bodyMedium?.copyWith(fontSize: 13.0),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 5.0,
            ),
            child: Row(
              children: [
                Text('Cost', style: textTheme?.bodyMedium),
                const Spacer(),
                const Icon(
                  Icons.currency_rupee,
                  size: 15.0,
                ),
                Text(
                  '23.00',
                  style: textTheme?.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // if (!isIngredient) const Spacer(),
        ],
      ),
    );
  }
}
