class NftDBModel {
  late String? id;
  late String? arweaveId;
  late String? wmImageUrl;
  late bool? available;
  late String? transactionId;

  NftDBModel({
    this.id,
    this.arweaveId,
    this.wmImageUrl,
    this.available,
    this.transactionId,
  });

  Map toMap(NftDBModel entry) {
    var data = <String, dynamic>{};
    data["id"] = entry.id;
    data["arweaveId"] = entry.arweaveId;
    data["wmImageUrl"] = entry.wmImageUrl;
    data["available"] = entry.available;
    data["transactionId"] = entry.transactionId;
    return data;
  }

  NftDBModel.fromRTDB(mapData) {
    id = mapData["id"];
    arweaveId = mapData["arweaveId"];
    wmImageUrl = mapData["wmImageUrl"];
    available = mapData["available"];
    transactionId = mapData["transactionId"];
  }

  NftDBModel.fromMap(mapData) {
    id = mapData["id"];
    arweaveId = mapData["arweaveId"];
    wmImageUrl = mapData["wmImageUrl"];
    available = mapData["available"];
    transactionId = mapData["transactionId"];
  }
}
