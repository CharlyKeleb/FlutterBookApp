import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_book_app/components/book_list.dart';
import 'package:flutter_book_app/components/description_text.dart';
import 'package:flutter_book_app/components/loading_indicator.dart';
import 'package:flutter_book_app/helpers/book_locator_helper.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:flutter_book_app/view_models/details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class BookDetails extends StatefulWidget {
  final Entry? entry;
  final String? imgTag;
  final String? titleTag;
  final String? authorTag;

  const BookDetails(
      {Key? key, this.entry, this.imgTag, this.titleTag, this.authorTag});

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback(
      (_) {
        Provider.of<DetailsProvider>(context, listen: false)
            .setEntry(widget.entry);
        Provider.of<DetailsProvider>(context, listen: false).getFeed(
            widget.entry!.author!.uri!.t!.replaceAll(r'\&lang=en', ''));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsProvider>(
      builder:
          (BuildContext context, DetailsProvider viewModel, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.keyboard_backspace),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                  if (viewModel.faved) {
                    viewModel.removeFav();
                  } else {
                    viewModel.addFav();
                  }
                },
                icon: Icon(
                  viewModel.faved
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: viewModel.faved
                      ? Colors.red
                      : Theme.of(context).iconTheme.color,
                ),
              ),
              IconButton(
                onPressed: () => _shareBook(),
                icon: Icon(
                  CupertinoIcons.share,
                ),
              ),
            ],
          ),
          body: _buildBody(viewModel, context),
        );
      },
    );
  }

  _buildBody(DetailsProvider viewModel, BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      children: [
        _buildImageTitle(viewModel, context),
        SizedBox(height: 5.0),
        Divider(thickness: 2.0),
        Text(
          'Description',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0),
        DescriptionWidget(
          text: '${widget.entry!.summary!.t}',
        ),
        SizedBox(height: 10.0),
        _buildDownloadReadButton(viewModel, context),
        SizedBox(height: 15.0),
        Text(
          'More from Author',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Divider(thickness: 2.0),
        _buildMoreBookFromAuthor(viewModel),
      ],
    );
  }

  _buildImageTitle(DetailsProvider viewModel, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 255.0,
          width: MediaQuery.of(context).size.width,
          child: Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Hero(
                    tag: widget.imgTag!,
                    child: CachedNetworkImage(
                      imageUrl: '${widget.entry!.link![1].href}',
                      placeholder: (context, url) => Container(
                        height: 250.0,
                        width: 145.0,
                        child: LoadingWidget(),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.sentiment_very_dissatisfied_rounded),
                      fit: BoxFit.cover,
                      height: 200.0,
                      width: 130.0,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildCategory(widget.entry!, context),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Hero(
          tag: widget.authorTag!,
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              '${widget.entry!.author!.name!.t}',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Hero(
          tag: widget.titleTag!,
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              '${widget.entry!.title!.t!.replaceAll(r'\', '')}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildCategory(Entry entry, BuildContext context) {
    if (entry.category == null) {
      return SizedBox();
    } else {
      return Container(
        height: 50,
        width: 150,
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: entry.category!.length > 4 ? 4 : entry.category!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 210 / 80,
          ),
          itemBuilder: (BuildContext context, int index) {
            Category cat = entry.category![index];
            return Padding(
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
              child: Container(
                height: 25.0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Theme.of(context).accentColor),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${cat.label}',
                        style: TextStyle(
                          fontSize: cat.label!.length > 18 ? 4.5 : 9.0,
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
      );
    }
  }

  openBook(DetailsProvider provider) async {
    List dlList = await provider.getDownload();
    if (dlList.isNotEmpty) {
      Map dl = dlList[0];
      String path = dl['path'];

      List locators =
          await BookLocatorDB().getLocator(widget.entry!.id!.t.toString());

      EpubViewer.setConfig(
        identifier: 'androidBook',
        themeColor: Theme.of(context).accentColor,
        scrollDirection: EpubScrollDirection.VERTICAL,
        enableTts: false,
        allowSharing: true,
      );
      EpubViewer.open(path,
          lastLocation:
              locators.isNotEmpty ? EpubLocator.fromJson(locators[0]) : null);
      EpubViewer.locatorStream.listen((event) async {
        // Get locator here
        Map json = jsonDecode(event);
        json['bookId'] = widget.entry!.id!.t.toString();
        // Save locator to your database
        await BookLocatorDB().update(json);
      });
    }
  }

  _buildDownloadReadButton(DetailsProvider viewModel, BuildContext context) {
    if (viewModel.downloaded) {
      return Container(
        height: 50.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).accentColor,
            ),
          ),
          onPressed: () {
            openBook(viewModel);
          },
          child: Center(
            child: Text(
              'Read Now',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 50.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).accentColor,
            ),
          ),
          onPressed: () {
            viewModel.downloadFile(
              context,
              widget.entry!.link![3].href!,
              widget.entry!.title!.t!
                  .replaceAll(' ', '_')
                  .replaceAll(r"\'", "'"),
            );
          },
          child: Center(
            child: Text(
              'Download',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );
    }
  }

  _buildMoreBookFromAuthor(DetailsProvider viewModel) {
    if (viewModel.loading) {
      return Container(
        height: 100.0,
        child: LoadingWidget(),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: viewModel.related.feed!.entry!.length,
        itemBuilder: (BuildContext context, int index) {
          Entry entry = viewModel.related.feed!.entry![index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
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

  _shareBook() {
    Share.share(
        'Read/Download ${widget.entry!.title!.t} from ${widget.entry!.link![3].href}',
        subject:
            '${widget.entry!.title!.t} by ${widget.entry!.author!.name!.t}');
  }
}
