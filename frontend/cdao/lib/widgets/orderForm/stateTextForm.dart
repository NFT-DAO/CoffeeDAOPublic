import 'package:flutter/material.dart';

class StateTextForm extends StatefulWidget {
  TextEditingController state;
  String stateError;
  bool isSubmitting;
  StateTextForm(
      {required this.state,
      required this.stateError,
      required this.isSubmitting,
      super.key});

  @override
  State<StateTextForm> createState() => _StateTextFormState();
}
class _StateTextFormState extends State<StateTextForm> {
  List<String> states = [
    "AL",
    "AZ",
    "AR",
    "CA",
    "CO",
    "CT",
    "DE",
    "DC",
    "FL",
    "GA",
    "ID",
    "IL",
    "IN",
    "IA",
    "KS",
    "KY",
    "LA",
    "ME",
    "MT",
    "NE",
    "NV",
    "NH",
    "NJ",
    "NM",
    "NY",
    "NC",
    "ND",
    "OH",
    "OK",
    "OR",
    "MD",
    "MA",
    "MI",
    "MN",
    "MS",
    "MO",
    "PA",
    "RI",
    "SC",
    "SD",
    "TN",
    "TX",
    "UT",
    "VT",
    "VA",
    "WA",
    "WV",
    "WI",
    "WY"
  ];
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('state'),
      // initialValue: city,
      controller: widget.state,
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: true,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty || !states.contains(value)) {
          widget.stateError = '''Please enter your city or town's name.''';
          widget.isSubmitting = false;
          setState(() {});
          return widget.stateError;
        } else {
          widget.stateError = '';
          setState(() {});
          return null;
        }
      },
      decoration: const InputDecoration(
        labelText: 'State',
      ),
    );
  }
}
