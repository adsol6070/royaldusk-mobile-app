import 'category.dart';
import 'hotels.dart';
import 'images_model.dart';
import 'review.dart';
import 'ticket.dart';

class PopularPackage {
  int? id;
  String? name;
  String? image;
  String? price;
  String? location;
  String? details;
  double? rating;
  String? reviews;
  String? fullDetails;
  List<Review> reviewList = [];
  List<Category> includedList = [];
  List<Images> images = [];
  List<Ticket> ticketList = [];
  List<Hotel> hotelList = [];

  PopularPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    location = json['location'];
    details = json['details'];
    rating = json['rating'];
    reviews = json['review'];
    fullDetails = json['full_details'];
    if (json['Reviews'] != null) {
      reviewList = List<dynamic>.from(json['Reviews'])
          .map((i) => Review.fromJson(i))
          .toList();
    }
    if (json['package_included'] != null) {
      includedList = List<dynamic>.from(json['package_included'])
          .map((i) => Category.fromJson(i))
          .toList();
    }
    if (json['images'] != null) {
      images = List<dynamic>.from(json['images'])
          .map((i) => Images.fromJson(i))
          .toList();
    }
    if (json['ticket_list'] != null) {
      ticketList = List<dynamic>.from(json['ticket_list'])
          .map((i) => Ticket.fromJson(i))
          .toList();
    }
    if (json['hotel_list'] != null) {
      hotelList = List<dynamic>.from(json['hotel_list'])
          .map((i) => Hotel.fromJson(i))
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
    data['details'] = details;
    data['rating'] = rating;
    data['review'] = reviews;
    data['full_details'] = fullDetails;
    if (data['Reviews'] != null) {
      data['Reviews'] = reviewList.map((item) => item.toJson()).toList();
    }
    if (data['package_included'] != null) {
      data['package_included'] =
          includedList.map((item) => item.toJson()).toList();
    }
    if (data['images'] != null) {
      data['images'] = images.map((item) => item.toJson()).toList();
    }
    if (data['ticket_list'] != null) {
      data['ticket_list'] = ticketList.map((item) => item.toJson()).toList();
    }
    if (data['hotel_list'] != null) {
      data['hotel_list'] = hotelList.map((item) => item.toJson()).toList();
    }
    return data;
  }
}
