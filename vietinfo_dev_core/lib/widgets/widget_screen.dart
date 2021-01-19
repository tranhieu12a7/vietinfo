import 'package:flutter/material.dart';

class WidgetScreen extends StatelessWidget {
  final Widget child;
  final Widget appBar;
  double heightAppBar;

  WidgetScreen({Key key, this.appBar, this.child, this.heightAppBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    double _heightAppBar =heightAppBar??50 + MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            appBar!=null? Container(
                height: _heightAppBar,
                width:MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
                child: appBar):SizedBox(),
            Expanded(child: child),
          ],
        ),
      ),

    );
  }
}
