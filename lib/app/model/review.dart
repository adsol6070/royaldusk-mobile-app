class Review {
  String? profileUrl;
  double? rating;
  String? reviews;

  Review({
    required this.profileUrl,
    required this.rating,
    required this.reviews,
  });

  Review.fromJson(Map<String, dynamic> json) {
    profileUrl = json['profile_url'];
    reviews = json['review'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['profile_url'] = profileUrl;
    data['review'] = reviews;
    data['rating'] = rating;
    return data;
  }
}
