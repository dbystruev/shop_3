import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:outfit_shop_client/data/category.dart';

///Клиент для работы с категориями
class CategoryClient {
  final http.Client httpClient;
  final String baseUrl = "server.getoutfit.ru";

  CategoryClient({httpClient}) : this.httpClient = httpClient ?? http.Client();

  ///Получает категории по поисковому запросу [query],
  /// пропустив [from] категорий.
  Future<Categories> getCategoriesBySearchQuery(String query,{int from}) async {
    final response = await httpClient.get(
      Uri.http(baseUrl, "/categories", {"name": query, "from": from == null ? 0.toString() : from.toString()}),);
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Categories.fromJson(result);
    } else
      throw Exception("Request Error: ${response.statusCode}");
  }

  ///Получает все категории, пропустив [from] категорий.
  Future<Categories> getAllCategories({int from}) async {
    final response = await httpClient.get(Uri.http(baseUrl, "/categories", {"from": from == null ? 0.toString() : from.toString()}));
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Categories.fromJson(result);
    } else
      throw Exception("Request Error: ${response.statusCode}");
  }

  ///Получает категорию по [id].
  Future<Category> getCategoryFromId(int id) async {
    final response = await httpClient.get(Uri.http(baseUrl,"/categories",{"id": id.toString()}));
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode >= 200 && response.statusCode < 300) {
      return Categories.fromJson(result).categories[0];
    }else
      throw Exception('Request Error: ${response.statusCode}');
  }

  ///Получает список родителей категорий [categories].
  Future<Categories> getParents(Categories categories) async {
    final response = await httpClient.get(Uri(
      scheme: 'http',
      host: baseUrl,
      path: '/categories',


        queryParameters: {
        'id': categories.categories.map((item) => item.parentId.toString() ?? "").toList(),
      }
    ));
    List<Category> finalResult = [];
    if(response.statusCode>= 200 && response.statusCode < 300) {
      final result = Categories.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (int i = 0; i < categories.categories.length; i++) {
        if (categories.categories[i].parentId == null) {
          finalResult.add(null);
        } else {
          finalResult.add(result.categories
              .where((cat) => cat.id == categories.categories[i].parentId)
              .first);
        }
      }
      return Categories(categories: finalResult);
    }throw Exception('Request Error: ${response.statusCode}');
  }

  ///Получает дочерние категории по id родителя [parentId],
  /// пропустив [from] категорий.
  Future<Categories> getChildren(int parentId, {int from}) async{
    final response = await httpClient.get(Uri.http(baseUrl, "/categories",{"parentId": parentId.toString(), "from": from == null ? 0.toString() : from.toString()}));
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode >= 200 && response.statusCode < 300){
      return Categories.fromJson(result);
    }else throw Exception('Request Error: ${response.statusCode}');
  }

}