import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_app/components/loading_indicator.dart';
import 'package:flutter_book_app/models/category_model.dart';
import 'package:flutter_book_app/utils/navigate.dart';
import 'package:flutter_book_app/view/screens/book_details.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class BookList extends StatelessWidget {
  final String? img;
  final String? title;
  final String? author;
  final String? date;
  final String? desc;
  final Entry? entry;

  BookList({
    Key? key,
    this.img,
    this.title,
    this.author,
    this.desc,
    this.entry,
    this.date,
  });

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
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          height: 150,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  child: Hero(
                    tag: imgTag,
                    child: CachedNetworkImage(
                      imageUrl: '$img',
                      placeholder: (context, url) => Container(
                        height: 150.0,
                        width: 100.0,
                        child: LoadingWidget(
                          isImage: true,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/invalid.jpeg',
                        fit: BoxFit.cover,
                        height: 150.0,
                        width: 100.0,
                      ),
                      fit: BoxFit.cover,
                      height: 150.0,
                      width: 100.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: titleTag,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          '${title!.replaceAll(r'\', '')}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            // color: Theme.of(context).textTheme.title.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Hero(
                      tag: authorTag,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          author!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${desc!.length < 100 ? desc : desc!.substring(0, 100)}...'
                          .replaceAll(r'\n', '\n')
                          .replaceAll(r'\r', '')
                          .replaceAll(r'\"', '"'),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Published on $date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
