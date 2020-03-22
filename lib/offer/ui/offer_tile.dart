import 'package:flutter/material.dart';

class OfferTile extends StatelessWidget {
  final String image;
  final String name;
  final int price;
  final Function() onClick;
  OfferTile({this.image, this.name, this.price, this.onClick});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(image),
      title: Text(name),
      subtitle: Text(price.toString()),
      onTap: onClick,
    );
  }
}
