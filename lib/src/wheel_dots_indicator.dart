import 'package:flutter/material.dart';

const double _maxSize = 6;

double sizeFromAbsoluteDistance(double distance) {
  if (distance <= 1) {
    return _maxSize;
  } else if (distance <= 2) {
    return 4;
  } else {
    return 2;
  }
}

const _defaultActiveColor = Color.fromRGBO(8, 148, 244, 1);
const _defaultInactiveColor = const Color.fromRGBO(219, 219, 219, 1);

// TODO(HeavenOSK): length が 0, 1, 2, の時を考慮する。
// TODO(HeavenOSK): 中途で length が変更された時を考慮する。
class WheelDotsIndicator extends StatefulWidget {
  const WheelDotsIndicator({
    @required this.itemCount,
    @required this.currentIndex,
    this.activeColor = _defaultActiveColor,
    this.inactiveColor = _defaultInactiveColor,
    this.dotAnimationCurve = Curves.easeOutQuad,
    Key key,
  })  : assert(itemCount != null && itemCount >= 0),
        assert(currentIndex != null && currentIndex < itemCount),
        assert(dotAnimationCurve != null),
        assert(inactiveColor != null),
        assert(activeColor != null),
        super(key: key);

  final int itemCount;
  final Color activeColor;
  final Color inactiveColor;
  final int currentIndex;
  final Curve dotAnimationCurve;

  @override
  _WheelDotsIndicatorState createState() => _WheelDotsIndicatorState();
}

class _WheelDotsIndicatorState extends State<WheelDotsIndicator> {
  double _centerIndex = 1.0;
  int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    _adjustCenter();
    super.initState();
  }

  void _adjustCenter() {
    if (widget.itemCount >= 3) {
      _centerIndex = 1;
    } else if (widget.itemCount == 2) {
      _centerIndex = 0.5;
    } else {
      _centerIndex = 0;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(WheelDotsIndicator oldWidget) {
    _currentIndex = widget.currentIndex;
    final distanceFromCenter = (_centerIndex - widget.currentIndex).abs();
    final shouldUpdateCenter = distanceFromCenter > 1;
    if (shouldUpdateCenter) {
      final diff = widget.currentIndex - oldWidget.currentIndex;
      _centerIndex += diff;
    }
    if (oldWidget.itemCount != widget.itemCount) {
      _adjustCenter();
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
              widget.itemCount,
              (index) {
                final distance = _centerIndex - index;
                final absDistance = distance.abs();
                final visible = absDistance <= 3;

                if (visible) {
                  return Align(
                    key: ValueKey(index),
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      margin: EdgeInsets.only(left: center - distance * 10),
                      duration: const Duration(milliseconds: 320),
                      curve: widget.dotAnimationCurve,
                      height: sizeFromAbsoluteDistance(absDistance),
                      width: sizeFromAbsoluteDistance(absDistance),
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
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
