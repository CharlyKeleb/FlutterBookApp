import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_app/enum/enum.dart';
import 'package:flutter_book_app/helpers/download_helper.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:flutter_book_app/utils/api.dart';
import 'package:flutter_book_app/utils/const.dart';

class HomeProvider with ChangeNotifier {
  CategoryModel top = CategoryModel();
  CategoryModel recent = CategoryModel();
  ApiRequestStatus apiRequestStatus = ApiRequestStatus.loading;
  var downloadDB = DownloadsDb();

  Api api = Api();

  getFeeds() async {
    setApiRequestStatus(ApiRequestStatus.loading);
    try {
      CategoryModel popular = await api.getCategory(Api.popular);
      setTop(popular);
      CategoryModel newReleases = await api.getCategory(Api.recent);
      setRecent(newReleases);
      setApiRequestStatus(ApiRequestStatus.loaded);
    } catch (e) {
      checkError(e);
    }
  }

  void checkError(e) {
    if (Constant.checkConnectionError(e)) {
      setApiRequestStatus(ApiRequestStatus.connectionError);
    } else {
      setApiRequestStatus(ApiRequestStatus.error);
    }
  }

  void setApiRequestStatus(ApiRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }

  void setTop(value) {
    top = value;
    notifyListeners();
  }

  CategoryModel getTop() {
    return top;
  }

  void setRecent(value) {
    recent = value;
    notifyListeners();
  }

  CategoryModel getRecent() {
    return recent;
  }
}
