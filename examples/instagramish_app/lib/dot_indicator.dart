import 'package:flutter/material.dart';

const _gapSmall = SizedBox(width: 4);
const _gapMiddle = SizedBox(width: 5);
const _gapLarge = SizedBox(width: 6);

class _DotSize {
  static const double large = 6;
  static const double middle = 4;
  static const double small = 2;
}

enum IndicatorState {
  start,
  normal,
}

class InstagramishDotIndicator extends StatelessWidget {
  const InstagramishDotIndicator({
    @required this.length,
    this.currentIndex,
    this.activeColor = const Color.fromRGBO(8, 148, 244, 1),
    this.inactiveColor = const Color.fromRGBO(219, 219, 219, 1),
    Key key,
  }) : super(key: key);

  final int length;
  final Color activeColor;
  final Color inactiveColor;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => _Dot(
          key: ValueKey(index),
          size: 6,
          color: index == currentIndex ? activeColor : inactiveColor,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    @required this.color,
    @required this.size,
    Key key,
  }) : super(key: key);

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color,
      ),
    );
  }
}
