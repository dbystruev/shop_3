import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outfit_shop_client/generated/l10n.dart';
import 'package:outfit_shop_client/offer/bloc/offer_bloc.dart';
import 'package:outfit_shop_client/offer/bloc/offer_event.dart';
import 'package:outfit_shop_client/offer/bloc/offer_state.dart';
import 'package:outfit_shop_client/offer/ui/offer_description.dart';
import 'package:outfit_shop_client/offer/ui/offer_tile.dart';

class OfferList extends StatefulWidget {
  OfferList({Key key}) : super(key: key);

  @override
  _OfferListState createState() => _OfferListState();
}



class _OfferListState extends State<OfferList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferBloc, OfferState>(
      bloc: BlocProvider.of<OfferBloc>(context),
      builder: (context, state) {
        if(state is SearchOfferStateLoading){
          return Center(child: CircularProgressIndicator());
        }
        if(state is SearchOfferStateSuccess){
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                    itemCount: state.offers.offers.length,
                    separatorBuilder: (context, index) => Divider(height: 1,),
                    itemBuilder: (context, index) => OfferTile(
                      name: state.offers.offers[index].name,
                      image: state.offers.offers[index].pictures[0],
                      price: state.offers.offers[index].price,
                      onClick: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OfferDescription(state.offers.offers[index]),
                        ));
                      },
                    ),
                  ),
              ),
              RaisedButton(
                child: Text(S.of(context).next),
                onPressed: () => BlocProvider.of<OfferBloc>(context).add(OfferGetNextPage(baseEvent: state.event, offers: state.offers, category: state.category)),
              )
            ],
          );
        }
        if(state is SearchOfferStateAppendLoading){
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  itemCount: state.offers.offers.length,
                  separatorBuilder: (context, index) => Divider(height: 1,),
                  itemBuilder: (context, index) => OfferTile(
                    name: state.offers.offers[index].name,
                    image: state.offers.offers[index].pictures[0],
                    price: state.offers.offers[index].price,
                    onClick: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OfferDescription(state.offers.offers[index]),
                      ));
                    }
                  ),
                )
              ),
              Center(child: CircularProgressIndicator()),
            ],
          );
        }
        if(state is SearchOfferStateAppendEmpty){
          return ListView.separated(
            itemCount: state.offers.offers.length,
            separatorBuilder: (context,index) => Divider(height: 1,),
            itemBuilder: (context, index) => OfferTile(
              name: state.offers.offers[index].name,
              image: state.offers.offers[index].pictures[0],
              price: state.offers.offers[index].price,
              onClick: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OfferDescription(state.offers.offers[index]),
                ));
              },
            ),
          );
        }
        else return  Center(
            child: Text(S.of(context).offersNotFound),
          );
      },
    );
  }
}