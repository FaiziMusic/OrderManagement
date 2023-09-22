import 'dart:io';

class OrderModels {
  OrderModels(
      {required this.orderNumbers,
      required this.orderDate,
      required this.supplierName,
      required this.status,
      this.comment,
      this.image});

  final int orderNumbers;
  final String supplierName;
  String status;
  final String orderDate;
  String? comment;
  Iterable<File?>? image;
}
