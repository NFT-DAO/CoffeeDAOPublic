class MintResponseModel {
  late String? txhash;
  late String? error;

  MintResponseModel({
    this.txhash,
    this.error,
  });

  Map toMap(MintResponseModel order) {
    var data = <String, dynamic>{};
    data["txhash"] = order.txhash;
    data["error"] = order.error;
    return data;
  }

  MintResponseModel.fromMap(Map<String, dynamic> mapData) {
    txhash = mapData["txhash"];
    error = mapData["error"];
  }
}
