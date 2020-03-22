import 'package:equatable/equatable.dart';
import 'package:outfit_shop_client/data/param.dart';

import 'category.dart';

class Offer extends Equatable {
  Category category;
  final bool available;
  final bool deleted;
  final String id;
  final int categoryId;
  final String currencyId;
  final String description;
  final bool manufacturerWarranty;
  final String model;
  final String name;
  final int oldPrice;
  final Params params;
  final List<String> pictures;
  final int price;
  final String salesNotes;
  final String typePrefix;
  final String url;
  final String vendor;
  final String vendorCode;

  Offer({this.available, this.deleted, this.id, this.categoryId, this.currencyId,
  this.description, this.manufacturerWarranty, this.model, this.name, this.oldPrice,
  this.params, this.pictures, this.price, this.salesNotes, this.typePrefix, this.url,
  this.vendor, this.vendorCode});

  @override
  List<Object> get props => [available, deleted, id, categoryId, currencyId, description,
  manufacturerWarranty, model, name, oldPrice, params, pictures, price, salesNotes, typePrefix,
  url, vendor, vendorCode];

  factory Offer.fromJson(Map<String, dynamic> json){
    return Offer(
      available: json['available'] ?? null,
      deleted: json['deleted'] ?? null,
      id: json['id'] ?? null,
      categoryId: json['categoryId'] ?? null,
      currencyId: json['currencyId'] ?? null,
      description: json['description'] ?? null,
      manufacturerWarranty: json['manufacturer_warranty'] ?? null,
      model: json['model'] ?? null,
      name: json['name'] ?? null,
      oldPrice: json['oldPrice'] ?? null,
      params: Params.fromJson(json['params']) ?? null,
      pictures: List.from(json['pictures']).cast<String>().toList() ?? null,
      price: json['price'] ?? null,
      salesNotes: json['sales_notes'] ?? null,
      typePrefix: json['typePrefix'] ?? null,
      url: json['url'] ?? null,
      vendor: json['vendor'] ?? null,
      vendorCode: json['vendorCode'] ?? null,
    );
  }
}

class Offers extends Equatable {
  final List<Offer> offers;
  Offers(this.offers);
  List<Object> get props => offers;
  Offers.fromJson(List<dynamic> json): offers = json.map((jsonItem) => Offer.fromJson(jsonItem)).toList();
}