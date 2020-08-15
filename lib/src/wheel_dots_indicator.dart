import 'package:flutter/material.dart';

const _dotSize = 6.0;
const _defaultActiveColor = Color.fromRGBO(8, 148, 244, 1);
const _defaultInactiveColor = const Color.fromRGBO(219, 219, 219, 1);
const _defaultDuration = Duration(milliseconds: 320);
const _defaultAnimationCurve = Curves.easeOutQuad;

/// An dots indicator that notify current index to user with wheel
/// animation.
class WheelDotsIndicator extends StatefulWidget {
  const WheelDotsIndicator({
    @required this.itemCount,
    @required this.indexController,
    this.activeColor = _defaultActiveColor,
    this.inactiveColor = _defaultInactiveColor,
    this.animationCurve = _defaultAnimationCurve,
    this.duration = _defaultDuration,
    Key key,
  })  : assert(itemCount != null && itemCount >= 0),
        assert(indexController != null),
        assert(inactiveColor != null),
        assert(activeColor != null),
        assert(animationCurve != null),
        assert(duration != null),
        super(key: key);

  /// A count of all item.
  final int itemCount;

  /// An active color of dot.
  final Color activeColor;

  /// An inactive color of dot.
  final Color inactiveColor;

  /// A curve of animation.
  final Curve animationCurve;

  /// A duration for animation.
  final Duration duration;

  /// A controller to control [WheelDotsIndicator].
  final ValueNotifier<int> indexController;

  @override
  _WheelDotsIndicatorState createState() => _WheelDotsIndicatorState();
}

class _WheelDotsIndicatorState extends State<WheelDotsIndicator> {
  double _centerIndex;
  int _currentIndex;
  int _itemCount;

  @override
  void initState() {
    _itemCount = widget.itemCount;
    _currentIndex = widget.indexController.value;
    _centerIndex = _getInitialCenter(widget.itemCount, _currentIndex);
    super.initState();
  }

  void _update() {
    _centerIndex = _getNewCenter(
      _centerIndex,
      _currentIndex,
      widget.indexController.value,
    );
    _currentIndex = widget.indexController.value;
  }

  double _getInitialCenter(
    int itemCount,
    int currentIndex,
  ) {
    if (itemCount <= 1) {
      return 0;
    } else if (itemCount <= 2) {
      return 0.5;
    } else {
      return (currentIndex + 1).toDouble();
    }
  }

  double _getNewCenter(
    double centerIndex,
    int oldCurrentIndex,
    newCurrentIndex,
  ) {
    final distanceFromCenter = (centerIndex - newCurrentIndex).abs();
    final shouldUpdateCenter = distanceFromCenter > 1;
    if (shouldUpdateCenter) {
      final diff = newCurrentIndex - oldCurrentIndex;
      return centerIndex + diff;
    } else {
      return centerIndex;
    }
  }

  double _sizeFromDistance(double largestDotSize, double distance) {
    if (distance <= 1) {
      return largestDotSize;
    } else if (distance <= 2) {
      return largestDotSize * 2 / 3;
    } else {
      return largestDotSize / 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.indexController,
      builder: (context, _) {
        _update();
        return SizedBox(
          height: _dotSize,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final center = constraints.maxWidth / 2;
              return Stack(
                children: List.generate(
                  _itemCount,
                  (index) {
                    final distance = _centerIndex - index;
                    final absDistance = distance.abs();
                    final visible = absDistance <= 3;

                    if (visible) {
                      return Align(
                        key: ValueKey(index),
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          margin: EdgeInsets.only(
                            left: center - distance * _dotSize * 1.6,
                          ),
                          duration: widget.duration,
                          curve: widget.animationCurve,
                          height: _sizeFromDistance(_dotSize, absDistance),
                          width: _sizeFromDistance(_dotSize, absDistance),
                          child: Container(
                            decoration: BoxDecoration(
                              color: index == _currentIndex
                                  ? widget.activeColor
                                  : widget.inactiveColor,
                              borderRadius: BorderRadius.circular(_dotSize),
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
      },
    );
  }
}
