

class Search {
  int? id;
  String? name;
  String? image;
  String? location;
  String? review;
  String? price;
  double? rating;

  Search.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }

    if (json['image'] != null) {
      image = json['image'];
    }
    if (json['review'] != null) {
      review = json['review'];
    }

    name = json['name'];
    price = json['price'];
    location = json['location'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (data['id'] != null) {
      data['id'] = id;
    }
    if (data['image'] != null) {
      data['image'] = image;
    }
    if (data['review'] != null) {
      data['review'] = review;
    }

    data['name'] = name;
    data['price'] = price;
    data['location'] = location;
    data['rating'] = rating;
    return data;
  }
}
