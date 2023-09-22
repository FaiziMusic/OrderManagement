import 'package:flutter/material.dart';
import 'package:order_management/Model/OrderModel.dart';

class ItemsList extends StatefulWidget {
  const ItemsList(
      {super.key,
        required this.orderModels,
        required this.selected,
        required this.longSelected});

  final OrderModels orderModels;
  final bool selected;
  final bool longSelected;

  @override
  createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.orderModels.orderNumbers.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  widget.orderModels.orderDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.orderModels.supplierName.toString(),
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w100),
                ),
                const Spacer(),
                Text(
                  widget.orderModels.status.toString(),
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w100),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
