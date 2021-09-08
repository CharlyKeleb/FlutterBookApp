import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_app/components/download_widget.dart';
import 'package:flutter_book_app/helpers/download_helper.dart';
import 'package:flutter_book_app/helpers/favorite_helper.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:flutter_book_app/theme/theme_config.dart';
import 'package:flutter_book_app/utils/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailsProvider extends ChangeNotifier {
  CategoryModel related = CategoryModel();

  String? path;

  bool isDownloading = false;
  bool loading = true;

  Entry? entry;

  var favDB = FavoriteDb();
  var dlDB = DownloadsDb();
  var currentlyReading;

  bool faved = false;
  bool downloaded = false;

  Api api = Api();

  getFeed(String url) async {
    setLoading(true);
    checkFav();
    checkDownload();
    try {
      CategoryModel feed = await api.getCategory(url);
      setRelated(feed);
      setLoading(false);
    } catch (e) {
      throw (e);
    }
  }

  // check if book is favorited
  checkFav() async {
    List c = await favDB.check({'id': entry!.id!.t.toString()});
    if (c.isNotEmpty) {
      setFaved(true);
    } else {
      setFaved(false);
    }
  }

  addFav() async {
    await favDB.add({
      'id': entry!.id!.t.toString(),
      'item': entry!.toJson(),
    });
    checkFav();
  }

  removeFav() async {
    favDB.remove({'id': entry!.id!.t.toString()}).then((v) {
      print(v);
      checkFav();
    });
  }

  // check if book has been downloaded before
  checkDownload() async {
    List downloads = await dlDB.check({'id': entry!.id!.t.toString()});
    if (downloads.isNotEmpty) {
      // check if book has been deleted
      String path = downloads[0]['path'];
      print(path);
      if (await File(path).exists()) {
        setDownloaded(true);
      } else {
        setDownloaded(false);
      }
    } else {
      setDownloaded(false);
    }
  }

  Future<List> getDownload() async {
    List c = await dlDB.check({'id': entry!.id!.t.toString()});
    return c;
  }

  addDownload(Map body) async {
    await dlDB.removeAllWithId({'id': entry!.id!.t.toString()});
    await dlDB.add(body);
    checkDownload();
  }

  removeDownload() async {
    dlDB.remove({'id': entry!.id!.t.toString()}).then((v) {
      print(v);
      checkDownload();
    });
  }

  Future downloadFile(BuildContext context, String url, String filename) async {
    PermissionStatus permissionStatus = await Permission.storage.request();

    if (permissionStatus != PermissionStatus.granted) {
      await Permission.storage.request();
      startDownload(context, url, filename);
      isDownloading = true;
    } else {
      startDownload(context, url, filename);
      isDownloading = true;
    }
  }

  startDownload(BuildContext context, String url, String filename) async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      Directory(appDocDir!.path.split('Android')[0] + '${Constants.appName}')
          .createSync();
    }

    path = Platform.isIOS
        ? appDocDir!.path + '/$filename.epub'
        : appDocDir!.path.split('Android')[0] +
            '${Constants.appName}/$filename.epub';
    print(path);
    File file = File(path!);
    if (!await file.exists()) {
      await file.create();
    } else {
      await file.delete();
      await file.create();
    }

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      isScrollControlled: false,
      isDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: url,
        path: path,
      ),
    ).then((v) {
      // When the download finishes, we then add the book
      // to our local database
      if (v != null) {
        addDownload(
          {
            'id': entry!.id!.t.toString(),
            'path': path,
            'image': '${entry!.link![1].href}',
            'size': v,
            'name': entry!.title!.t,
          },
        );
        Navigator.pop(context);
      }
    });
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setRelated(value) {
    related = value;
    notifyListeners();
  }

  CategoryModel getRelated() {
    return related;
  }

  void setEntry(value) {
    entry = value;
    notifyListeners();
  }

  void setFaved(value) {
    faved = value;
    notifyListeners();
  }

  void setDownloaded(value) {
    downloaded = value;
    notifyListeners();
  }
}
