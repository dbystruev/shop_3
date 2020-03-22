import 'package:equatable/equatable.dart';
import 'package:outfit_shop_client/data/category.dart';

///Класс события категории
abstract class CategorySearchEvent extends Equatable {
  final List<Object> _props;

  CategorySearchEvent([this._props = const []]) : super();

  @override
  List<Object> get props => _props;
}

///Событие изменения поискового запроса.
class TextChanged extends CategorySearchEvent {
  final String query;

  TextChanged({this.query}) : super([query]);

  @override
  String toString() => 'CategorySearchTextChanged { query: $query }';
}

///Событие выбора категории.
class CategorySelected extends CategorySearchEvent {
  final Category parent;
  CategorySelected({this.parent}) : super([parent]);

  @override
  String toString() => 'CategorySelected { parentId: ${parent.id} }';

}

///Событие перехода к родительской категории.
class ReturnToParent extends CategorySearchEvent {
  final Category parent;
  ReturnToParent({this.parent}) : super([parent]);

  @override
  String toString() => 'ReturnToParent { parentId: ${parent.id}}';
}

///События получения базовой категории.
class GetBaseCategory extends CategorySearchEvent {
  GetBaseCategory() : super([]);

  @override
  String toString() => 'GetBaseCategory';
}

///Событие загрузки следующей страницы.
class GetNextPage extends CategorySearchEvent {
  final CategorySearchEvent baseEvent;
  final Categories categories;
  final Categories parents;
  final Category parent;
  GetNextPage({this.categories,this.parents, this.parent, this.baseEvent}) : super([baseEvent, categories, parents, parent]);

  @override
  String toString() => 'GetNextPage {baseEvent $baseEvent}';

}