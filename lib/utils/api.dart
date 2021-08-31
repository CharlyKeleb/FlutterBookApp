import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:xml2json/xml2json.dart';

class Api {
  Dio dio = Dio();
  static String baseURL = 'https://catalog.feedbooks.com';
  static String publicDomainURL = '$baseURL/publicdomain/browse';
  static String popular = '$publicDomainURL/top.atom';
  static String recent = '$publicDomainURL/recent.atom';
  static String awards = '$publicDomainURL/awards.atom';
  static String noteworthy = '$publicDomainURL/homepage_selection.atom';
  static String shortStory = '$publicDomainURL/top.atom?cat=FBFIC029000';
  static String sciFi = '$publicDomainURL/top.atom?cat=FBFIC028000';
  static String actionAdventure = '$publicDomainURL/top.atom?cat=FBFIC002000';
  static String mystery = '$publicDomainURL/top.atom?cat=FBFIC022000';
  static String romance = '$publicDomainURL/top.atom?cat=FBFIC027000';
  static String horror = '$publicDomainURL/top.atom?cat=FBFIC015000';
  static String art = '$publicDomainURL/top.atom?cat=FBFIC019000';
  static String drama = '$publicDomainURL/top.atom?cat=FBDRA000000';

  Future<CategoryModel> getCategory(String url) async {
    var response = await dio.get(url).catchError((e) {
      throw (e);
    });
    CategoryModel category;
    if (response.statusCode == 200) {
      Xml2Json xml2json = new Xml2Json();
      xml2json.parse(response.data.toString());
      var json = jsonDecode(xml2json.toGData());
      category = CategoryModel.fromJson(json);
    } else {
      throw ('==============> ${response.statusCode}');
    }
    return category;
  }
}
