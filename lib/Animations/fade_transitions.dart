import 'package:flutter/material.dart';

class FadeTransAnimation extends StatefulWidget {
  final Widget child;
  final int duration;

  const FadeTransAnimation({
    super.key,
    required this.child, this.duration=1500,
  });

  @override
  State<FadeTransAnimation> createState() => _FadeTransAnimationState();
}

class _FadeTransAnimationState extends State<FadeTransAnimation> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> logoFadeAnimation;
  late Animation<double> scaleAnimation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration:  Duration(milliseconds: widget.duration),
    );

    logoFadeAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    scaleAnimation = Tween<double>(begin: 0, end: 1).animate(controller);

    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: logoFadeAnimation,
      child: widget.child,
    );
  }
}
