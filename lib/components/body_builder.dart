import 'package:flutter/material.dart';
import 'package:flutter_book_app/components/loading_indicator.dart';
import 'package:flutter_book_app/enum/enum.dart';
import 'package:flutter_book_app/components/error_widget.dart';

class BodyBuilder extends StatelessWidget {
  final ApiRequestStatus? apiRequestStatus;
  final Widget? child;
  final Function()? reload;

  BodyBuilder(
      {Key? key,
      @required this.apiRequestStatus,
      @required this.child,
      @required this.reload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    switch (apiRequestStatus) {
      case ApiRequestStatus.loading:
        return LoadingWidget();
      case ApiRequestStatus.unInitialized:
        return LoadingWidget();
      case ApiRequestStatus.connectionError:
        return MyErrorWidget(
          refreshCallBack: reload,
          isConnection: true,
        );
      case ApiRequestStatus.error:
        return MyErrorWidget(
          refreshCallBack: reload,
          isConnection: false,
        );
      case ApiRequestStatus.loaded:
        return child!;
      default:
        return LoadingWidget();
    }
  }
}
