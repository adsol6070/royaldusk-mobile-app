class Facility {
  String? name;
  String? icon;

  Facility({
    required this.name,
    required this.icon,
  });

  Facility.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}
