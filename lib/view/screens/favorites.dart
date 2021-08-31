import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_book_app/components/book_list.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:flutter_book_app/view_models/favorite_view_model.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  @override
  void deactivate() {
    super.deactivate();
    getFavorites();
  }

  getFavorites() {
    SchedulerBinding.instance!.addPostFrameCallback(
      (_) {
        if (mounted) {
          Provider.of<FavoritesProvider>(context, listen: false).getFavorites();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (BuildContext context, FavoritesProvider favoritesProvider,
          Widget? child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.keyboard_backspace),
            ),
            title: Text(
              'Favorites',
            ),
          ),
          body: favoritesProvider.books.isEmpty
              ? _buildEmptyList()
              : _buildFavoriteBooks(favoritesProvider),
        );
      },
    );
  }

  _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'You\'ve Not Added a Favorite Book',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildFavoriteBooks(FavoritesProvider favoritesProvider) {
    return ListView.builder(
      padding: EdgeInsets.all(5.0),
      shrinkWrap: true,
      itemCount: favoritesProvider.books.length,
      itemBuilder: (BuildContext context, int index) {
        Entry entry = Entry.fromJson(favoritesProvider.books[index]['item']);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: BookList(
            img: entry.link![1].href,
            title: entry.title!.t!,
            date: entry.published!.t!.split('T')[0].toString(),
            author: entry.author!.name!.t!,
            desc: entry.summary!.t!,
            entry: entry,
          ),
        );
      },
    );
  }
}
