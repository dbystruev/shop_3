import 'package:equatable/equatable.dart';
import 'package:outfit_shop_client/data/category.dart';
import 'package:outfit_shop_client/data/offer.dart';

///Класс события товара.
abstract class OfferEvent extends Equatable {
  final List<Object> _props;

  OfferEvent([this._props=const[]]) : super();

  @override
  List<Object> get props => _props;
}

///Событие поиска товара.
class OfferSearchTextChanged extends OfferEvent {
  final String query;

  OfferSearchTextChanged({this.query}) : super ([query]);

  @override
  String toString() => "OfferSearchTextChanged {query: $query }";
}

///Событие получения товаров по категории
class GetOfferByCategory extends OfferEvent {
  final Category category;

  GetOfferByCategory({this.category}) : super([category]);

  @override
  String toString() => "GetOfferByCategory {category : ${category.name}";
}

///Событие фильтрации товаров
class GetWithFilter extends OfferEvent {
  final String description;
  final String id;
  final String name;
  final int minPrice;
  final int maxPrice;
  final String model;
  final String vendor;
  final bool hasWarranty;

  GetWithFilter({this.description, this.id, this.name, this.minPrice, this.maxPrice, this.model, this.vendor, this.hasWarranty}): super([description, id, name, minPrice, maxPrice, model, vendor, hasWarranty]);

  toString() => "GetWithFilter";
}

///Событие дозагрузки товаров.
class OfferGetNextPage extends OfferEvent {
  final OfferEvent baseEvent;
  final Offers offers;
  final Category category;
  OfferGetNextPage({this.baseEvent,this.offers, this.category}) : super([baseEvent, offers, category]);
}

