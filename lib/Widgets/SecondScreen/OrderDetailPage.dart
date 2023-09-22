import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Model/OrderModel.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.orderModels});
  final OrderModels orderModels;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _showTextField = false;
  ImagePicker imagePicker = ImagePicker();
  List<File?> images = List.generate(4, (_) => null); // Store selected images
  bool isButtonActive = false;
  late TextEditingController controller;
  List<OrderModels> data = [];
  List<OrderModels> newOrder = [];
  List<OrderModels> remainderOrder = [];
  List<OrderModels> completedOrder = [];

  _bottomSheet(int index) {
    if (images[index] == null) {
      showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        _getFromGallery(index);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.image, size: 70),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        _getFromCamera(index);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.camera_alt, size: 70),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        _getFromGallery(index);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.image, size: 70),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            images[index] = null;
                            if (images[index] == null) {
                              isButtonActive = false;
                            }
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 85,
                          color: Colors.red,
                        )),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        _getFromCamera(index);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.camera_alt, size: 70),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }

  _getFromGallery(int index) async {
    XFile? pickedImage =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        images[index] = File(pickedImage.path);
        isButtonActive = true;
      });
    } else {
      setState(() {
        isButtonActive = false;
      });
    }
  }

  _getFromCamera(int index) async {
    XFile? pickedImage =
    await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        images[index] = File(pickedImage.path);
        isButtonActive = true;
      });
    } else {
      setState(() {
        isButtonActive = false;
      });
    }
  }

  bool isAnyImageSelected() {
    for (int i = 0; i < images.length; i++) {
      if (images[i] != null) {
        return true;
      }
    }
    return false;
  }

  // Comment Box Controller for save button
  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(() {
      final isTextButtonActive = controller.text.isNotEmpty;
      setState(() {
        isButtonActive = isTextButtonActive;
        widget.orderModels.comment = controller.text;
      });

      if (isAnyImageSelected()) {
        setState(() {
          isButtonActive = true;
        });
      }
    });
    super.initState();
  }

  void saveButton() {
    final comment = controller.text;
    final image = images.where((image) => image != null);
    if (controller.text.isEmpty && isAnyImageSelected()) {
      setState(() {
        widget.orderModels.status = 'Remainder';
        widget.orderModels.comment = comment.toString();
        widget.orderModels.image = image.toList();
      });
    } else if (controller.text.isNotEmpty || isAnyImageSelected()) {
      setState(() {
        widget.orderModels.status = 'Completed';
        widget.orderModels.comment = comment.toString();
        widget.orderModels.image = image.toList();
      });
    }
  }

  _navigate(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
        actions: [
          ElevatedButton(
            onPressed: isButtonActive
                ? () {
              isButtonActive = false;
              saveButton();
              setState(() {
                Navigator.pop(context, widget.orderModels);
                print(widget.orderModels.status);
              });
            } : null,
            child: const Text('Save'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Text(
                      'Order Number : ',
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    Text(
                      widget.orderModels.orderNumbers.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Order Date : ',
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    Text(
                      widget.orderModels.orderDate.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Supplier Name : ',
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    Text(
                      widget.orderModels.supplierName.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Status : ',
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    Text(
                      widget.orderModels.status.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    ElevatedButton(onPressed: () {}, child: const Text('data')),
                    const Spacer(),
                    Switch(
                        value: _showTextField,
                        onChanged: (value) {
                          setState(() {
                            _showTextField = value;
                          });
                        })
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Visibility(
                  visible: _showTextField,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: controller,
                      maxLines: 4,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        label: Text(
                          'Comment Box',
                        ),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                        hintText: 'Type your comment here...',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    Text(
                      'Select an Image: ',
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 4; i++)
                      GestureDetector(
                        onTap: () {
                          _bottomSheet(i);
                        },
                        child: Container(
                          height: 100,
                          width: 75,
                          color: Colors.black12,
                          child: images[i] != null
                              ? Image.file(images[i]!)
                              : const Icon(Icons.add),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
