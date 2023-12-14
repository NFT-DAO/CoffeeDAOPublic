class OrderModel {
  bool selected = false;
  late String id;
  late String name;
  late String email;
  late String? phone;
  late String street1;
  late String? street2;
  late String city;
  late String state;
  late String nft;
  late String zip;
  late String hash;
  late String lastUpdate;
  late String status;
  late String? tracking;
  late bool shippingEmailSent;
  bool valid = false;

  OrderModel(
      {this.selected = false,
      required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.street1,
      required this.street2,
      required this.city,
      required this.state,
      required this.zip,
      required this.nft,
      required this.hash,
      required this.lastUpdate,
      required this.status,
      required this.tracking,
      required this.shippingEmailSent,
      this.valid = false});

  Map toMap(OrderModel order) {
    var data = <String, dynamic>{};
    data["selected"] = order.selected;
    data["id"] = order.id;
    data["name"] = order.name;
    data["email"] = order.email;
    data["phone"] = order.phone;
    data["street1"] = order.street1;
    data["street2"] = order.street2;
    data["city"] = order.city;
    data["state"] = order.state;
    data["zip"] = order.zip;
    data["nft"] = order.nft;
    data["hash"] = order.hash;
    data["lastUpdate"] = order.lastUpdate;
    data["status"] = order.status;
    data["tracking"] = order.tracking;
    data["valid"] = order.valid;
    data["shippingEmailSent"] = order.shippingEmailSent;
    return data;
  }

  OrderModel.fromMap(Map<String, dynamic> mapData) {
    selected = mapData["selected"];
    id = mapData["id"];
    name = mapData["name"];
    email = mapData["email"];
    if (mapData["phone"] == null) {
      phone = '';
    } else {
      phone = mapData["phone"];
    }
    street1 = mapData["street1"];
    if (mapData["street2"] == null) {
      street2 = '';
    } else {
      street2 = mapData["street2"];
    }
    state = mapData["state"];
    valid = mapData["valid"];
    city = mapData["city"];
    zip = mapData["zip"];
    nft = mapData["nft"];
    hash = mapData["hash"];
    status = mapData["status"];
    if (mapData["tracking"] == null) {
      tracking = '';
    } else {
      tracking = mapData["tracking"];
    }
    shippingEmailSent = mapData["shippingEmailSent"];
    lastUpdate = mapData["lastUpdate"].toString();
  }

  OrderModel.fromJson(Map<String, dynamic> mapData) {
    selected = mapData["selected"];
    id = mapData["id"];
    name = mapData["name"];
    email = mapData["email"];
    valid = mapData["valid"];
    if (mapData["phone"] == null) {
      phone = '';
    } else {
      phone = mapData["phone"];
    }
    street1 = mapData["street1"];
    if (mapData["street2"] == null) {
      street2 = '';
    } else {
      street2 = mapData["street2"];
    }
    state = mapData["state"];
    city = mapData["city"];
    zip = mapData["zip"];
    nft = mapData["nft"];
    hash = mapData["hash"];
    status = mapData["status"];
    if (mapData["tracking"] == null) {
      tracking = '';
    } else {
      tracking = mapData["tracking"];
    }
    shippingEmailSent = mapData["shippingEmailSent"];
    lastUpdate = mapData["lastUpdate"].toString();
  }
}
