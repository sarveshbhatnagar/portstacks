import 'package:flutter/material.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/myportfolio/services/portfolio_calculator.dart';
import 'package:portstacks1/router/app_router.dart';

class PortfolioSummary extends StatefulWidget {
  final String name;
  final PortfolioModel portfolio;

  PortfolioSummary({@required this.name, this.portfolio});

  @override
  _PortfolioSummaryState createState() => _PortfolioSummaryState();
}

class _PortfolioSummaryState extends State<PortfolioSummary> {
  PortfolioCalculations calculations = PortfolioCalculations();
  num totalCurrent = 0;
  @override
  void initState() {
    totals().then((value) {
      totalCurrent = value;
      setState(() {});
    });

    super.initState();
  }

  Future<num> totals() async {
    return await calculations.calculateCurrentReturns(widget.portfolio);
  }

  @override
  Widget build(BuildContext context) {
    // calculateTotal();
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 3),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/myportfolio",
                    arguments: AppRouterArguments(portfolio: widget.portfolio))
                .then((value) {
              setState(() {
                totals().then((value) => totalCurrent = value);
              });
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        widget.portfolio.portfolioName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Total Cost: ${calculations.calculateTotal(widget.portfolio).toStringAsFixed(2)}"),
                    Text("Returns: ${totalCurrent.toStringAsFixed(1)}"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
