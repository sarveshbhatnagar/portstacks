import 'package:flutter/material.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/myportfolio/services/portfolio_calculator.dart';

class SummaryWidget extends StatefulWidget {
  final String name;
  final PortfolioModel portfolio;
  const SummaryWidget({@required this.name, @required this.portfolio});

  @override
  _SummaryWidgetState createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  PortfolioCalculations calculations = PortfolioCalculations();
  num totalCurrent = 0;
  num sharpeRatio = 0;

  @override
  void initState() {
    // calculations.calculateCurrentReturns(widget.portfolio).then((value) {
    //   setState(() {
    //     totalCurrent = value;
    //   });
    // });
    // widget.portfolio.sharpeRatioAverage().then((value) {
    //   setState(() {
    //     sharpeRatio = value;
    //     print(value);
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          child: Container(
            child: Card(
              elevation: 2,
              // height: MediaQuery.of(context).size.height / 10,
              // height: double.infinity,
              // color: Colors.redAccent[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text(
                        "Portfolio Name",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: MediaQuery.of(context).size.width / 13,
                      children: [
                        Text(
                          "Invested : 1029.21",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Returns : 50.2",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
