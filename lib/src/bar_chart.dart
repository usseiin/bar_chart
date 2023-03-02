import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BarChart extends CustomPainter {
  Color? backgroundColor;
  double? mainSpaceRatio;
  List<double>? values;
  double? bottomSpace;
  double? barSpaceRatio;

  BarChart({
    this.backgroundColor = Colors.transparent,
    this.mainSpaceRatio = .9,
    this.values = list,
    this.bottomSpace = .05,
    this.barSpaceRatio = .75,
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
    var maxValue = values!.reduce(max);
    double interval_ = maxValue / interval;

    final textStyle = ui.TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    final paragraphStyle = ui.ParagraphStyle(
      textAlign: TextAlign.left,
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle);

    double barHeight(double val) {
      return height -
          bottomSpace! * height -
          (bottomSpace.percentLeft()! * height * ((val) / maxValue));
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

    for (var i = 0; i <= interval; i++) {
      final val = i * interval_;
      print(val);
      paragraphBuilder.addText((val).round().toString().padLeft(4));
      final paragraph = paragraphBuilder.build()
        ..layout(ui.ParagraphConstraints(width: width));
      canvas.drawParagraph(
          paragraph, Offset(width * mainSpaceRatio!, barHeight(val) - 8));
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
