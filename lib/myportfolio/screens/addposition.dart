import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';
import 'package:portstacks1/myportfolio/bloc/myportfolio_bloc.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:yahoofin/yahoofin.dart';

class AddPosition extends StatefulWidget {
  @override
  _AddPositionState createState() => _AddPositionState();
}

class _AddPositionState extends State<AddPosition> {
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
                    decoration: InputDecoration(hintText: "Symbol"),
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
                          decoration: InputDecoration(
                            hintText: "Number of Shares",
                          ),
                          onChanged: (value) {
                            quantity = num.tryParse(value);
                          },
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
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
