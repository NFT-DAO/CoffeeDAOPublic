class OrderConstructorModel {
  late String? tx;
  late String? witness;
  late String? error;

  OrderConstructorModel({
    this.tx,
    this.witness,
    this.error,
  });

  Map toMap(OrderConstructorModel order) {
    var data = <String, dynamic>{};
    data["tx"] = order.tx;
    data["witness"] = order.witness;
    data["error"] = order.error;
    return data;
  }

  OrderConstructorModel.fromMap(Map<String, dynamic> mapData) {
    tx = mapData["tx"];
    witness = mapData["witness"];
    error = mapData["error"];
  }
}
