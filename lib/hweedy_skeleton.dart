import 'package:flutter/material.dart';

class SkeletonContainer extends StatefulWidget {
  final double width, height;
  final BorderRadius radius;
  final Color animateColor, bgColor;

  const SkeletonContainer._({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.radius = const BorderRadius.all(Radius.circular(12)),
    this.animateColor = Colors.white,
    this.bgColor = Colors.grey,
  }) : super(key: key);

  const SkeletonContainer.square({
    Key? key,
    required double width,
    required double height,
    final Color animateColor = Colors.white,
    final Color bgColor = Colors.grey,
  }) : this._(
            width: width,
            height: height,
            animateColor: animateColor,
            bgColor: bgColor,
            key: key);

  const SkeletonContainer.round({
    Key? key,
    required double width,
    required double height,
    final Color animateColor = Colors.white,
    final Color bgColor = Colors.grey,
    BorderRadius radius = const BorderRadius.all(Radius.circular(12)),
  }) : this._(
            width: width,
            height: height,
            key: key,
            animateColor: animateColor,
            bgColor: bgColor,
            radius: radius);
  const SkeletonContainer.circular({
    Key? key,
    required double width,
    required double height,
    final Color animateColor = Colors.white,
    final Color bgColor = Colors.grey,
    BorderRadius radius = const BorderRadius.all(Radius.circular(80)),
  }) : this._(
            width: width,
            height: height,
            key: key,
            radius: radius,
            bgColor: bgColor,
            animateColor: animateColor);

  @override
  State<SkeletonContainer> createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<SkeletonContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _positionAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _positionAnimation = Tween<double>(begin: -3, end: 3).animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      if (_positionAnimation.isCompleted) {
        _controller.repeat();
      } else if (_positionAnimation.isDismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            clipBehavior: Clip.hardEdge,
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: widget.radius,
              color: widget.bgColor.withOpacity(.3),
            ),
            child: Align(
              alignment: Alignment((_positionAnimation.value), 0),
              child: Container(
                width: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    widget.animateColor.withOpacity(.1),
                    widget.animateColor,
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
