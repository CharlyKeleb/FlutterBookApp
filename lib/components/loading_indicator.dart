import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  final bool isImage;

  LoadingWidget({this.isImage = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    if (isImage) {
      return SpinKitDoubleBounce(
        color: Theme.of(context).accentColor,
      );
    } else {
      return Container(
        height: 80.0,
        width: 100.0,
        child: LoadingIndicator(
          indicatorType: Indicator.lineScaleParty,
          colors: [Theme.of(context).accentColor],
          strokeWidth: 0.2,
        ),
      );
    }
  }
}
