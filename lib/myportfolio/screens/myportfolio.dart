import 'package:flutter/material.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/router/app_router.dart';

class MyPortfolio extends StatefulWidget {
  final PortfolioModel portfolio;
  MyPortfolio({this.portfolio});

  @override
  _MyPortfolioState createState() => _MyPortfolioState();
}

class _MyPortfolioState extends State<MyPortfolio> {
  bool isPortEmpty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/newposition",
                        arguments:
                            AppRouterArguments(portfolio: widget.portfolio))
                    .then((value) {
                  setState(() {});
                });
                setState(() {
                  isPortEmpty = (!isPortEmpty);
                });
              })
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Portfolio",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          widget.portfolio.stocks.length < 1
              ? (Column(children: [
                  Image.asset(
                    "images/myportdata.png",
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Start filling your portfolio, it seems empty!",
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black54)),
                    onPressed: () {
                      Navigator.pushNamed(context, "/newposition",
                              arguments: AppRouterArguments(
                                  portfolio: widget.portfolio))
                          .then((value) {
                        setState(() {});
                      });
                      setState(() {
                        isPortEmpty = (!isPortEmpty);
                      });
                    },
                    child: Text("Add Position"),
                  ),
                ]))
              : Text(""),
          Container(
            height: MediaQuery.of(context).size.height / 1.4,
            child: ListView.builder(
              itemBuilder: (context, index) {
                // TODO return share card
                return Dismissible(
                  key: Key(widget.portfolio.stocks[index]),
                  child: ListTile(
                    title: Text("${widget.portfolio.stocks[index]} "),
                    subtitle: Text(
                        "Quantity: ${widget.portfolio.data[widget.portfolio.stocks[index]]['quant']} Rate: ${widget.portfolio.data[widget.portfolio.stocks[index]]['price']}"),
                  ),
                  onDismissed: (_) {
                    // TODO remove a stock from portfolio
                    widget.portfolio.stocks.removeAt(index);
                    setState(() {});
                  },
                );
              },
              itemCount: widget.portfolio.stocks.length,
            ),
          )
        ],
      ),
    );
  }
}
