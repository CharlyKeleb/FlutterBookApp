import 'package:flutter/material.dart';
import 'package:flutter_book_app/components/body_builder.dart';
import 'package:flutter_book_app/components/book_card.dart';
import 'package:flutter_book_app/components/loading_indicator.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:flutter_book_app/utils/api.dart';
import 'package:flutter_book_app/utils/navigate.dart';
import 'package:flutter_book_app/view/screens/genre.dart';
import 'package:flutter_book_app/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  Api api = Api();

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider viewModel, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Explore',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: BodyBuilder(
            apiRequestStatus: viewModel.apiRequestStatus,
            child: _buildBody(viewModel),
            reload: () => viewModel.getFeeds(),
          ),
        );
      },
    );
  }

  _buildBody(HomeProvider viewModel) {
    return ListView.builder(
      itemCount: viewModel.top.feed?.link?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        Link link = viewModel.top.feed!.link![index];

        // We don't need the tags from 0-9 because
        // they are not categories
        if (index < 10) {
          return SizedBox();
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: <Widget>[
              _buildHeader(link),
              SizedBox(height: 10.0),
              _buildBookList(link),
            ],
          ),
        );
      },
    );
  }

  _buildHeader(Link link) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              '${link.title}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigate.pushPage(
                context,
                Genre(
                  title: '${link.title}',
                  url: link.href,
                ),
              );
            },
            child: Text(
              'Show More',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBookList(Link link) {
    return FutureBuilder<CategoryModel>(
      future: api.getCategory(link.href!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          CategoryModel category = snapshot.data!;

          return Container(
            height: 260.0,
            child: Center(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.horizontal,
                itemCount: category.feed!.entry!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  Entry entry = category.feed!.entry![index];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: BookCard(
                      img: entry.link![1].href,
                      title: entry.title!.t!,
                      entry: entry,
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return Container(
            height: 210.0,
            child: LoadingWidget(),
          );
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
