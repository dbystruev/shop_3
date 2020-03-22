import 'package:equatable/equatable.dart';
import 'package:outfit_shop_client/data/category.dart';
import 'package:outfit_shop_client/data/offer.dart';

import 'offer_event.dart';

///Класс состояния товаров.
abstract class OfferState extends Equatable {
  final List<Object> _props;

  OfferState([this._props = const[]]):super();
  @override
  List<Object> get props => _props;
}

///Состояние пустого результата.
class SearchOfferStateEmpty extends OfferState {
  @override
  String toString() => 'SearchOfferStateEmpty';
}

///Состояние загрузки результата.
class SearchOfferStateLoading extends OfferState {
  @override
  String toString() => 'SearchOfferStateLoading';
}

///Состояние успешного результата поиска.
class SearchOfferStateSuccess extends OfferState {
  final Offers offers;
  final String query;
  final OfferEvent event;
  final Category category;
  SearchOfferStateSuccess(this.offers,this.query, this.event,{this.category}) : super([offers,query,event,category]);

  @override
  String toString() => 'SearchOfferStateSuccess { offers: ${offers.offers.length}}';
}

///Состояние дозагрузки результата.
class SearchOfferStateAppendLoading extends OfferState {
  final Offers offers;
  final String query;
  final Category category;
  SearchOfferStateAppendLoading(this.offers, this.query,{this.category}) : super([offers,query,category]);
}

///Состояние пустой дозагрузки результата.
class SearchOfferStateAppendEmpty extends OfferState {
  final Offers offers;
  final String query;
  final Category category;
  SearchOfferStateAppendEmpty(this.offers, this.query, {this.category}) : super([offers,query,category]);
}

///Состояние ошибочного результата.
class SearchOfferStateError extends OfferState {
  final String error;
  SearchOfferStateError(this.error) : super([error]);

  @override
  String toString() => 'SearchOfferStateError { error: $error}';
}