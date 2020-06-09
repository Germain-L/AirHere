import 'package:flutter/material.dart';


class AnimatedValue extends StatefulWidget {
  AnimatedValue({this.aqiValue});
  final int aqiValue;
  @override
  _AnimatedValueState createState() => _AnimatedValueState();
}

class _AnimatedValueState extends State<AnimatedValue> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(seconds: 4), vsync: this);

    animation = IntTween(begin: 0, end: widget.aqiValue)
      .animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.ease)
      );

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Text(
          "AQI: ${animation.value.toString()}",
          style: TextStyle(fontSize: 52.0),
        );
      },
    );
  }
}
