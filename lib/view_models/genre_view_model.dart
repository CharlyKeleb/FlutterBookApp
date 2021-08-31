import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_app/enum/enum.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:flutter_book_app/utils/api.dart';
import 'package:flutter_book_app/utils/const.dart';
import 'package:fluttertoast/fluttertoast.dart';


class GenreProvider extends ChangeNotifier {
  ScrollController controller = ScrollController();
  List items = [];
  int page = 1;
  bool loadingMore = false;
  bool loadMore = true;
  ApiRequestStatus apiRequestStatus = ApiRequestStatus.loading;
  Api api = Api();

  listener(url) {
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (!loadingMore) {
          paginate(url);
          // Animate to bottom of list
          Timer(Duration(milliseconds: 100), () {
            controller.animateTo(
              controller.position.maxScrollExtent,
              duration: Duration(milliseconds: 100),
              curve: Curves.bounceIn,
            );
          });
        }
      }
    });
  }

  getFeed(String url) async {
    setApiRequestStatus(ApiRequestStatus.loading);
    print(url);
    try {
      CategoryModel feed = await api.getCategory(url);
      items = feed.feed!.entry!;
      setApiRequestStatus(ApiRequestStatus.loaded);
      listener(url);
    } catch (e) {
      checkError(e);
      throw (e);
    }
  }

  paginate(String url) async {
    if (apiRequestStatus != ApiRequestStatus.loading &&
        !loadingMore &&
        loadMore) {
      Timer(Duration(milliseconds: 100), () {
        controller.jumpTo(controller.position.maxScrollExtent);
      });
      loadingMore = true;
      page = page + 1;
      notifyListeners();
      try {
        CategoryModel feed = await api.getCategory(url + '&page=$page');
        items.addAll(feed.feed!.entry!);
        loadingMore = false;
        notifyListeners();
      } catch (e) {
        loadMore = false;
        loadingMore = false;
        notifyListeners();
        throw (e);
      }
    }
  }

  void checkError(e) {
    if (Constant.checkConnectionError(e)) {
      setApiRequestStatus(ApiRequestStatus.connectionError);
      showToast('Connection error');
    } else {
      setApiRequestStatus(ApiRequestStatus.error);
      showToast('Something went wrong, please try again');
    }
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: '$msg',
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }

  void setApiRequestStatus(ApiRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
}
