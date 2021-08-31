import 'package:flutter/foundation.dart';
import 'package:flutter_book_app/helpers/favorite_helper.dart';

class FavoritesProvider extends ChangeNotifier {
  
  List books = [];
  bool loading = true;
  var db = FavoriteDb();

  getFavorites() async {
    setLoading(true);
    books.clear();
    List all = await db.listAll();
    books.addAll(all);
    setLoading(false);
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setBooks(value) {
    books = value;
    notifyListeners();
  }

  List getBooks() {
    return books;
  }
}
