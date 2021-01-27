

import 'package:flutter/material.dart';

class AnimationRedCircle extends StatefulWidget {
  @override
  _AnimationRedCircleState createState() => _AnimationRedCircleState();
}

class _AnimationRedCircleState extends State<AnimationRedCircle>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
    new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: EdgeInsets.only(right: 5.0),
        height: 10, width: 10,
        decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}