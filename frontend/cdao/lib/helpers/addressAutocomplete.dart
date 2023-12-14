import 'dart:convert';

// This class parses the backend cloudRun addressAutoComplete responses for the order form page.
class AddressAutocomplete {
  final String? description;
  final StructuredFormatting? structuredFormatting;
  final String? placeId;
  final String? reference;
  AddressAutocomplete(
      {this.description,
      this.placeId,
      this.reference,
      this.structuredFormatting});
  factory AddressAutocomplete.fromJson(Map<String, dynamic> json) {
    return AddressAutocomplete(
        description: json['description'] as String?,
        placeId: json['place_id'] as String?,
        reference: json['reference'] as String?,
        structuredFormatting: json['structured_formatting'] != null
            ? StructuredFormatting.fromJson(json['structured_formatting'])
            : null);
  }
}

class StructuredFormatting {
  String? mainText;
  String? secondaryText;
  StructuredFormatting({this.mainText, this.secondaryText});
  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
        mainText: json['main_text'], secondaryText: json['secondary_text']);
  }
}

class PlacesAutocompleteResponse {
  List<AddressAutocomplete>? predictions;
  String? status;
  PlacesAutocompleteResponse({this.predictions, this.status});
  factory PlacesAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlacesAutocompleteResponse(
        predictions: json['predictions']
            ? json['predictions']
                .map<AddressAutocomplete>(
                    (i) => AddressAutocomplete.fromJson(i))
                .toList()
            : null,
        status: json['status']);
  }

  static PlacesAutocompleteResponse parseAutocompleteResult(String respBody) {
    final parsed = json.decode(respBody).cast<String, dynamic>();
    return PlacesAutocompleteResponse.fromJson(parsed);
  }
}
