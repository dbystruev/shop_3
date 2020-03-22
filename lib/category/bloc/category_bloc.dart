import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:outfit_shop_client/api/category_client.dart';
import 'package:outfit_shop_client/category/bloc/category_event.dart';
import 'package:outfit_shop_client/category/bloc/category_state.dart';
import 'package:outfit_shop_client/data/category.dart';
import 'package:rxdart/rxdart.dart';

///BLoC для работы с категориями.
class CategorySearchBloc extends Bloc<CategorySearchEvent, CategorySearchState> {
  final CategoryClient categoryClient;

  @override
  CategorySearchState get initialState => SearchStateEmpty();

  CategorySearchBloc({@required this.categoryClient});

  ///Осуществляет задержку между обработками событий
  @override
  transformEvents(Stream<CategorySearchEvent> events, Stream<CategorySearchState> Function(CategorySearchEvent event) next) {
    return super.transformEvents(events.debounceTime(Duration(milliseconds: 500)), next);
  }

  ///Связывает событие [CategorySelected] с состоянием.
  Stream<CategorySearchState> _mapCategorySearchCategorySelectedToState(CategorySelected event) async* {
    final Category parent = event.parent;
    yield SearchStateLoading();
    try {
      final result = await categoryClient.getChildren(parent.id);
      yield SearchStateSuccess(result, Categories(categories: result.categories.map((item) => null as Category).toList()), "",parent: parent, event: CategorySelected(parent: event.parent));
    }catch(error) {
      yield SearchStateError(error.message);
    }
  }

  ///Связывает событие [GetNextPage] с состоянием.
  Stream<CategorySearchState> _mapGetNextPageToState(GetNextPage event) async* {
     Categories categories = event.categories;
     Categories parents = event.parents;
     Category parent = event.parent;
     CategorySearchEvent baseEvent = event.baseEvent;
     yield CategoryAppendStateLoading(categories, parents, parent: parent);
     try {
       if(baseEvent is CategorySelected) {
         final result = await categoryClient.getChildren(parent.id, from: categories.categories.length);
         final appendParents = await categoryClient.getParents(result);
         if(result.categories.length == 0) yield CategoryAppendStateEmpty(categories, parents, parent);
         else {
           categories.categories.addAll(result.categories);
           parents.categories.addAll(appendParents.categories.map((item) => null as Category).toList());
           yield SearchStateSuccess(
               categories, parents, "", parent: parent, event: baseEvent);
         }
       }
       if(baseEvent is ReturnToParent) {
         final Category parent = baseEvent.parent;
         final parentParent = await categoryClient.getCategoryFromId(parent.parentId);
         final result = await categoryClient.getChildren(parentParent.id, from: categories.categories.length);
         final appendParents = await categoryClient.getParents(result);
         if(result.categories.length == 0) yield CategoryAppendStateEmpty(categories, parents, parent);
         else {
           categories.categories.addAll(result.categories);
           parents.categories.addAll(appendParents.categories.map((item) => null as Category).toList());
           yield SearchStateSuccess(
             categories, parents, "", parent: parent, event: baseEvent
           );
         }
       }
       if(baseEvent is GetBaseCategory){
         final result = await categoryClient.getChildren(2, from: categories.categories.length);
         final appendParents = await categoryClient.getParents(result);
         if(result.categories.length == 0) yield CategoryAppendStateEmpty(categories, parents, parent);
         else{
           categories.categories.addAll(result.categories);
           parents.categories.addAll(appendParents.categories.map((item) => null as Category).toList());
           yield SearchStateSuccess(result,parents,"", event: GetBaseCategory());
         }

       }
       if(baseEvent is TextChanged) {
         final String searchQuery = baseEvent.query;
         final result = await categoryClient.getCategoriesBySearchQuery(searchQuery, from: categories.categories.length);
         final appendParents = await categoryClient.getParents(result);
         if(result.categories.length == 0) yield CategoryAppendStateEmpty(categories, parents, null);
         else {
           categories.categories.addAll(result.categories);
           parents.categories.addAll(appendParents.categories);
           yield SearchStateSuccess(categories, parents, "", parent: null, event: baseEvent);
         }
       }
     }catch(error) {
        yield SearchStateError(error.message);
     }
  }

  ///Связывает событие [ReturnToParent] с состоянием.
  Stream<CategorySearchState> _mapCategorySearchReturnToParentToState(ReturnToParent event) async* {
    final Category parent = event.parent;
    yield SearchStateLoading();
    try{
      final parentParent = await categoryClient.getCategoryFromId(parent.parentId);
      final result = await categoryClient.getChildren(parentParent.id);
      final parents = Categories(categories: result.categories.map((item) => null as Category).toList());
      if(result.categories.length == 0) yield SearchStateEmpty();
      else yield SearchStateSuccess(result, parents,"",parent: parentParent, event: ReturnToParent(parent: event.parent));
    }catch(error){
      yield SearchStateError(error.message);
    }
  }

  ///Связывает событие [GetBaseCategory] с состоянием.
  Stream<CategorySearchState> _mapCategorySearchGetBaseCategoryToState(GetBaseCategory event) async* {
    yield SearchStateLoading();
    try{
      final result = await categoryClient.getChildren(2);
      print(result.categories.length);
      final parents = Categories(categories: result.categories.map((item) => null as Category).toList());
      if(result.categories.length == 0) yield SearchStateEmpty();
      else yield SearchStateSuccess(result,parents,"", event: GetBaseCategory());
    }catch(error){
      yield SearchStateError(error.message);
    }
  }

  ///Связывает событие [TextChanged] с состоянием.
  Stream<CategorySearchState> _mapCategorySearchTextChangedToState(TextChanged event) async* {
    final String searchQuery = event.query;
    if(searchQuery.isEmpty) {
      yield SearchStateLoading();
      try{
        final result = await categoryClient.getAllCategories();
        final parents = await categoryClient.getParents(result);
        await Future.delayed(Duration(milliseconds: 800));
        if(result.categories.length == 0) yield SearchStateEmpty();
        else yield SearchStateSuccess(result,parents,"", event: TextChanged(query: searchQuery));
      }catch(error){
        yield SearchStateError(error.message);
      }
    } else {
      yield SearchStateLoading();
      try{
        final result = await categoryClient.getCategoriesBySearchQuery(searchQuery);
        final parents = await categoryClient.getParents(result);
        await Future.delayed(Duration(milliseconds: 800));
        if(result.categories.length == 0) yield SearchStateEmpty();
        else yield SearchStateSuccess(result,parents,"", event: TextChanged(query: searchQuery));
      }catch(error){
       yield SearchStateError(error.message);
      }
    }
  }

  ///Связывает события BLoC с состояниями.
  @override
  Stream<CategorySearchState> mapEventToState(CategorySearchEvent event) async* {
    if(event is TextChanged){
       yield* _mapCategorySearchTextChangedToState(event);
    }
    if(event is CategorySelected) {
      yield* _mapCategorySearchCategorySelectedToState(event);
    }
    if(event is ReturnToParent) {
      yield* _mapCategorySearchReturnToParentToState(event);
    }
    if(event is GetBaseCategory){
      yield* _mapCategorySearchGetBaseCategoryToState(event);
    }
    if(event is GetNextPage){
      yield* _mapGetNextPageToState(event);
    }
  }

  ///Выводит информацию о переходах между состояниями.
  @override
  void onTransition(Transition<CategorySearchEvent, CategorySearchState> transition) {
    print(transition);
  }
}