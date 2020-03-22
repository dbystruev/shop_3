import 'package:equatable/equatable.dart';

///Класс, описывающий категорию
class Category extends Equatable {
  Category({this.id, this.name, this.parentId});
  final int id;
  final String name;
  final int parentId;
  @override
  List<Object> get props => [id, name, parentId];

  Category.fromJson(Map<String, dynamic> json): id = json['id'], name = json['name'], parentId = json['parentId'];
}

///Класс, описывающий категории.
class Categories extends Equatable {
  final List<Category> categories;
  Categories({this.categories});

  @override
  List<Object> get props => [categories];

  Categories.fromJson(List<dynamic> json): categories = json.map((jsonItem) => Category.fromJson(jsonItem)).toList();
}

