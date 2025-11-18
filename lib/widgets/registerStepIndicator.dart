library steps_indicator;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:steps_indicator/linear_painter.dart';

/// Custom RegisterStepsIndicator to display a line with different kind of steps
class RegisterStepsIndicator extends StatefulWidget {
  /// Selected step [default = 0]
  final int selectedStep;

  /// Number of total Steps
  final int nbSteps;

  /// Border color for selected step [default = Colors.blue]
  final Color selectedStepColorOut;

  /// Background color for selected step [default = Colors.white]
  final Color selectedStepColorIn;

  /// Background color for done step [default = Colors.blue]
  final Color doneStepColor;

  /// Border color for unselected step [default = Colors.blue]
  final Color unselectedStepColorOut;

  /// Background color for unselected step [default = Colors.blue]
  final Color unselectedStepColorIn;

  /// Color for done line [default = Colors.blue]
  final Color doneLineColor;

  /// Color for undone line [default = Colors.blue]
  final Color undoneLineColor;

  /// Make it horizontal or vertical [default = true]
  final bool isHorizontal;

  /// Length for each line [default = 40]
  final double lineLength;

  /// Line thickness for done line [default = 1]
  final double doneLineThickness;

  /// Line thickness for undone line [default = 1]
  final double undoneLineThickness;

  /// Done step size [default = 10]
  final double doneStepSize;

  /// Unselected step size [default = 10]
  final double unselectedStepSize;

  /// Selected step size [default = 14]
  final double selectedStepSize;

  /// Selected step border size [default = 1]
  final double selectedStepBorderSize;

  /// Unselected step border size [default = 1]
  final double unselectedStepBorderSize;

  /// Custom widget for done step (overrides default circle + check)
  final Widget? doneStepWidget;

  /// Custom widget for unselected step (overrides default hollow circle)
  final Widget? unselectedStepWidget;

  /// Custom widget for selected step (overrides default ring + number)
  final Widget? selectedStepWidget;

  /// Custom line length per step
  final List<RegisterStepsIndicatorCustomLine>? lineLengthCustomStep;

  /// Enable line animation [default = false]
  final bool enableLineAnimation;

  /// Enable step animation [default = false]
  final bool enableStepAnimation;

  const RegisterStepsIndicator({
    this.selectedStep = 0,
    this.nbSteps = 4,
    this.selectedStepColorOut = Colors.blue,
    this.selectedStepColorIn = Colors.white,
    this.doneStepColor = Colors.blue,
    this.unselectedStepColorOut = Colors.blue,
    this.unselectedStepColorIn = Colors.white,
    this.doneLineColor = Colors.blue,
    this.undoneLineColor = Colors.blue,
    this.isHorizontal = true,
    this.lineLength = 40,
    this.doneLineThickness = 1,
    this.undoneLineThickness = 1,
    this.doneStepSize = 10,
    this.unselectedStepSize = 10,
    this.selectedStepSize = 14,
    this.selectedStepBorderSize = 1,
    this.unselectedStepBorderSize = 1,
    this.doneStepWidget,
    this.unselectedStepWidget,
    this.selectedStepWidget,
    this.lineLengthCustomStep,
    this.enableLineAnimation = false,
    this.enableStepAnimation = false,
  });

  @override
  _RegisterStepsIndicatorState createState() => _RegisterStepsIndicatorState();
}

