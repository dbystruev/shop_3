import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outfit_shop_client/generated/l10n.dart';
import 'package:outfit_shop_client/offer/bloc/offer_bloc.dart';
import 'package:outfit_shop_client/offer/bloc/offer_event.dart';
import 'package:outfit_shop_client/offer/bloc/offer_state.dart';
import 'package:outfit_shop_client/offer/ui/offer_list.dart';
import 'package:outfit_shop_client/ui/search_bar.dart';
class OfferWidget extends StatefulWidget {
  @override
  _OfferWidgetState createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
  OfferBloc _offerBloc;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchBar(
          hint: S.of(context).offer,
          onChanged: (controller){
            _offerBloc.add(OfferSearchTextChanged(query: controller.text));
          },
        ),
        Expanded(child: OfferList()),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _offerBloc = BlocProvider.of<OfferBloc>(context);
  }
}
