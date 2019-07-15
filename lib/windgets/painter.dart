import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class PlotPainter extends CustomPainter {
  final double fontSize = 10;
  final Map<int, String> months = {
    1: "ЯНВАРЬ",
    2: "ФЕВРАЛЬ",
    3: "МАРТ",
    4: "АПРЕЛЬ",
    5: "МАЙ",
    6: "ИЮНЬ",
    7: "ИЮЛЬ",
    8: "АВГУСТ",
    9: "СЕНТЯБРЬ",
    10: "ОКТЯБРЬ",
    11: "НОЯБРЬ",
    12: "ДЕКАБРЬ"
  };
  final Map<DateTime, int> plotData;

  final currentMonth = DateTime.now().month;

  PlotPainter(this.plotData);


  String _formatPrice(String price) {
    final List<String> tmp = price.split('').reversed.toList();
    var resList = List<String>();
    for (int i = 0; i < price.length; i++) {
      resList.add(tmp[i]);
      if ((i + 2) % 3 == 0) {
        resList.add(" ");
      }
    }
    return resList.reversed.join();
  }

  List<double> _normalize(List<int> values) {
    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);

    final List<double> result = List();
    for (int i = 0; i < values.length; i++) {
      result.add((values[i] - minValue) / (maxValue - minValue));
    }
    return result;
  }

  void _drawText(
      String text, Canvas canvas, Size size, Offset offset, bool isPrice) {
    final textStyle =
        TextStyle(color: Color.fromRGBO(102, 102, 102, 1), fontSize: fontSize);
    final textSpan = TextSpan(
      text: !isPrice ? text : _formatPrice(text),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(
        canvas, Offset(offset.dx - textPainter.width / 2, offset.dy));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final descriptions = plotData.keys.toList();
    final prices = plotData.values.toList();
    final itemCount = plotData.length;
    final normalizedHeight = size.height * 0.8;

    final linePaint = Paint();
    linePaint.color = Color.fromRGBO(190, 190, 190, 1);
    linePaint.strokeWidth = 2;
    linePaint.style = PaintingStyle.stroke;

    final fillPaint = Paint();
    fillPaint.color = Color.fromRGBO(242, 242, 242, 1);
    fillPaint.strokeWidth = 1;
    fillPaint.style = PaintingStyle.fill;

    final List<Offset> xAxis = List();
    final List<double> normalized = _normalize(prices);
    final List<Offset> lineCoordinates = List();

    double dx = size.width / (itemCount + 1);
    double dy = size.height * 0.15;

    for (int i = 0; i < itemCount; i++) {
      lineCoordinates.add(
          Offset(dx * (i + 1), normalizedHeight * (1 - normalized[i]) + dy));
      xAxis.add(Offset(dx * (i + 1), normalizedHeight + dy));
    }

    final path = Path();
    path.moveTo(dx, normalizedHeight + dy);
    final filler = Path();
    filler.moveTo(dx, normalizedHeight + dy);

    for (int i = 0; i < itemCount; i++) {
      ///x axis
      final x = xAxis[i];
      final description = months[descriptions[i].month];
      _drawText(description, canvas, size, x, false);

      ///top line
      path.lineTo(lineCoordinates[i].dx, lineCoordinates[i].dy);
      filler.lineTo(lineCoordinates[i].dx, lineCoordinates[i].dy);

      ///description lines
      canvas.drawLine(Offset(lineCoordinates[i].dx, lineCoordinates[i].dy - dy),
          lineCoordinates[i], fillPaint);
    }
    canvas.drawPath(path, linePaint);

    filler.lineTo(dx * itemCount, normalizedHeight + dy);
    canvas.drawPath(filler, fillPaint);

    for (int i = 0; i < itemCount; i++) {
      ///description text
      _drawText("${prices[i]} ₽", canvas, size,
          Offset(lineCoordinates[i].dx, lineCoordinates[i].dy - dy), true);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}