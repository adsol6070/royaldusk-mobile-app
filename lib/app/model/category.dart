class AllCategories {
  AllCategories({
     this.listOfCategory,
  });

  List<Category>? listOfCategory;

  AllCategories.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      listOfCategory = <Category>[];
      json['category'].forEach((v) {
        listOfCategory?.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (listOfCategory != null) {
      data['category'] = listOfCategory?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Category {
  int? id;
  String? name;
  String? image;
  bool isSelected=false;

  Category({required this.id, required this.name, required this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
