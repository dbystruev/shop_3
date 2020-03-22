import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outfit_shop_client/category/bloc/category_bloc.dart';
import 'package:outfit_shop_client/category/bloc/category_event.dart';
import 'package:outfit_shop_client/category/bloc/category_state.dart';
import 'package:outfit_shop_client/generated/l10n.dart';
import 'package:outfit_shop_client/ui/search_bar.dart';

import 'category_list.dart';

class CategoryWidget extends StatefulWidget {
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  CategorySearchBloc _categorySearchBloc;
  @override
  Widget build(BuildContext context) {
     return Column(
       children: <Widget>[
         SearchBar(
           hint: S.of(context).category,
           onChanged: (controller){
             _categorySearchBloc.add(TextChanged(query: controller.text));
           },
         ),
         Expanded( child: CategoryList()),
       ],
     );
  }

  @override
  void initState() {
    super.initState();
    _categorySearchBloc = BlocProvider.of<CategorySearchBloc>(context);
    if(_categorySearchBloc.state is SearchStateEmpty)_categorySearchBloc.add(TextChanged(query: ''));
  }
}
