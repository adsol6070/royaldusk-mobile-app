class Package {
  int? id;
  String? name;
  String? image;
  String? price;
  String? location;
  String? details;

  Package(
      {required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.location,
      required this.details});

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    location = json['location'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['price'] = price;
    data['location'] = location;
    data['details'] = details;
    return data;
  }
}
