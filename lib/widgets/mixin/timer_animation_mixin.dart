import 'package:flutter/material.dart';

mixin TimerAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProvider {
  late final AnimationController _controller;

  final Duration timerDuration = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: timerDuration);
    // _controller.forward();
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        onTimeOver();
      }
    });
  }

  void startAnimation() {
    _controller.forward();
  }

  void pauseAnimation() {
    _controller.stop();
  }

  void restartAnimation() {
    _controller.reset();
    startAnimation();
  }

  // This method will be called when the timer is over
  void onTimeOver();

  Animation<double> get animationValue => _controller.view;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
