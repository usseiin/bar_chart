import 'dart:math';

import 'package:flutter/material.dart';

class BarChart extends CustomPainter {
  Color? backgroundColor;
  double? mainSpaceRatio;
  List<double>? values;
  double? bottomSpace;
  double? barSpaceRatio;
  double? maxValue;

  BarChart({
    this.backgroundColor = Colors.transparent,
    this.mainSpaceRatio = .9,
    this.values = list,
    this.bottomSpace = .05,
    this.barSpaceRatio = .75,
    this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var width = size.width;
    var totalBarSpaceWidth = width * mainSpaceRatio!;
    var numberOfBar = values!.length;
    var barSpaceWidth = totalBarSpaceWidth / numberOfBar;
    var barWidth = barSpaceRatio! * barSpaceWidth;
    var spaceBetweenBar = mainSpaceRatio.percentLeft()! * barSpaceWidth;
    var barMidPoint = spaceBetweenBar + (0.5 * barWidth);
    var interval = 3;
    var maxVal = maxValue ?? values!.reduce(max);
    double interval_ = maxVal / (interval - 1);

    final nav = <int>[];

    for (var i = 0; i < interval; i++) {
      nav.add((i * interval_).round());
    }

    void drawText(String txt, x, y) {
      final span = TextSpan(
          text: txt, style: const TextStyle(color: Colors.black, fontSize: 12));
      final textPaintr =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      textPaintr.layout(minWidth: 0, maxWidth: double.maxFinite);

      canvas.save();
      textPaintr.paint(canvas, Offset(x, y));
      canvas.restore();
    }

    double barHeight(double val) {
      return height -
          bottomSpace! * height -
          (bottomSpace.percentLeft()! * height * ((val) / maxVal));
    }

    var paint = Paint()
      ..strokeWidth = barWidth
      ..color = Colors.green
      ..strokeCap = StrokeCap.butt;

    var backgroundPaint = Paint()
      ..color = backgroundColor!
      ..style = PaintingStyle.fill;

    var bottomPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = .1;

    canvas.drawRect(
        Rect.fromPoints(Offset.zero, Offset(width, height)), backgroundPaint);

    for (var i = 0; i < numberOfBar; i++) {
      canvas.drawLine(
          Offset((i * barSpaceWidth) + barMidPoint,
              height * bottomSpace.percentLeft()!),
          Offset((i * barSpaceWidth) + barMidPoint, barHeight(values![i])),
          paint);
    }

    canvas.drawRect(
        Rect.fromPoints(Offset(0, bottomSpace.percentLeft()! * height),
            Offset(mainSpaceRatio! * width, height)),
        bottomPaint);

    for (var element in nav) {
      drawText(element.toString().padLeft(4), width * mainSpaceRatio!,
          barHeight(element.toDouble()) - height * bottomSpace!);
    }
  }

  @override
  bool shouldRepaint(covariant BarChart oldDelegate) => true;
}

extension PercentLeft on double? {
  double? percentLeft() {
    if (this != null) return 1 - (this as double);

    return null;
  }
}

const list = <double>[30.9, 64.4, 37, 78, 09, 34];
