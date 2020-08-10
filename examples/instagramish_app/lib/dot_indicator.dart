import 'package:flutter/material.dart';

const _gapSmall = SizedBox(width: 4);
const _gapMiddle = SizedBox(width: 5);
const _gapLarge = SizedBox(width: 6);

class _DotSize {
  static const double large = 6;
}

double sizeFromAbsoluteDistance(int distance) {
  if (distance <= 1) {
    return 6;
  } else if (distance <= 2) {
    return 4;
  } else {
    return 2;
  }
}

EdgeInsets paddingFromDistance(int distance) {
  if (distance == 0) {
    return EdgeInsets.zero;
  }
  final absDistance = distance.abs();
  final padding = paddingFromAbsDistance(absDistance);
  if (distance.isNegative) {
    return EdgeInsets.only(left: padding);
  } else {
    return EdgeInsets.only(right: padding);
  }
}

double paddingFromAbsDistance(int distance) {
  if (distance == 1) {
    return 4;
  } else if (distance == 2) {
    return 5;
  } else {
    return 6;
  }
}

enum IndicatorState {
  start,
  normal,
}
const maxCount = 7;

// TODO(HeavenOSK): 移動したら非表示になる
// TODO(HeavenOSK): 移動したら、インジケータが動く
// TODO(HeavenOSK): 移動したら、インジケータの大きかさが変わる

class FixedScrollIndicator extends StatefulWidget {
  const FixedScrollIndicator({
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
  _FixedScrollIndicatorState createState() => _FixedScrollIndicatorState();
}

class _FixedScrollIndicatorState extends State<FixedScrollIndicator> {
  int _centerIndex = 1;

  @override
  void didUpdateWidget(FixedScrollIndicator oldWidget) {
    final distanceFromCenter = (_centerIndex - widget.currentIndex).abs();
    final shouldUpdateCenter = distanceFromCenter > 1;
    if (shouldUpdateCenter) {
      final diff = widget.currentIndex - oldWidget.currentIndex;
      _centerIndex += diff;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.length,
        (index) {
          final distance = _centerIndex - index;
          final absDistance = distance.abs();
          final visible = absDistance <= 3;
          print(_centerIndex);
          if (visible)
            return Padding(
              padding: paddingFromDistance(distance),
              child: _Dot(
                key: ValueKey(index),
                size: sizeFromAbsoluteDistance(absDistance),
                color: index == widget.currentIndex
                    ? widget.activeColor
                    : widget.inactiveColor,
              ),
            );
          return SizedBox();
        },
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
