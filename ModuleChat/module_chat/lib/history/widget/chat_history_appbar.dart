import 'package:flutter/material.dart';

class ChatHistoryAppBar extends PreferredSize {
  final Widget child;
  final double height;

  ChatHistoryAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Colors.white,
      alignment: Alignment.center,
      child: child,
    );
  }
}