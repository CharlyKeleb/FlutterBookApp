import 'package:flutter_book_app/theme/theme_config.dart';
import 'package:flutter_book_app/view_models/details_view_model.dart';
import 'package:flutter_book_app/view_models/favorite_view_model.dart';
import 'package:flutter_book_app/view_models/genre_view_model.dart';
import 'package:flutter_book_app/view_models/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';



List<SingleChildWidget> providers = [

  ChangeNotifierProvider(create: (_) => FavoritesProvider()),
  ChangeNotifierProvider(create: (_) => DetailsProvider()),
  ChangeNotifierProvider(create: (_) => GenreProvider()),
  ChangeNotifierProvider(create: (_) => HomeProvider()),
  ChangeNotifierProvider(create: (_) => ThemeNotifier()),

];
