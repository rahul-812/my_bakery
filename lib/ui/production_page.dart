import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/product_model.dart';
import '../util.dart';
import '../backend/db_functions.dart';
import '../colors.dart';
import '../model/ingredient_model.dart';
import '../model/requirement_model.dart';
import 'my_widgets.dart';

class ButtonState extends ChangeNotifier {
  bool disabled = false;

  void deactivate(bool value) {
    if (disabled == value) return;
    disabled = value;
    notifyListeners();
  }
}

class ProductionPage extends StatefulWidget {
  const ProductionPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final batchController = TextEditingController(text: '1');
  //* packateController value must be greater than 1 otherwise calculaterate() will return infinity
  final packetController = TextEditingController(text: '1');
  late final List<Requirement> _requirements;
  final makeButtonState = ButtonState();

  @override
  void initState() {
    super.initState();
    _requirements = widget.product.requirements;

    for (var requirement in _requirements) {
      requirement.pController = TextEditingController(text: '0.0');
      if (requirement.quantity == null) continue;

      // Filtered only ingredients whose quantity is not null
      requirement
        ..ingredient = Ingredients.data!
            .singleWhere((ingredient) => ingredient.name == requirement.name)
        ..qController = TextEditingController(text: '${requirement.quantity}')
        ..pController = TextEditingController(
          text: '${requirement.quantity! * requirement.ingredient!.latestRate}',
        )
        ..hasEnough = requirement.quantity! <= requirement.ingredient!.quantity;
      if (!makeButtonState.disabled && !requirement.hasEnough!) {
        makeButtonState.disabled = true;
      }
    }
  }

  @override
  void dispose() {
    for (var element in _requirements) {
      element.pController?.dispose();
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
    bool canMakeProduct = true;

    for (var requirement in _requirements) {
      // Ignore if not ingredient
      if (requirement.quantity == null) continue;

      final requiredQuantity = requirement.quantity! * batch;
      final ifQuantityExceeds =
          requiredQuantity > requirement.ingredient!.quantity;

      // If not enough stock for this ingredient
      requirement.canDeductFromStock(!ifQuantityExceeds);

      if (ifQuantityExceeds) canMakeProduct = false;

      requirement.qController!.text = '$requiredQuantity';
      requirement.pController!.text =
          '${requiredQuantity * requirement.ingredient!.averageRate}';
    }
    makeButtonState.deactivate(!canMakeProduct);
  }

  num calculateRate() {
    num totalCost = 0;
    int totalPackets = packetController.text.toInt;
    for (var requirement in _requirements) {
      totalCost += requirement.pController!.text.toNum;
    }
    debugPrint(
        '[calculateRate()] total cost : $totalCost & total packets : $totalPackets');
    return double.parse((totalCost / totalPackets).toStringAsFixed(2));
  }

  Future<void> deductIngredients() async {
    //later we  will merge this functionility in the calculateRate()
    for (var requirement in _requirements) {
      if (requirement.quantity != null) {
        debugPrint(
            '[deductIngredients()] Deducting ${requirement.ingredient!.name}');
        await useIngredient(
            requirement.ingredient!, requirement.qController!.text.toNum);
      }
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
                    Text('Product stock', style: textTheme.bodyMedium),
                    const SizedBox(width: 11.0),
                    SvgPicture.asset('icons/tag.svg'),
                    Text(
                      '${widget.product.quantity}',
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Packets',
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
                      label: 'Total batches',
                      prefix: const Icon(FontAwesomeIcons.cubes, size: 20.0),
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: MyTextField(
                      controller: packetController,
                      label: 'Packets',
                      prefix: const Icon(FontAwesomeIcons.boxOpen, size: 16.0),
                    ),
                  ),
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
                itemBuilder: (_, index) => RequirementCard(
                  _requirements[index],
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 40.0),
        child: ChangeNotifierProvider.value(
          value: makeButtonState,
          child: Consumer<ButtonState>(
            builder: (_, makeButtonState, child) => MaterialButton(
              onPressed: makeButtonState.disabled
                  ? null
                  : () async {
                      num rate = calculateRate();
                      debugPrint('rate : $rate');
                      await deductIngredients();
                      await addProductStock('Hand Biscuit', widget.product.key,
                          packetController.text.toInt, rate);
                    },
              disabledColor: const Color(0xFFD8D8D8),
              elevation: 0.0,
              disabledTextColor: Colors.black,
              highlightElevation: 0.0,
              minWidth: double.infinity,
              shape: const StadiumBorder(),
              color: Colors.black87,
              height: 46.0,
              textColor: Colors.white,
              child: child,
            ),
            child: const Text('Make Product'),
          ),
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
      decoration: BoxDecoration(
        color: LightColors.greyCard,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFEBEDEE)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ChangeNotifierProvider.value(
        value: requirement,
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
                    // const Icon(FontAwesomeIcons.wheatAwn, size: 15.0),
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
                      child: Consumer<Requirement>(
                        builder: (_, requirement, __) => _RequirementTextField(
                          controller: requirement.qController,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: (requirement.hasEnough ?? false)
                                        ? null
                                        : LightColors.warning,
                                  ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        requirement.ingredient!.unit,
                        style: textTheme?.bodyMedium?.copyWith(fontSize: 13.0),
                      ),
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
                  const Icon(Icons.currency_rupee, size: 15.0),
                  SizedBox(
                    width: 50.0,
                    child: _RequirementTextField(
                      controller: requirement.pController,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            // if (!isIngredient) const Spacer(),
          ],
        ),
      ),
    );
  }
}
