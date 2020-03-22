import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outfit_shop_client/category/bloc/category_bloc.dart';
import 'package:outfit_shop_client/category/bloc/category_state.dart';
import 'package:outfit_shop_client/data/offer.dart';
import 'package:outfit_shop_client/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferDescription extends StatelessWidget {
  final Offer offer;
  OfferDescription(this.offer);
  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [
      DataRow(
        cells: [
          DataCell(Text(S.of(context).offerId)),
          DataCell(Text(offer.id)),
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text(S.of(context).model)),
          DataCell(Text(offer.model)),
        ]
      ),
      DataRow(
        cells: [
          DataCell(Text(S.of(context).category)),
          DataCell(Text(offer.category.name)),
        ]
      )
    ];
    rows.addAll(offer.params.params.map((item){
      return DataRow(
          cells: [
            DataCell(Text(item.name)),
            DataCell(Text(item.value)),
          ]
      );
    }).toList());
    rows.addAll([
      DataRow(
        cells: [
         DataCell(Text(S.of(context).warranty)),
         DataCell(Text(offer.manufacturerWarranty ? S.of(context).yes : S.of(context).no)),
        ],
      ),
      DataRow(
        cells:[
          DataCell(Text(S.of(context).vendor)),
          DataCell(Text(offer.vendor)),
        ]
      )
    ]);
    return Scaffold(
      appBar: AppBar(title: Text(offer.name)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MediaQuery.of(context).orientation == Orientation.portrait ? ListView(
              children: <Widget>[
                Image.network(offer.pictures[0]),
                Center(child: Text(offer.description)),
                //Text("Категория:  ${(BlocProvider.of<CategorySearchBloc>(context).state as SearchStateSuccess).categories.categories.where((cat) => cat.id == offer.categoryId).toList()[0].name}"),
                Text("${S.of(context).price}: ${offer.price}₽",style: Theme.of(context).textTheme.title),
                DataTable(
                  columns: [
                    DataColumn(label: Text(S.of(context).property)),
                    DataColumn(label: Text(S.of(context).value)),
                  ],
                  rows: rows,
                ),
                Text("${S.of(context).notes}: ${offer.salesNotes}"),
              ],
            ):
                Row(
                  children: [
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Image.network(offer.pictures[0]),
                          Center(child: Text(offer.description)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                            //Text("Категория:  ${(BlocProvider.of<CategorySearchBloc>(context).state as SearchStateSuccess).categories.categories.where((cat) => cat.id == offer.categoryId).toList()[0].name}"),
                            Text("${S.of(context).price}: ${offer.price}₽"),
                            DataTable(
                              columns: [
                                DataColumn(label: Text(S.of(context).property)),
                                DataColumn(label: Text(S.of(context).value)),
                              ],
                              rows: rows,
                            ),
                            Text("${S.of(context).notes}: ${offer.salesNotes}"),
                        ],
                      )
                    )

                  ]
                )
          ),
          Row(children:[Expanded(child: RaisedButton(
            child: Text(S.of(context).buy),
            onPressed: _launchURL,
          ))]),
        ],
      ),
    );
  }
  _launchURL() async{
    if(await canLaunch(offer.url)){
      await launch(offer.url);
    }
  }


}
