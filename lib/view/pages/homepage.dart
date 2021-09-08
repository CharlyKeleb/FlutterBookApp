import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_book_app/components/body_builder.dart';
import 'package:flutter_book_app/components/custom_card.dart';
import 'package:flutter_book_app/components/book_card.dart';
import 'package:flutter_book_app/components/book_list.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:flutter_book_app/utils/navigate.dart';
import 'package:flutter_book_app/view/screens/book_details.dart';
import 'package:flutter_book_app/view/screens/genre.dart';
import 'package:flutter_book_app/view/screens/reading_list.dart';
import 'package:flutter_book_app/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback(
      (_) => Provider.of<HomeProvider>(context, listen: false).getFeeds(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider viewModel, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Flutter Book App'),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigate.pushPage(context, ReadingList());
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(CupertinoIcons.bookmark_solid, size: 25.0),
                ),
              )
            ],
          ),
          body: _buildBody(viewModel, context),
        );
      },
    );
  }

  Widget _buildBody(HomeProvider viewModel, BuildContext context) {
    return BodyBuilder(
      apiRequestStatus: viewModel.apiRequestStatus,
      child: _buildBodyList(viewModel, context),
      reload: () => viewModel.getFeeds(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildBodyList(HomeProvider viewModel, BuildContext context) {
  return RefreshIndicator(
    onRefresh: () => viewModel.getFeeds(),
    child: ListView(
      children: <Widget>[
        _buildFeaturedBook(viewModel),
        SizedBox(height: 5.0),
        _buildCategories(viewModel),
        SizedBox(height: 10.0),
        _buildRecentlyAdded(viewModel),
      ],
    ),
  );
}

_buildFeaturedBook(HomeProvider viewModel) {
  return Container(
    height: 245.0,
    child: Center(
      child: ListView.builder(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.top.feed?.entry?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          Entry entry = viewModel.top.feed!.entry![index];
          return BookCard(
            img: entry.link![1].href,
            title: entry.title!.t!,
            entry: entry,
          );
        },
      ),
    ),
  );
}

_buildCategories(HomeProvider viewModel) {
  return Column(
    children: [
      _buildHeader("Categories", Icons.chevron_right),
      Container(
        height: 50.0,
        child: Center(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.top.feed?.link?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              Link link = viewModel.top.feed!.link![index];
              if (index < 10) {
                return SizedBox();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    // color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(color: Theme.of(context).accentColor),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    onTap: () {
                      Navigate.pushPage(
                        context,
                        Genre(
                          title: '${link.title}',
                          url: link.href,
                        ),
                      );
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${link.title}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}

_buildRecentlyAdded(HomeProvider viewModel) {
  return Column(
    children: [
      _buildHeader("Recently Added", Icons.arrow_drop_down),
      ListView.builder(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: viewModel.recent.feed?.entry?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          Entry entry = viewModel.recent.feed!.entry![index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
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
      ),
    ],
  );
}

_buildHeader(String title, IconData icon) {
  return Padding(
    padding: EdgeInsets.all(20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            '$title',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(onTap: () {}, child: Icon(icon)),
      ],
    ),
  );
}
