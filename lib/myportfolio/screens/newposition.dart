import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';
import 'package:portstacks1/myportfolio/bloc/myportfolio_bloc.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:yahoofin/yahoofin.dart';
import 'package:yahoofin/src/models/stockQuote.dart';

class NewPosition extends StatefulWidget {
  final PortfolioModel portfolio;
  NewPosition({this.portfolio});

  @override
  _NewPositionState createState() => _NewPositionState();
}

class _NewPositionState extends State<NewPosition> {
  String symbol = "";
  String portfolioName = "";

  StockQuote quote = StockQuote();

  num price;
  num quantity;

  bool alreadyExists = false;

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
          "Add a Stock",
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
              decoration: InputDecoration(
                  hintText: "e.g. AAPL", helperText: "Stock Ticker"),
              onChanged: (value) {
                symbol = value.toUpperCase();
              },
              onEditingComplete: () async {
                final yfin = YahooFin();
                if (symbol != "") {
                  symbolExists = await yfin.checkSymbol(symbol);
                  // TODO if symbol in portfolio.
                  if (widget.portfolio.stocks.contains(symbol)) {
                    alreadyExists = true;
                  } else {
                    alreadyExists = false;
                  }
                  StockInfo info = yfin.getStockInfo(ticker: symbol);
                  quote = await yfin.getPrice(stockInfo: info);
                } else {
                  symbolExists = false;
                }

                setState(() {});
              },
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
                              hintText: "e.g. 10",
                              helperText: "Number of Shares"),
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

                        // TODO date picker
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (alreadyExists) {
                              final p1 = widget.portfolio.data[symbol]["price"];
                              final q1 = widget.portfolio.data[symbol]["quant"];
                              final avgPrice =
                                  ((p1 * q1) + (price * quantity)) /
                                      (q1 + quantity);
                              widget.portfolio.data[symbol] = {
                                "price": avgPrice,
                                "quant": q1 + quantity
                              };
                            } else {
                              widget.portfolio.stocks.add(symbol);

                              widget.portfolio.data[symbol] = {
                                "price": price,
                                "quant": quantity
                              };
                            }

                            String userid =
                                BlocProvider.of<AuthenticateBloc>(context)
                                    .state
                                    .userId;
                            BlocProvider.of<MyportfolioBloc>(context).add(
                                MyportfolioUpdate(userid, widget.portfolio));
                            Navigator.pop(context);
                          },
                          child: Text("Add Position"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black54)),
                        )
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
