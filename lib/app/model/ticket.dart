class Ticket {
  FromTicket? from;
  FromTicket? to;
  String? flyingTime;
  String? flyingDate;
  String? departureDate;
  String? departureTime;
  String? duration;
  String? airlinesName;
  String? logoUrl;
  int? number;
  double? price;

  Ticket.fromJson(Map<String, dynamic> json) {
    from = FromTicket.fromJson(json['from']);
    to = FromTicket.fromJson(json['to']);
    flyingTime = json['flying_time'];
    flyingDate = json['flying_date'];
    departureDate = json['departure_date'];
    departureTime = json['departure_time'];
    number = json['number'];
    duration = json['duration'];
    logoUrl = json['logo_url'];
    airlinesName = json['airlines_name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    data['flying_time'] = flyingTime;
    data['flying_date'] = flyingDate;
    data['departure_date'] = departureDate;
    data['departure_time'] = departureTime;
    data['duration'] = duration;
    data['number'] = number;
    data['logo_url'] = logoUrl;
    data['airlines_name'] = airlinesName;
    data['price'] = price;
    return data;
  }
}

class FromTicket {
  String? code;
  String? name;

  FromTicket.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}
