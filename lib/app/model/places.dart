

import 'package:royaldusk_mobile_app/app/model/review.dart';

import 'images_model.dart';

class Places {
  int? id;
  String? name;
  String? image;
  String? price;
  String? location;
  double? rating;
  String? reviews;
  String? fullDetails;
  List<Review> reviewList = [];
  List<Images> images = [];

  Places.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    location = json['location'];
    rating = json['rating'];
    reviews = json['review'];
    fullDetails = json['full_details'];
    if (json['Reviews'] != null) {
      reviewList = List<dynamic>.from(json['Reviews'])
          .map((i) => Review.fromJson(i))
          .toList();
    }
    if (json['images'] != null) {
      images = List<dynamic>.from(json['images'])
          .map((i) => Images.fromJson(i))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['price'] = price;
    data['location'] = location;
    data['rating'] = rating;
    data['review'] = reviews;
    data['full_details'] = fullDetails;
    if (data['Reviews'] != null) {
      data['Reviews'] = reviewList.map((item) => item.toJson()).toList();
    }
    if (data['images'] != null) {
      data['images'] = images.map((item) => item.toJson()).toList();
    }
    return data;
  }
}
