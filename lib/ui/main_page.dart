import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outfit_shop_client/api/offer_client.dart';
import 'package:outfit_shop_client/category/bloc/category_bloc.dart';
import 'package:outfit_shop_client/category/bloc/category_event.dart';
import 'package:outfit_shop_client/category/ui/category_widget.dart';
import 'package:outfit_shop_client/category/bloc/category_state.dart';
import 'package:outfit_shop_client/generated/l10n.dart';
import 'package:outfit_shop_client/home/ui/home_widget.dart';
import 'package:outfit_shop_client/offer/bloc/offer_bloc.dart';
import 'package:outfit_shop_client/offer/bloc/offer_event.dart';
import 'package:outfit_shop_client/offer/bloc/offer_state.dart';
import 'package:outfit_shop_client/offer/ui/offer_filter_drawer.dart';
import 'package:outfit_shop_client/offer/ui/offer_widget.dart';

class NavigationHeader{
  IconData icon;
  String title;
  NavigationHeader(this.title, this.icon);
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CategorySearchBloc _categorySearchBloc;
  OfferBloc _offerBloc;
  Widget _selectedScreen(int index){
    switch(index){
      case 0:
        return HomeWidget();
        break;
      case 1:
        return CategoryWidget();
      case 2:
        return OfferWidget();
    }
    return null;
  }
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<NavigationHeader> _headers = [
      NavigationHeader(S.of(context).homeTitle,Icons.home),
      NavigationHeader(S.of(context).catTitle,Icons.list),
      NavigationHeader(S.of(context).offerTitle,Icons.shopping_basket),
    ];
    return BlocBuilder<OfferBloc, OfferState>(
      bloc: BlocProvider.of<OfferBloc>(context),
      builder: (context, state) => BlocBuilder<CategorySearchBloc, CategorySearchState>(
        bloc: BlocProvider.of<CategorySearchBloc>(context),
        builder: (context, state) {
          var title = _headers[_selectedIndex].title;
          var canReturn = false;
          if(state is SearchStateSuccess){
            if(state.parent != null && state.parent.id != 2) {
              if(_selectedIndex == 1) {
                title = state.parent.name;
                canReturn = true;
              }
            }
            if(state.categories.categories.length == 0) {
               _selectedIndex = 2;
               _offerBloc.add(GetOfferByCategory(category: state.parent));
               _categorySearchBloc.add(ReturnToParent(parent: state.parent));
            }
          }
          return Scaffold(
            appBar: _selectedIndex == 2 ? categoryAppBar(context,_offerBloc) : AppBar(
              leading: canReturn ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  if(_selectedIndex == 1)
                  _categorySearchBloc.add(ReturnToParent(
                      parent: (state as SearchStateSuccess).parent));
                  _selectedIndex = 1;
                }
              )) : null,
              title: Text(title),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) => setState(() => _selectedIndex = index),
              items: _headers.map((item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                title: Text(item.title),
              )).toList(),
              currentIndex: _selectedIndex,
            ),
            body: _selectedScreen(_selectedIndex),
            endDrawer: _selectedIndex == 2 ? OfferFilterDrawer() : null,
          );
        }
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _categorySearchBloc = BlocProvider.of<CategorySearchBloc>(context);
    _categorySearchBloc.add(GetBaseCategory());
    _offerBloc = BlocProvider.of<OfferBloc>(context);
    if(_offerBloc.state is SearchOfferStateEmpty)_offerBloc.add(OfferSearchTextChanged(query: ''));
  }
  Widget categoryAppBar(BuildContext context, OfferBloc bloc){
    OfferState state = bloc.state;
    if(state is SearchOfferStateSuccess || state is SearchOfferStateAppendEmpty ||state is SearchOfferStateAppendLoading){
      String title = S.of(context).offerTitle;
      if(state is SearchOfferStateSuccess) print(state.category);
      if(state is SearchOfferStateSuccess && state.category != null) title = state.category.name;
      if(state is SearchOfferStateAppendLoading && state.category != null) title = state.category.name;
      if(state is SearchOfferStateAppendEmpty && state.category != null) title = state.category.name;
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => bloc.add(OfferSearchTextChanged(query: "")),
        ),
        title: Text(title),
      );
    }else{
      return AppBar(
        title: Text('Товары'),
      );
    }
  }
}
