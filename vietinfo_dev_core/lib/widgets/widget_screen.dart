import 'package:flutter/material.dart';
import 'package:vietinfo_dev_core/vietinfo_dev_core.dart';

class WidgetScreen extends StatelessWidget {
  final Widget child;
  final Widget appBar;
  final BoxDecoration appBarBoxDecoration;
  double heightAppBar;

  WidgetScreen(
      {Key key, this.appBar, this.child, this.heightAppBar, this.appBarBoxDecoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _heightAppBar = heightAppBar ?? 50 + MediaQuery
        .of(context)
        .padding
        .top;
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: appBarBoxDecoration ?? new BoxDecoration(),
        child: Column(
          children: [
            appBar != null ? Container(
                height: _heightAppBar,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: EdgeInsets.only(top: MediaQuery
                    .of(context)
                    .padding
                    .top),
                child: appBar) : SizedBox(),
            Expanded(child: appBar == null ?
            Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: EdgeInsets.only(top: MediaQuery
                    .of(context)
                    .padding
                    .top),
                child: child ?? SizedBox()) : child

            ),
          ],
        ),
      ),

    );
  }
}
