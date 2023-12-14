import 'package:flutter/material.dart';

class WalletSelector extends StatefulWidget {
  TextEditingController wallet;
  String walletError;
  bool isSubmitting;
  WalletSelector({required this.wallet, required this.walletError, required this.isSubmitting, super.key});

  @override
  State<WalletSelector> createState() => _WalletSelectorState();
}

class _WalletSelectorState extends State<WalletSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
          'What Cardano Wallet Do You Want To Use?',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 30),),
      const SizedBox(height: 12),
      const Text("NAMI, LACE, YOROI, ETERNL, FLINT, TYPHON"),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
      key: const ValueKey('wallet'),
      dropdownColor: Colors.white,
      autofocus: true,
      isExpanded: false,
      isDense: false,
      iconSize: 10,
      elevation: 5,
      decoration: const InputDecoration(
        labelText: 'Wallet',
      ),
      onChanged: (w) {
        setState(() => widget.wallet.text = w as String);
      },
      value: "NAMI",
      validator: (value) {
        if (value == null) {
          widget.walletError = 'Field Required';
          widget.isSubmitting = false;
          setState(() {});
          return widget.walletError;
        } else {
          return null;
        }
      },
      alignment: AlignmentDirectional.center,
      items: [
        "NAMI",
        "LACE",
        "YOROI",
        "ETERNL",
        "FLINT",
        "TYPHON",
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    )
    ],);
  }
}