class _RegisterStepsIndicatorState extends State<RegisterStepsIndicator>
    with TickerProviderStateMixin {
  /// Previous boolean, use for pick the right animation (line & step)
  bool _isPreviousLine = false;
  bool _isPreviousStep = false;

  /// Line animation
  late AnimationController _animationControllerToNext;
  late Animation<double> _animationToNext;
  double _percentToNext = 0;

  late AnimationController _animationControllerToPrevious;
  late Animation<double> _animationToPrevious;
  double _percentToPrevious = 1;

  /// Step animation
  late AnimationController _animationControllerSelectedStep;
  late AnimationController _animationControllerDoneStep;
  late AnimationController _animationControllerUnselectedStep;

  /// Init all animation controller
  @override
  void initState() {
    super.initState();
    _animationControllerToNext = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animationControllerToPrevious = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animationControllerSelectedStep = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animationControllerDoneStep = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animationControllerUnselectedStep = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  /// Dispose all animation controller
  @override
  void dispose() {
    _animationControllerToNext.dispose();
    _animationControllerToPrevious.dispose();
    _animationControllerSelectedStep.dispose();
    _animationControllerDoneStep.dispose();
    _animationControllerUnselectedStep.dispose();
    super.dispose();
  }

  /// All the logic for activating animations when the widget is updated
  @override
  void didUpdateWidget(RegisterStepsIndicator oldWidget) {
    if (widget.enableStepAnimation) {
      _animationControllerSelectedStep.reset();
      _animationControllerDoneStep.reset();
      _animationControllerUnselectedStep.reset();

      if (widget.selectedStep < oldWidget.selectedStep) {
        setState(() {
          _isPreviousStep = true;
        });
      } else {
        setState(() {
          _isPreviousStep = false;
        });
      }
    }

    if (widget.enableLineAnimation) {
      if (widget.selectedStep > oldWidget.selectedStep) {
        _animationControllerToNext.reset();
        setState(() {
          _animationToNext =
              Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationControllerToNext,
                  curve: Curves.linear,
                ),
              )..addListener(() {
                setState(() {
                  _percentToNext = _animationToNext.value;
                });
              });
          _animationControllerToNext.forward();
        });
      } else if (widget.selectedStep < oldWidget.selectedStep) {
        _animationControllerToPrevious.reset();
        setState(() {
          _isPreviousLine = true;
          _animationToPrevious =
              Tween<double>(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: _animationControllerToPrevious,
                  curve: Curves.linear,
                ),
              )..addListener(() {
                setState(() {
                  _percentToPrevious = _animationToPrevious.value;
                });
                if (_animationControllerToPrevious.isCompleted) {
                  _isPreviousLine = false;
                }
              });
          _animationControllerToPrevious.forward();
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Build the complete RegisterStepsIndicator widget
  @override
  Widget build(BuildContext context) {
    if (widget.isHorizontal) {
      // Display in Row
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: [
            widget.selectedStepSize,
            widget.doneStepSize,
            widget.unselectedStepSize,
          ].reduce(max),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < widget.nbSteps; i++) stepBuilder(i),
          ],
        ),
      );
    } else {
      // Display in Column
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: [
            widget.selectedStepSize,
            widget.doneStepSize,
            widget.unselectedStepSize,
          ].reduce(max),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < widget.nbSteps; i++) stepBuilder(i),
          ],
        ),
      );
    }
  }

  /// A function to return the right widget according to the index [i]
  Widget stepBuilder(int i) {
    if (widget.isHorizontal) {
      // Display in Row
      return widget.selectedStep == i
          ? Row(
              children: <Widget>[
                stepSelectedWidget(i),
                widget.selectedStep == widget.nbSteps
                    ? stepLineDoneWidget(i)
                    : Container(),
                i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container(),
              ],
            )
          : widget.selectedStep > i
          ? Row(
              children: <Widget>[
                stepDoneWidget(i),
                i < widget.nbSteps - 1 ? stepLineDoneWidget(i) : Container(),
              ],
            )
          : Row(
              children: <Widget>[
                stepUnselectedWidget(i),
                i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container(),
              ],
            );
    } else {
      // Display in Column
      return widget.selectedStep == i
          ? Column(
              children: <Widget>[
                stepSelectedWidget(i),
                widget.selectedStep == widget.nbSteps
                    ? stepLineDoneWidget(i)
                    : Container(),
                i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container(),
              ],
            )
          : widget.selectedStep > i
          ? Column(
              children: <Widget>[
                stepDoneWidget(i),
                i < widget.nbSteps - 1 ? stepLineDoneWidget(i) : Container(),
              ],
            )
          : Column(
              children: <Widget>[
                stepUnselectedWidget(i),
                i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container(),
              ],
            );
    }
  }

  // ===== VISUAL HELPERS – nouveaux rendus « top » =====

  Widget _buildUnselectedCircle(int index, {double scale = 1.0}) {
    final baseSize = widget.unselectedStepSize;
    final size = max(0.0, baseSize * scale);
    final label = (index + 1).toString();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.unselectedStepColorIn.withOpacity(0.9),
        border: Border.all(
          color: widget.unselectedStepColorOut.withOpacity(0.45),
          width: widget.unselectedStepBorderSize,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: size * 0.42,
            fontWeight: FontWeight.w600,
            color: widget.unselectedStepColorOut.withOpacity(0.55),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCircle(int index, {double scale = 1.0}) {
    final baseSize = widget.selectedStepSize;
    final size = max(0.0, baseSize * scale);
    final label = (index + 1).toString();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            widget.selectedStepColorOut.withOpacity(0.2),
            widget.selectedStepColorOut.withOpacity(0.8),
            widget.selectedStepColorOut.withOpacity(0.2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.selectedStepColorOut.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.72,
          height: size * 0.72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.selectedStepColorIn,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: size * 0.42,
                fontWeight: FontWeight.w800,
                color: widget.selectedStepColorOut,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoneCircle({double scale = 1.0}) {
    final baseSize = widget.doneStepSize;
    final size = max(0.0, baseSize * scale);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.doneStepColor,
        boxShadow: [
          BoxShadow(
            color: widget.doneStepColor.withOpacity(0.28),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(Icons.check, size: size * 0.55, color: Colors.white),
    );
  }

  /// A function to return the unselected step widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepUnselectedWidget(int i) {
    if (widget.unselectedStepWidget != null) {
      return widget.unselectedStepWidget!;
    }

    if (widget.selectedStep == i - 1 &&
        _isPreviousStep &&
        widget.enableStepAnimation) {
      _animationControllerUnselectedStep.forward();

      return AnimatedBuilder(
        animation: _animationControllerUnselectedStep,
        builder: (BuildContext context, Widget? child) {
          final scale = _animationControllerUnselectedStep.value;
          return _buildUnselectedCircle(i, scale: scale);
        },
      );
    }

    return _buildUnselectedCircle(i);
  }

  /// A function to return the selected step widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepSelectedWidget(int i) {
    if (widget.selectedStepWidget != null) {
      return widget.selectedStepWidget!;
    }

    if (widget.selectedStep == i &&
        (i != 0 || _isPreviousStep) &&
        widget.enableStepAnimation) {
      _animationControllerSelectedStep.forward();

      return AnimatedBuilder(
        animation: _animationControllerSelectedStep,
        builder: (BuildContext context, Widget? child) {
          final scale = max(0.0, _animationControllerSelectedStep.value);
          return _buildSelectedCircle(i, scale: scale);
        },
      );
    }

    return _buildSelectedCircle(i);
  }

  /// A function to return the done step widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepDoneWidget(int i) {
    if (widget.doneStepWidget != null) {
      return widget.doneStepWidget!;
    }

    if (widget.selectedStep - 1 == i &&
        !_isPreviousStep &&
        widget.enableStepAnimation) {
      _animationControllerDoneStep.forward();

      return AnimatedBuilder(
        animation: _animationControllerDoneStep,
        builder: (BuildContext context, Widget? child) {
          final scale = _animationControllerDoneStep.value;
          return _buildDoneCircle(scale: scale);
        },
      );
    }

    return _buildDoneCircle();
  }

  /// A function to return the line done widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepLineDoneWidget(int i) {
    final length = getLineLength(i);
    return SizedBox(
      height: widget.isHorizontal ? widget.doneLineThickness : length,
      width: widget.isHorizontal ? length : widget.doneLineThickness,
      child: CustomPaint(
        painter: LinearPainter(
          progress: widget.selectedStep == i + 1 && widget.enableLineAnimation
              ? _percentToNext
              : 1,
          progressColor: widget.doneLineColor,
          backgroundColor: widget.undoneLineColor.withOpacity(0.15),
          lineThickness: widget.isHorizontal
              ? widget.doneLineThickness
              : length,
        ),
      ),
    );
  }

  /// A function to return the line undone widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepLineUndoneWidget(int i) {
    final length = getLineLength(i);

    if (_isPreviousLine &&
        widget.selectedStep == i &&
        widget.enableLineAnimation) {
      return SizedBox(
        height: widget.isHorizontal ? widget.undoneLineThickness : length,
        width: widget.isHorizontal ? length : widget.undoneLineThickness,
        child: CustomPaint(
          painter: LinearPainter(
            progress: _percentToPrevious,
            progressColor: widget.doneLineColor,
            backgroundColor: widget.undoneLineColor,
            lineThickness: widget.isHorizontal
                ? widget.undoneLineThickness
                : length,
          ),
        ),
      );
    }

    return Container(
      height: widget.isHorizontal ? widget.undoneLineThickness : length,
      width: widget.isHorizontal ? length : widget.undoneLineThickness,
      decoration: BoxDecoration(
        color: widget.undoneLineColor.withOpacity(0.35),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// A function to return the line length of a specific index [i]
  double getLineLength(int i) {
    final nbStep = i + 1;
    if (widget.lineLengthCustomStep != null &&
        widget.lineLengthCustomStep!.isNotEmpty) {
      if (widget.lineLengthCustomStep!.any((it) => (it.nbStep - 1) == nbStep)) {
        return widget.lineLengthCustomStep!
            .firstWhere((it) => (it.nbStep - 1) == nbStep)
            .length;
      }
    }
    return widget.lineLength;
  }
}

/// Class to define a custom line with [nbStep] & [length]
class RegisterStepsIndicatorCustomLine {
  final int nbStep;
  final double length;

  RegisterStepsIndicatorCustomLine({
    required this.nbStep,
    required this.length,
  });
}
