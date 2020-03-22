import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:outfit_shop_client/data/category.dart';
import 'package:outfit_shop_client/data/offer.dart';

class OfferClient{
  final http.Client httpClient;
  final String baseUrl = 'server.getoutfit.ru';
  OfferClient({httpClient}) : this.httpClient = httpClient ?? http.Client();

  ///Получает товары по поисковому запросу [query], пропустив [from] товаров.
  Future<Offers> getOffersBySearchQuery(String query,{int from}) async{
    var response;
    if(query.isNotEmpty) response = await httpClient.get(Uri.http(baseUrl,"/offers",{"name": query, "from": from == null ? "0" : from.toString()}));
    else response = await httpClient.get(Uri.http(baseUrl,"/offers",{"from": from == null ? "0" : from.toString()}));
    if(response.statusCode>= 200 && response.statusCode<300) {
      final result = jsonDecode(utf8.decode(response.bodyBytes));
      return Offers.fromJson(result);
    }else throw Exception("Request Error: ${response.statusCode}");
  }

  ///Определяет для товаров [offers] категории.
  Future<Offers> getOffersWithCategory(Offers offers) async{
    final response = await httpClient.get(Uri(
        scheme: 'http',
        host: baseUrl,
        path: '/categories',
        queryParameters: {
          'id': offers.offers.map((item) => item.categoryId.toString() ?? "").toList(),
        }
    ));
    if(response.statusCode>= 200 && response.statusCode < 300) {
      final result = Categories.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (int i = 0; i < offers.offers.length; i++) {
        if (offers.offers[i].categoryId != null) {
          offers.offers[i].category = result.categories
              .where((cat) => cat.id == offers.offers[i].categoryId)
              .first;
        }
      }
      return offers;
    }else throw Exception("Request Error: ${response.statusCode}");
  }

  ///Получает товары в категории [category], пропустив [from] товаров.
  Future<Offers> getOffersByCategory(Category category, {int from}) async{
    final response = await httpClient.get(Uri.http(baseUrl, "/offers",{"categoryId": category.id.toString(), "from": from == null ? "0" : from.toString()}));
    if(response.statusCode >= 200 && response.statusCode < 300) {
      final result = Offers.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      result.offers.forEach((offer) => offer.category = category);
      return result;
    }else throw Exception("Request Error: ${response.statusCode}");
  }

  ///Получает товары по параметрам фильтра, пропустив [from] товаров.
  Future<Offers> getOffersByFilter({String description, String id, String name, int minPrice, int maxPrice, String model, String vendor, bool warranty, int from}) async{
    final Map<String,String> filters = {};
    if(description.isNotEmpty) filters["description"] = description;
    if(id.isNotEmpty) filters["id"] = id;
    if(name.isNotEmpty) filters["name"] = name;
    print(filters);
    filters["price_above"] = minPrice.toString();
    filters["price_below"] = maxPrice.toString();
    if(model.isNotEmpty) filters["model"] = model;
    if(vendor.isNotEmpty) filters["vendor"] = vendor;
    filters["manufacturer_warranty"] = warranty.toString();
    if(from != null) filters["from"] = from.toString();
    final response = await httpClient.get(Uri.http(baseUrl,"/offers",filters));
    if(response.statusCode>=200 && response.statusCode < 300) {
      return Offers.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }else throw Exception("Request Error: ${response.statusCode}");
  }
}