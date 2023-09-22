import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_management/Model/OrderModel.dart';
import 'package:order_management/Widgets/Item_List.dart';
import 'package:order_management/Widgets/SecondScreen/OrderDetailPage.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key, required this.data, required this.onLongPress});
  final List<OrderModels> data;
  final VoidCallback onLongPress;

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final orderModel = widget.data[index];
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () async {
            final updatedOrder = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderDetailPage(orderModels: orderModel)),
            );

            if (updatedOrder != null) {
              setState(() {
                // Find the index of the updated order and replace it with the new data
                final index = widget.data.indexOf(orderModel);
                  widget.data[index] = updatedOrder;
                  switch(updatedOrder){
                    case 'New':
                      {
                      _navigateToTab(0);
                      break;
                      }
                    case 'Remainder':
                      {
                        _navigateToTab(1);
                        break;
                      }
                    case 'Completed':
                      {
                        _navigateToTab(2);
                        break;
                      }
                  }
              });
            }
          },
          onLongPress: () {
            setState(() {
              // Set the selected index to the current index.
              selectedIndex = index;
            });
            // Call the provided onLongPress callback.
            widget.onLongPress();
          },
          child: ItemsList(
            orderModels: orderModel,
            selected: isSelected,
            longSelected: isSelected,
          ),
        );
      },
    );
  }

  void _navigateToTab(int tabIndex) {
    DefaultTabController.of(context).animateTo(tabIndex);
  }
}

