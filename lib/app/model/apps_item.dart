import 'package:flutter/material.dart';

class AppItems {
  String imageName;
  Color color;
  String? name;
  bool isNew = false;
  String? type = 'New';
  int? appCount;

  AppItems(this.imageName, this.color, this.name,
      {this.appCount,this.type});
}
