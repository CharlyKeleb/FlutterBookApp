import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  final Function()? refreshCallBack;
  final bool isConnection;

  MyErrorWidget({@required this.refreshCallBack, this.isConnection = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Text(
          //   '☹',
          //   style: TextStyle(
          //     fontSize: 60.0,
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: Text(
              getErrorText(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline6!.color,
                fontSize: 19.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Card(
            child: GestureDetector(
              onTap: refreshCallBack,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'TRY AGAIN',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getErrorText() {
    if (isConnection) {
      return 'No Network Connection';
    } else {
      return 'Unable to load this page';
    }
  }
}
