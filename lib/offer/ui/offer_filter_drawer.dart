import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:outfit_shop_client/generated/l10n.dart';
import 'package:outfit_shop_client/offer/bloc/offer_bloc.dart';
import 'package:outfit_shop_client/offer/bloc/offer_event.dart';

class OfferFilterDrawer extends StatefulWidget {
  OfferFilterDrawer({Key key}) : super(key: key);
  @override
  _OfferFilterDrawerState createState() => _OfferFilterDrawerState();
}

class _OfferFilterDrawerState extends State<OfferFilterDrawer> {
  OfferBloc _bloc;
  String _description = "";
  String _id = "";
  String _name = "";
  String _model = "";
  String _vendor = "";
  bool _hasWarranty = true;
  int _minPrice = 0;
  int _maxPrice = 0;
  TextEditingController _minPriceController;
  TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    getPrices();
    _bloc = BlocProvider.of<OfferBloc>(context);
  }

  Future getPrices() async {
    var response = await http.get(Uri.http("server.getoutfit.ru","/prices"));
    setState(() {
      _minPrice = jsonDecode(utf8.decode(response.bodyBytes))["price_min"];
      _maxPrice = jsonDecode(utf8.decode(response.bodyBytes))["price_max"];
      _minPriceController = TextEditingController(text: _minPrice.toString());
      _maxPriceController = TextEditingController(text: _maxPrice.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Center(child: Text(S.of(context).filter,style: Theme.of(context).textTheme.title,)),
          Container(
            margin: EdgeInsets.all(4.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: S.of(context).description,
              ),
              onChanged: (text) => setState(() => _description = text),
            ),
          ),
          Container(
            margin: EdgeInsets.all(4.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: S.of(context).offerId,
              ),
              onChanged: (text) => setState(() => _id = text)
            ),
          ),

          Container(
            margin: EdgeInsets.all(4.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: S.of(context).offerName,
              ),
              onChanged: (text) => setState(() => _name)
            ),
          ),
          Container(
            margin: EdgeInsets.all(4.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: S.of(context).minPrice,
              ),
              keyboardType: TextInputType.number,
              controller: _minPriceController,
            ),
          ),
          Container(
            margin: EdgeInsets.all(4.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: S.of(context).maxPrice,
              ),
              keyboardType: TextInputType.number,
              controller: _maxPriceController,
            ),
          ),
          Container(
            margin: EdgeInsets.all(4.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: S.of(context).model,
              ),
              onChanged: (text) => setState(() => _model = text),
            ),
          ),
          Container(
            margin: EdgeInsets.all(4.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: S.of(context).vendor,
              ),
              onChanged: (text) => setState(() => _vendor = text),
            ),
          ),
          Container(
            margin: EdgeInsets.all(4.0),
            child: CheckboxListTile(
              title: Text(S.of(context).warranty),
              value: _hasWarranty,
              onChanged: (value) => setState(() => _hasWarranty = value),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text(S.of(context).search),
                  onPressed: (){
                    _bloc.add(GetWithFilter(
                      description: _description,
                      id: _id,
                      name: _name,
                      minPrice: int.parse(_minPriceController.text),
                      maxPrice: int.parse(_maxPriceController.text),
                      model: _model,
                      vendor: _vendor,
                      hasWarranty: _hasWarranty
                    ));
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          )
          ],
      ),
    );
  }
}