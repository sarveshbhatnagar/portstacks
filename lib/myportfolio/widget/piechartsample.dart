import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/myportfolio/services/portfolio_calculator.dart';
import '../services/portfolio_calculator.dart';
import 'indicator.dart';

// TODO pie chart based on returns.
// TODO update after deleting a portfolio.
// TODO showing orignal investment/current portfolio.
class PieChartPortfolio extends StatefulWidget {
  final List<PortfolioModel> portfolios;
  PieChartPortfolio({this.portfolios});

  @override
  _PieChartPortfolioState createState() => _PieChartPortfolioState();
}

class _PieChartPortfolioState extends State<PieChartPortfolio> {
  int touchedIndex;

  List<Map<String, num>> portfolioCurrent;

  bool isInitialized = false;

  @override
  void initState() {
    // TODO: implement initState
    final calculations = PortfolioCalculations();
    calculations.calculateCurrentModels(widget.portfolios).then((value) {
      portfolioCurrent = value;

      if (mounted) {
        setState(() {
          isInitialized = true;
        });
      }
    });
    super.initState();
  }

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
                            if (mounted) {
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
                            }
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: isInitialized
                              ? showingSectionsCurrent(portfolioCurrent)
                              : showingSections(widget.portfolios),
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

  List<PieChartSectionData> showingSectionsCurrent(
      List<Map<String, num>> portfolios) {
    return List.generate(portfolios.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 10;
      final double radius = isTouched ? 70 : 60;
      List colors = [
        Colors.redAccent,
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.greenAccent,
      ];

      // TODO make key different as same keys will collide.
      return PieChartSectionData(
        color: colors[i % 4],
        value: portfolios[i][portfolios[i].keys.first],
        title: portfolios[i].keys.first,
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }

  List<PieChartSectionData> showingSections(List<PortfolioModel> portfolios) {
    PortfolioCalculations calculations = PortfolioCalculations();

    return List.generate(portfolios.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 10;
      final double radius = isTouched ? 70 : 60;
      List colors = [
        Colors.redAccent,
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.amberAccent,
        Colors.cyanAccent,
        Colors.deepOrangeAccent
      ];
      return PieChartSectionData(
        color: colors[i % 6],
        value: calculations.calculateTotal(portfolios[i]).toDouble(),
        title: portfolios[i].portfolioName,
        radius: radius,
        showTitle: true,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }
}
