import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../helpers/addressAutocomplete.dart';

class AddressController extends StatefulWidget {
  TextEditingController city;
  TextEditingController state;
  TextEditingController zip;
  TextEditingController addresscontroller;
  TextEditingController street1;
  bool isSubmitting;
  bool addressShow;
  AddressController(
      {required this.zip,
      required this.city,
      required this.state,
      required this.street1,
      required this.addresscontroller,
      required this.isSubmitting,
      required this.addressShow,
      super.key});

  @override
  State<AddressController> createState() => _AddressControllerState();
}

class _AddressControllerState extends State<AddressController> {
  List<AddressAutocomplete> placePredictions = [];

  Future<void> _setForm(String address) async {
    widget.addresscontroller.text = address;
    List<String> addSplit = address.split(', ');
    widget.street1.text = addSplit.elementAt(0);
    widget.city.text = addSplit.elementAt(1);
    widget.state.text = addSplit.elementAt(2);
    widget.addressShow = false;
    String x = jsonEncode(<String, String>{
      'street': addSplit.elementAt(0),
      'city': addSplit.elementAt(1),
      'state': addSplit.elementAt(2)
    });
    // Calls the cloud run server backend/cloudRun/addressAutoComplete
    final resp =
        await http.post(Uri.parse('${const String.fromEnvironment('ADDR_AUTO_COMPLETE_URL_BASE')}/zip'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: x);
    if (resp.body != 'error') {
      widget.zip.text = resp.body;
    }
    setState(() {});
  }

  // Calls the cloud run server backend/cloudRun/addressAutoComplete
  Future<void> placesAutoComplete(String query) async {
    final resp =
        await http.post(Uri.parse('${const String.fromEnvironment('ADDR_AUTO_COMPLETE_URL_BASE')}/ac'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{'entry': query}));
    if (resp.statusCode == 200) {
      PlacesAutocompleteResponse result =
          PlacesAutocompleteResponse.parseAutocompleteResult(resp.body);
      if (result.predictions != null) {
        widget.addressShow = true;
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.addresscontroller,
          onChanged: (value) {
            placesAutoComplete(value);
          },
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
              labelText: "Input your shipping address",
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Icon(Icons.pin_drop),
              )),
        ),
        !widget.addressShow
            ? const SizedBox(
                height: 0,
              )
            : SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: placePredictions.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        _setForm(placePredictions[index].description!);
                      },
                      leading: const Icon(Icons.map),
                      title: Text(placePredictions[index].description!,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
