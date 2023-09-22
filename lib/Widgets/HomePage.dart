import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:order_management/Model/OrderModel.dart';
import 'package:order_management/Widgets/Orders_List.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<OrderModels> data = [];
  bool isLoading = true;
  bool isLongPressed = false;
  List<OrderModels> newOrder = [];
  List<OrderModels> remainderOrder = [];
  List<OrderModels> completedOrder = [];

  Future<List<OrderModels>> loadCSV() async {
    try {
      final rawData = await rootBundle.loadString('assets/orders.csv');
      List<List<dynamic>> listData = const CsvToListConverter(
        fieldDelimiter: ';', // Specify the delimiter used in your CSV
      ).convert(rawData);

      // Skip the header row and process the rest of the data
      List<OrderModels> flatData = listData.skip(1).map((orderData) {
        return OrderModels(
          orderNumbers: int.parse(orderData[0].toString()),
          orderDate: DateFormat.yMd().format(DateFormat.yMd().parse(orderData[1])),
          supplierName: orderData[2].toString(),
          status: orderData[3].toString(),
        );
      }).toList();
      // Store the processed data in the data list
      data = flatData;
      return data;
    } catch (e) {
      Text("Error loading CSV: $e");
      return []; // or handle the error case as needed
    }
  }

  void setDefaultStatus(List<OrderModels> orders) {
    for (var order in orders) {
      order.status = 'New';
    }
  }

  Future<void> loadData() async {
    try {
      List<OrderModels> loadedData = await loadCSV();
      setState(() {
        data = loadedData;
        isLoading = false;
        setDefaultStatus(data); // Set the default status to "New"
      });
    } catch (e) {
      Text("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  void initState() {
    loadData();
    super.initState();
  }

  //Working of an App Bar button here
  void toggleLongPressed() {
    setState(() {
      isLongPressed = !isLongPressed;
    });
  }

  appBarButton() {
    if (isLongPressed) {
      return AppBar(
        title: const Text('Order Management'),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
          IconButton(
            onPressed: () {
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isLongPressed = false; // Reset the state
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ), // Add a close icon
          ),
        ],
      );
    } else {
      return AppBar(
        title: const Text('Order Management'),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
      );
    }
  }

  FutureBuilder<void> buildOrdersList(String status, List<OrderModels> data, toggleLongPressed) {
    return FutureBuilder<void>(
      future: Future.delayed(const Duration(seconds: 1)), // Replace with your actual data loading logic
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<OrderModels> filteredOrders = data.where((order) => order.status == status).toList();
          // print('Filtered Order is : $filteredOrders');
          return OrdersList(data: filteredOrders, onLongPress: toggleLongPressed);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: appBarButton(),
          body: Column(
            children: [
              const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Color.fromARGB(98, 12, 12, 12),
                  tabs: [
                    Tab(
                      text: "New",
                    ),
                    Tab(
                      text: "Remainder",
                    ),
                    Tab(
                      text: "Completed",
                    )
                  ]),
              Expanded(
                child: TabBarView(
                    children: [
                      buildOrdersList('New', data, toggleLongPressed),
                      buildOrdersList('Remainder', data, toggleLongPressed),
                      buildOrdersList('Completed', data, toggleLongPressed),
                    ]),
              )],
          ),
        )
    );
  }
}
