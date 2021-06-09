import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';
import 'package:portstacks1/myportfolio/bloc/myportfolio_bloc.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:yahoofin/yahoofin.dart';
import 'package:yahoofin/src/models/stockQuote.dart';

class AddPosition extends StatefulWidget {
  @override
  _AddPositionState createState() => _AddPositionState();
}

class _AddPositionState extends State<AddPosition> {
  String symbol = "";
  String portfolioName = "";
  String realName = "";
  StockQuote quote = StockQuote();
  num price;
  num quantity;

  bool quoteFetched = false;

  bool portName = false;

  bool symbolExists = false;

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Make Portfolio",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Portfolio Name"),
              onChanged: (value) {
                portfolioName = value;
              },
              onEditingComplete: () async {
                // TODO Open Next
                if (portfolioName.length > 1) {
                  portName = true;
                } else {
                  portName = false;
                }
                setState(() {});
              },
            ),
          ),
          portName
              ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "e.g. AAPL", helperText: "Stock Ticker"),
                    onChanged: (value) {
                      symbol = value.toUpperCase();
                    },
                    onEditingComplete: () async {
                      final yfin = YahooFin();
                      if (symbol != "") {
                        symbolExists = await yfin.checkSymbol(symbol);
                        StockInfo info = yfin.getStockInfo(ticker: symbol);
                        quote = await yfin.getPrice(stockInfo: info);
                        quoteFetched = true;
                      } else {
                        symbolExists = false;
                        quoteFetched = false;
                      }

                      setState(() {});
                    },
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(
                    top: 30,
                  ),
                  child: Text(
                    "Portfolio Name Invalid",
                    textAlign: TextAlign.center,
                  ),
                ),
          symbolExists
              ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: quote.metaData.shortName,
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            helperText: "Company Name",
                          ),
                        ),

                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "e.g. 8",
                            helperText: "Number of Shares",
                          ),
                          onChanged: (value) {
                            quantity = num.tryParse(value);
                          },
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          // keyboardType: TextInputType.number,
                        ),
                        // TODO fetch current price button.
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "e.g. " + quote.currentPrice.toString(),
                            helperText: "Buy Price",
                          ),
                          onChanged: (value) {
                            price = num.tryParse(value);
                          },
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            PortfolioModel portfolio = PortfolioModel(stocks: [
                              symbol,
                            ], data: {
                              symbol: {"price": price, "quant": quantity}
                            }, portfolioName: portfolioName, id: "Any");

                            String userid =
                                BlocProvider.of<AuthenticateBloc>(context)
                                    .state
                                    .userId;
                            BlocProvider.of<MyportfolioBloc>(context)
                                .add(MyportfolioNew(userid, portfolio));
                            Navigator.pop(context);
                          },
                          child: Text("Add Position"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black54)),
                        ),
                      ],
                    ),
                  ),
                )
              : portName
                  ? Container(
                      padding: EdgeInsets.only(
                        top: 30,
                      ),
                      child: Text(
                        "Symbol Does Not Exists",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Text(""),
        ],
      ),
    );
  }
}
