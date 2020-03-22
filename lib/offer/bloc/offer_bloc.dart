import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outfit_shop_client/api/offer_client.dart';
import 'package:outfit_shop_client/category/bloc/category_event.dart';
import 'package:outfit_shop_client/offer/bloc/offer_event.dart';
import 'package:outfit_shop_client/offer/bloc/offer_state.dart';
import 'package:rxdart/rxdart.dart';

///BLoC для работы с товарами.
class OfferBloc extends Bloc<OfferEvent, OfferState> {

  final OfferClient offerClient;

  OfferBloc({@required this.offerClient});

  ///Реализация задержки между обработками событий.
  @override
  Stream<OfferState> transformEvents(Stream<OfferEvent> events, Stream<OfferState> Function(OfferEvent event) next){
    return super.transformEvents(events.debounceTime(Duration(milliseconds: 500),), next);
  }

  ///Установка начального состояния.
  @override
  OfferState get initialState => SearchOfferStateEmpty();

  ///Связь события изменения поиска с состояниями.
  Stream<OfferState> _mapOfferSearchTextChangedToState(OfferSearchTextChanged event) async*{
    yield SearchOfferStateLoading();
    final queryText = event.query;
    try {
      var result = await offerClient.getOffersBySearchQuery(queryText);
      result = await offerClient.getOffersWithCategory(result);
      yield SearchOfferStateSuccess(result, queryText,OfferSearchTextChanged(query: queryText));
    }catch(error){
      yield SearchOfferStateError(error.message);
    }
  }

  ///Связь события получения товаров по категории с состояниями.
  Stream<OfferState> _mapGetOfferByCategoryToState(GetOfferByCategory event) async* {
    yield SearchOfferStateLoading();
    final category = event.category;
    try{
      final result = await offerClient.getOffersByCategory(category);
      yield SearchOfferStateSuccess(result, "", GetOfferByCategory(category: category),category: category);
    }catch(error){
      yield SearchOfferStateError(error.message);
    }
  }

  ///Связь событияя фильтрации с состояниями.
  Stream<OfferState> _mapGetWithFilterToState(GetWithFilter event) async* {
    yield SearchOfferStateLoading();
    try{
      var result = await offerClient.getOffersByFilter(
        description: event.description,
        id: event.id,
        name: event.name,
        vendor: event.vendor,
        model: event.model,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        warranty: event.hasWarranty
      );
      result = await offerClient.getOffersWithCategory(result);
      yield SearchOfferStateSuccess(result, "", event);
    }catch(error){
      yield SearchOfferStateError(error.toString());
    }
  }

  ///Связь события дозагрузки товаров с состояниями.
  Stream<OfferState> _mapOfferGetNextPageToState(OfferGetNextPage event) async* {
    var offers = event.offers;
    var category = event.category;
    var baseEvent = event.baseEvent;
    yield SearchOfferStateAppendLoading(offers,"",category: category);
    try {
      if (baseEvent is OfferSearchTextChanged) {
        var result = await offerClient.getOffersBySearchQuery(
            baseEvent.query, from: offers.offers.length);
        result = await offerClient.getOffersWithCategory(result);
        if (result.offers.length == 0)
          yield SearchOfferStateAppendEmpty(offers, "", category: category);
        else {
          offers.offers.addAll(result.offers);
          yield SearchOfferStateSuccess(
              offers, "", baseEvent, category: category);
        }
      }
      if (baseEvent is GetOfferByCategory) {
        final result = await offerClient.getOffersByCategory(
            category, from: offers.offers.length);
        if (result.offers.length == 0)
          yield SearchOfferStateAppendEmpty(offers, "", category: category);
        else {
          offers.offers.addAll(result.offers);
          yield SearchOfferStateSuccess(
              offers, "", baseEvent, category: category);
        }
      }
      if (baseEvent is GetWithFilter) {
        var result = await offerClient.getOffersByFilter(
          description: baseEvent.description,
          id: baseEvent.id,
          name: baseEvent.name,
          vendor: baseEvent.vendor,
          model: baseEvent.model,
          minPrice: baseEvent.minPrice,
          maxPrice: baseEvent.maxPrice,
          warranty: baseEvent.hasWarranty,
          from: offers.offers.length,
        );
        result = await offerClient.getOffersWithCategory(result);

        if (result.offers.length == 0)
          yield SearchOfferStateAppendEmpty(offers, "", category: category);
        else {
          offers.offers.addAll(result.offers);
          yield SearchOfferStateSuccess(
              offers, "", baseEvent, category: category);
        }
      }
    }catch(error){
      yield SearchOfferStateAppendEmpty(offers,"",category: category);
    }
  }

  ///Связь событий с состояниями.
  @override
  Stream<OfferState> mapEventToState(OfferEvent event) async*{
    if(event is OfferSearchTextChanged){
      yield* _mapOfferSearchTextChangedToState(event);
    }
    if(event is GetOfferByCategory){
      yield* _mapGetOfferByCategoryToState(event);
    }
    if(event is GetWithFilter){
      yield* _mapGetWithFilterToState(event);
    }
    if(event is OfferGetNextPage){
      yield* _mapOfferGetNextPageToState(event);
    }
  }

  ///Вывод изменений состояний.
@override
  void onTransition(Transition<OfferEvent, OfferState> transition) {
    print(transition);
  }
}