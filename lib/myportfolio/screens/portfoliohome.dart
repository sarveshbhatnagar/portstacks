import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';
import 'package:portstacks1/myportfolio/bloc/myportfolio_bloc.dart';
import 'package:portstacks1/myportfolio/widget/piechartsample.dart';
import 'package:portstacks1/myportfolio/widget/portfoliosummary.dart';

class PortfolioHome extends StatefulWidget {
  @override
  _PortfolioHomeState createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  @override
  void initState() {
    super.initState();
    _loadPortfolios();
  }

  _loadPortfolios() async {
    String userid = BlocProvider.of<AuthenticateBloc>(context).state.userId;
    // TODO use userid

    BlocProvider.of<MyportfolioBloc>(context)
        .add(MyportfolioFetchAll("myuser"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/addposition');
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              BlocProvider.of<AuthenticateBloc>(context)
                  .add(AuthenticateUserLogout());

              Navigator.popAndPushNamed(context, "/");
            },
          ),
        ),
        body: BlocBuilder<MyportfolioBloc, MyportfolioState>(
          builder: (context, state) {
            if (state is MyportfolioLoaded) {
              return ListView(
                physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                children: [
                  PieChartPortfolio(
                    portfolios: state.portfolios,
                  ),
                  Text(
                    "Combined Portfolio Value",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 2.8,
                      child: ListView.builder(
                          itemCount: state.portfolios.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              background: Container(color: Colors.red),
                              direction: DismissDirection.endToStart,
                              key: Key(state.portfolios[index].id),
                              onDismissed: (direction) {
                                BlocProvider.of<MyportfolioBloc>(context).add(
                                    MyportfolioDelete(
                                        "myuser",
                                        state.portfolios[index].id,
                                        state.portfolios));
                                state.portfolios.removeAt(index);
                                // FOR some reason this is working.

                                setState(() {});
                              },
                              child: PortfolioSummary(
                                name: state.portfolios[index].portfolioName,
                                portfolio: state.portfolios[index],
                              ),
                            );
                          })),
                ],
              );
            } else if (state is MyportfolioLoading ||
                state is MyportfolioUploading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MyportfolioInitial) {
              return Center(
                child: Text("No Portfolios Yet"),
              );
            } else if (state is MyportfolioEmpty) {
              // TODO Empty portfolio
              return Center(
                child: Text("No Portfolios Yet"),
              );
            } else if (state is MyportfolioError) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is MyportfolioUploaded) {
              BlocProvider.of<MyportfolioBloc>(context)
                  .add(MyportfolioFetchAll("myuser"));
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print(state);
              return Center(
                child: Text(
                    "Some uncaught error occured, please contact developer@revoltronx.com"),
              );
            }
          },
        ));
  }
}
