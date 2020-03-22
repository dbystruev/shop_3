import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outfit_shop_client/category/bloc/category_bloc.dart';
import 'package:outfit_shop_client/category/bloc/category_event.dart';
import 'package:outfit_shop_client/category/bloc/category_state.dart';
import 'package:outfit_shop_client/generated/l10n.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  CategorySearchBloc _categorySearchBloc;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategorySearchBloc, CategorySearchState>(
        bloc: _categorySearchBloc,
        builder: (BuildContext context, CategorySearchState state) {
          if (state is SearchStateLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is SearchStateSuccess) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                      itemCount: (state).categories.categories.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) =>
                          ListTile(
                              title: Text((state).categories.categories[index].name),
                            subtitle: state.parents.categories[index] == null ? null : Text(state.parents.categories[index].name),
                            onTap: () => _categorySearchBloc.add(CategorySelected(parent: state.categories.categories[index])),
                          ),
                    ),
                ),
                RaisedButton(
                  child: Text(S.of(context).next),
                  onPressed: () => _categorySearchBloc.add(GetNextPage(categories: state.categories, baseEvent: state.event, parents: state.parents, parent: state.parent)),
                ),
              ],
            );
          }
          if (state is SearchStateError)
            return Center(child: Text(state.error));
          if(state is CategoryAppendStateLoading){
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    itemCount: state.categories.categories.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) =>
                      ListTile(
                        title: Text((state).categories.categories[index].name),
                        subtitle: state.parents.categories[index] == null ? null : Text(state.parents.categories[index].name),
                        onTap: () => _categorySearchBloc.add(CategorySelected(parent: state.categories.categories[index])),
                      ),
                  ),
                ),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
          if(state is CategoryAppendStateEmpty) {
            return ListView.separated(
                itemCount: state.categories.categories.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) =>
                    ListTile(
                      title: Text((state).categories.categories[index].name),
                      subtitle: state.parents.categories[index] == null ? null : Text(state.parents.categories[index].name),
                      onTap: () => _categorySearchBloc.add(CategorySelected(parent: state.categories.categories[index])),
                    ),
              );
          }
          else
            return Center(child: Text(S.of(context).categoriesNotFound));
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _categorySearchBloc = BlocProvider.of<CategorySearchBloc>(context);
  }
}
