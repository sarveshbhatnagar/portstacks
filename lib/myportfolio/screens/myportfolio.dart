import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';
import 'package:portstacks1/myportfolio/bloc/myportfolio_bloc.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/myportfolio/services/portfolio_calculator.dart';
import 'package:portstacks1/router/app_router.dart';

// TODO update on tap, add positions etc.
class MyPortfolio extends StatefulWidget {
  final PortfolioModel portfolio;
  MyPortfolio({this.portfolio});

  @override
  _MyPortfolioState createState() => _MyPortfolioState();
}

class _MyPortfolioState extends State<MyPortfolio> {
  Map<String, num> sharpRatio = {};

  @override
  initState() {
    super.initState();

    portSharpeRatio().then((value) {
      setState(() {
        sharpRatio = value;
      });
    });
  }

  Future<Map<String, num>> portSharpeRatio() async {
    Map<String, num> sharpeRatio = {};
    final pa = PortfolioAnalysis();
    for (var i in widget.portfolio.stocks) {
      sharpeRatio[i] = await pa.sharpeRatioOfStock(i);
    }
    return sharpeRatio;
  }

  bool isPortEmpty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 1,
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
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
                return Dismissible(
                  key: Key(widget.portfolio.stocks[index]),
                  child: ListTile(
                    title: Text("${widget.portfolio.stocks[index]} "),
                    subtitle: Text(
                        "Quantity: ${widget.portfolio.data[widget.portfolio.stocks[index]]['quant']} Rate: ${(widget.portfolio.data[widget.portfolio.stocks[index]]['price']).toStringAsFixed(2)}"),
                    trailing: sharpRatio.length > 0
                        ? Text(
                            "Sharpe Ratio : ${sharpRatio[widget.portfolio.stocks[index]].toStringAsFixed(2)}")
                        : Text(""),
                  ),
                  onDismissed: (_) {
                    String stock = widget.portfolio.stocks[index];
                    widget.portfolio.data.remove(stock);
                    widget.portfolio.stocks.removeAt(index);
                    String userid =
                        BlocProvider.of<AuthenticateBloc>(context).state.userId;

                    BlocProvider.of<MyportfolioBloc>(context)
                        .add(MyportfolioUpdate(userid, widget.portfolio));
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
