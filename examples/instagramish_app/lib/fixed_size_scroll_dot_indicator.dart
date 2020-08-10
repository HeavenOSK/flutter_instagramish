import 'package:flutter/material.dart';

const double _maxSize = 6;

double sizeFromAbsoluteDistance(int distance) {
  if (distance <= 1) {
    return _maxSize;
  } else if (distance <= 2) {
    return 4;
  } else {
    return 2;
  }
}

double paddingFromDistance(int distance) {
  final padding = paddingFromAbsDistance(distance.abs());
  if (distance.isNegative) {
    return -padding;
  } else {
    return padding;
  }
}

double paddingFromAbsDistance(int distance) {
  if (distance == 0) {
    return 0;
  } else if (distance == 1) {
    return 10;
  } else if (distance == 2) {
    return 20;
  } else {
    return 28;
  }
}

const maxCount = 7;

// TODO(HeavenOSK): length が 0, 1, 2, の時を考慮する。
// TODO(HeavenOSK): 中途で length が変更された時を考慮する。
class FixedSizeScrollDotIndicator extends StatefulWidget {
  const FixedSizeScrollDotIndicator({
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
  _FixedSizeScrollDotIndicatorState createState() =>
      _FixedSizeScrollDotIndicatorState();
}

class _FixedSizeScrollDotIndicatorState
    extends State<FixedSizeScrollDotIndicator> {
  int _centerIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(FixedSizeScrollDotIndicator oldWidget) {
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
    return SizedBox(
      height: _maxSize,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final center = constraints.maxWidth / 2;
          return Stack(
            children: List.generate(
              widget.length,
              (index) {
                final distance = _centerIndex - index;
                final absDistance = distance.abs();
                final visible = absDistance <= 3;

                if (visible) {
                  final size = sizeFromAbsoluteDistance(absDistance);
                  return Align(
                    key: ValueKey(index),
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      margin: EdgeInsets.only(
                        left: center - paddingFromDistance(distance),
                      ),
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      height: size,
                      width: size,
                      child: Container(
                        decoration: BoxDecoration(
                          color: index == widget.currentIndex
                              ? widget.activeColor
                              : widget.inactiveColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
