import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/myportfolio/services/portfolio_calculator.dart';
import 'indicator.dart';

class PieChartPortfolio extends StatefulWidget {
  final List<PortfolioModel> portfolios;
  PieChartPortfolio({this.portfolios});

  @override
  _PieChartPortfolioState createState() => _PieChartPortfolioState();
}

class _PieChartPortfolioState extends State<PieChartPortfolio> {
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return widget.portfolios.length > 0
        ? AspectRatio(
            aspectRatio: 1.3,
            child: Card(
              color: Colors.white,
              elevation: 0,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData:
                              PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              final desiredTouch = pieTouchResponse.touchInput
                                      is! PointerExitEvent &&
                                  pieTouchResponse.touchInput
                                      is! PointerUpEvent;
                              if (desiredTouch &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse
                                    .touchedSection.touchedSectionIndex;
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(widget.portfolios),
                        ),
                      ),
                    ),
                  ),
                  // Column(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: getIndicators(),
                  // ),
                ],
              ),
            ),
          )
        : Image.asset(
            "images/savings.png",
            height: MediaQuery.of(context).size.height / 2.5,
          );
  }

  List<Widget> getIndicators() {
    return [
      Indicator(
        color: Color(0xff0293ee),
        text: 'Investment',
        isSquare: true,
      ),
      SizedBox(
        height: 4,
      ),
      Indicator(
        color: Colors.green,
        text: 'Profit',
        isSquare: true,
      ),
      SizedBox(
        height: 4,
      ),
      Indicator(
        color: Colors.red,
        text: 'Loss',
        isSquare: true,
      ),
      SizedBox(
        height: 4,
      ),
      // Ending sized box
      SizedBox(
        height: 14,
      ),
    ];
  }

  List<PieChartSectionData> showingSections(List<PortfolioModel> portfolios) {
    PortfolioCalculations calculations = PortfolioCalculations();

    return List.generate(portfolios.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 10;
      final double radius = isTouched ? 70 : 60;
      List colors = [Colors.redAccent, Colors.greenAccent, Colors.blueAccent];
      return PieChartSectionData(
        color: colors[i % 3],
        value: calculations.calculateTotal(portfolios[i]).toDouble(),
        title: portfolios[i].portfolioName,
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }
}
