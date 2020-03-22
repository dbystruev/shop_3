
import 'package:equatable/equatable.dart';
import 'package:outfit_shop_client/category/bloc/category_event.dart';
import 'package:outfit_shop_client/data/category.dart';

///Класс состояния категории
abstract class CategorySearchState extends Equatable {
  final List<Object> _props;

  CategorySearchState([this._props = const []]):super();

  @override
  List<Object> get props => _props;
}

///Состояние пустого результата
class SearchStateEmpty extends CategorySearchState {
  @override
  String toString() => 'searchStateEmpty';
}

///Состояние загрузки результата
class SearchStateLoading extends CategorySearchState {
  @override
  String toString() => 'SearchStateLoading';
}

///Состояние успешного результата
class SearchStateSuccess extends CategorySearchState {
  final Categories categories;
  final Categories parents;
  final String query;
  final Category parent;
  final CategorySearchEvent event;

  SearchStateSuccess(this.categories,this.parents, this.query, {this.parent, this.event}) : super([categories,parents,query,parent, event]);

  @override
  String toString() => 'SearchStateSuccess {categories: ${categories.categories.length} }';
}

///Состояние ошибочного результата.
class SearchStateError extends CategorySearchState {
  final String error;

  SearchStateError(this.error) : super([error]);

  String toString() => 'SearchStateError {error: $error }';
}

///Состояние дозагрузки результата.
class CategoryAppendStateLoading extends CategorySearchState {
  final Categories categories;
  final Categories parents;
  final Category parent;
  CategoryAppendStateLoading(this.categories, this.parents, {this.parent}) : super([categories, parents, parent]);
}

///Состояние успешной дозагрузки результата.
class CategoryAppendStateSuccess extends CategorySearchState {
  final Categories categories;
  final Categories parents;
  final Category parent;
  final CategorySearchEvent parentEvent;
  CategoryAppendStateSuccess(this.categories, this.parents, this.parent, this.parentEvent): super([categories, parents, parent, parentEvent]);
}

///Состояние пустой дозагрузки результата.
class CategoryAppendStateEmpty extends CategorySearchState {
  final Categories categories;
  final Categories parents;
  final Category parent;
  CategoryAppendStateEmpty(this.categories, this.parents, this.parent) : super([categories,parents, parent]);
}

