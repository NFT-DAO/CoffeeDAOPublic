import 'package:cdao/models/orderModel.dart';
import 'package:flutter/material.dart';

Future<T?> showTextDialog<T>(BuildContext context,
        {required OrderModel order}) =>
    showDialog<T>(
      context: context,
      builder: (context) => TextDialogWidget(order: order),
    );

class TextDialogWidget extends StatefulWidget {
  final OrderModel order;

  const TextDialogWidget({Key? key, required this.order}) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController statusController;
  late TextEditingController nameController;
  late TextEditingController street1Controller;
  late TextEditingController street2Controller;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController trackingController;
  @override
  void initState() {
    super.initState();
    statusController = TextEditingController(text: widget.order.status);
    nameController = TextEditingController(text: widget.order.name);
    street1Controller = TextEditingController(text: widget.order.street1);
    street2Controller = TextEditingController(text: widget.order.street2);
    cityController = TextEditingController(text: widget.order.city);
    stateController = TextEditingController(text: widget.order.state);
    zipController = TextEditingController(text: widget.order.zip);
    emailController = TextEditingController(text: widget.order.email);
    phoneController = TextEditingController(text: widget.order.phone);
    trackingController = TextEditingController(text: widget.order.tracking);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.order.name),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SelectableText('''${widget.order.name}
${widget.order.street1}
${widget.order.street2}
${widget.order.city}
${widget.order.state}
${widget.order.zip}'''),
              const SizedBox(
                height: 15,
              ),
              const Text('Shipping Status'),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('Name'),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('Street 1'),
              TextField(
                controller: street1Controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('Street 2'),
              TextField(
                controller: street2Controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('City'),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('State'),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('Zip'),
              TextField(
                controller: zipController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('Email'),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('Phone'),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('Tracking ID'),
              TextField(
                controller: trackingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text('Done'),
            onPressed: () {
              Navigator.of(context).pop(OrderModel.fromMap({
                'id': widget.order.id,
                'name': nameController.text,
                'email': emailController.text,
                'phone': phoneController.text,
                'street1': street1Controller.text,
                'street2': street2Controller.text,
                'city': cityController.text,
                'state': stateController.text,
                'nft': widget.order.nft,
                'zip': widget.order.zip,
                'hash': widget.order.hash,
                'lastUpdate': widget.order.lastUpdate,
                'status': statusController.text,
                'tracking': trackingController.text,
                'shippingEmailSent': widget.order.shippingEmailSent,
                'selected': widget.order.selected,
                'valid': widget.order.valid
              }));
            },
          )
        ],
      );
}
