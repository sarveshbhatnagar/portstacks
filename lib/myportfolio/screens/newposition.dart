import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';
import 'package:portstacks1/myportfolio/bloc/myportfolio_bloc.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:yahoofin/yahoofin.dart';

class NewPosition extends StatefulWidget {
  final PortfolioModel portfolio;
  NewPosition({this.portfolio});

  @override
  _NewPositionState createState() => _NewPositionState();
}

class _NewPositionState extends State<NewPosition> {
  String symbol = "";
  String portfolioName = "";

  num price;
  num quantity;

  bool portName = false;

  bool symbolExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              decoration: InputDecoration(hintText: "Stock Ticker e.g. AAPL"),
              onChanged: (value) {
                symbol = value;
              },
              onEditingComplete: () async {
                final yfin = YahooFin();
                if (symbol != "") {
                  symbolExists = await yfin.checkSymbol(symbol);
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
                          decoration: InputDecoration(
                            hintText: "Number of Shares",
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
                            hintText: "Buy Price",
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
                            widget.portfolio.stocks.add(symbol);

                            widget.portfolio.data[symbol] = {
                              "price": price,
                              "quant": quantity
                            };

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
