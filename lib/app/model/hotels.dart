

import 'facility.dart';
import 'images_model.dart';

class Hotel {
  int? id;
  String? name;
  String? url;
  String? image;
  String? location;
  String? review;
  String? price;
  String? fullDetails;
  double? rating;
  List<Facility> facilityList = [];
  List<Images> images = [];

  Hotel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['url'] != null) {
      url = json['url'];
    }

    if (json['image'] != null) {
      image = json['image'];
    }
    if (json['review'] != null) {
      review = json['review'];
    }
    if (json['full_details'] != null) {
      fullDetails = json['full_details'];
    }

    name = json['name'];
    price = json['price'];
    location = json['location'];
    rating = json['rating'];
    if (json['facility'] != null) {
      facilityList = List<dynamic>.from(json['facility'])
          .map((i) => Facility.fromJson(i))
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
    if (data['id'] != null) {
      data['id'] = id;
    }
    if (data['url'] != null) {
      data['url'] = url;
    }

    if (data['image'] != null) {
      data['image'] = image;
    }
    if (data['review'] != null) {
      data['review'] = review;
    }
    if (data['full_details'] != null) {
      data['full_details'] = fullDetails;
    }
    data['name'] = name;
    data['price'] = price;
    data['location'] = location;
    data['rating'] = rating;
    if (data['facility'] != null) {
      data['facility'] = facilityList.map((item) => item.toJson()).toList();
    }
    if (data['images'] != null) {
      data['images'] = images.map((item) => item.toJson()).toList();
    }
    return data;
  }
}
