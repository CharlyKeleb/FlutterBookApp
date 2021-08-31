import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_app/components/loading_indicator.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:flutter_book_app/utils/navigate.dart';
import 'package:flutter_book_app/view/screens/book_details.dart';
import 'package:uuid/uuid.dart';

class BookCard extends StatelessWidget {
  final String? img;
  final String? title;
  final Entry? entry;
  BookCard({Key? key, this.img, this.title, this.entry});

  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigate.pushPage(
          context,
          BookDetails(
            entry: entry,
            imgTag: imgTag,
            titleTag: titleTag,
            authorTag: authorTag,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Hero(
                tag: imgTag,
                child: CachedNetworkImage(
                  imageUrl: '$img',
                  placeholder: (context, url) => Container(
                    height: 200.0,
                    width: 145.0,
                    child: LoadingWidget(
                      isImage: true,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/invalid.jpeg',
                    fit: BoxFit.cover,
                    height: 200.0,
                    width: 145.0,
                  ),
                  fit: BoxFit.cover,
                  height: 200.0,
                  width: 145.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                width: 150.0,
                child: Hero(
                  tag: titleTag,
                  child: Column(
                    children: [
                      Text(
                        '${title!.replaceAll(r'\', '')}',
                        textAlign: TextAlign.center,
                        maxLines: null,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.0,
                          color: Theme.of(context).accentColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
