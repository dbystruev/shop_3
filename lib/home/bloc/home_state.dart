import 'package:equatable/equatable.dart';
import 'package:outfit_shop_client/data/offer.dart';

///Класс состояния домашней страницы
abstract class HomeState extends Equatable {
  final List<Object> _props;

  HomeState([this._props]): super();

  @override
  List<Object> get props => _props;
}

///Состояние загрузки результата
class HomeStateLoading extends HomeState {
  @override
  String toString() => "HomeStateLoading";
}

///Состояние успешного результата
class HomeStateSuccess extends HomeState {
    final Offers crossOffers;
    final Offers pantsOffers;
    final Offers jacketsOffers;
    HomeStateSuccess({this.crossOffers, this.pantsOffers, this.jacketsOffers}) : super([crossOffers,pantsOffers,jacketsOffers]);

    @override
  String toString() => "HomeStateSuccess {crossOffers: ${crossOffers.offers.length}, pantsOffers: ${pantsOffers.offers.length}, jacketsOffers: ${jacketsOffers.offers.length}}";
}

///Состояние результата с ошибкой
class HomeStateError extends HomeState {
  final String error;
  HomeStateError({this.error}) : super([error]);

  @override
  String toString() => "HomeStateError {error: $error}";
}