import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:outfit_shop_client/data/offer.dart';
import 'package:outfit_shop_client/generated/l10n.dart';
import 'package:outfit_shop_client/home/bloc/home_bloc.dart';
import 'package:outfit_shop_client/home/bloc/home_event.dart';
import 'package:outfit_shop_client/home/bloc/home_state.dart';
import 'package:outfit_shop_client/offer/ui/offer_description.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: BlocProvider.of<HomeBloc>(context),
      builder: (context, state) {
        if(state is HomeStateLoading){
          return Column(
            children: <Widget>[
              Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          );
        }
        if(state is HomeStateSuccess){
          return ListView(
            children: [
              widgetOfferGridList(title: S.of(context).cross,offers: state.crossOffers),
              widgetOfferGridList(title: S.of(context).pants, offers: state.pantsOffers),
              widgetOfferGridList(title: S.of(context).jacket, offers: state.jacketsOffers),
            ]
          );
        }
        else return Expanded(child:Center(child: Text(S.of(context).offerLoadError)));
      }
    );
  }
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(HomeStateEvent.LoadEvent);
  }

  Widget widgetOfferGridList({String title, Offers offers}){
    return Column(
      children: <Widget>[
        Container(
          child: Text(title,style: Theme.of(context).textTheme.title,),
          margin: EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
        ),
        StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: 5,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OfferDescription(offers.offers[index])),
            ),
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(offers.offers[index].pictures[0],
                      ),
                      fit: BoxFit.fill),
                ),
                child: Container(
                  margin:EdgeInsets.only(left:4.0, top:4.0),
                )
            ),
          ),
          staggeredTileBuilder: (index) =>
              StaggeredTile.count(index == 0 ? 2: 1, index == 0 ? 2: 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ],
    );
  }
}