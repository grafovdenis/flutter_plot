import 'package:flutter/material.dart';
import 'package:flutter_plot/windgets/painter.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var plotData = {
      DateTime(2019, 3, 29): 300000,
      DateTime(2019, 4, 29): 300380,
      DateTime(2019, 5, 29): 300831,
      DateTime(2019, 6, 29): 301330,
      DateTime(2019, 7, 29): 301501,
      DateTime(2019, 8, 29): 301614,
      DateTime(2019, 9, 29): 301614,
      DateTime(2019, 10, 29): 301698
    };

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 200,
          width: 1.5 * MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: PlotPainter(plotData),
            child: Container(
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}
