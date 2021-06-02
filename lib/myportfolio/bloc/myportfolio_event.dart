part of 'myportfolio_bloc.dart';

abstract class MyportfolioEvent extends Equatable {
  final String userid;
  const MyportfolioEvent({this.userid});

  @override
  List<Object> get props => [];
}

class MyportfolioNew extends MyportfolioEvent {
  final PortfolioModel portfolio;
  MyportfolioNew(String userid, this.portfolio) : super(userid: userid);
}

class MyportfolioFetchAll extends MyportfolioEvent {
  MyportfolioFetchAll(String userid) : super(userid: userid);
}

class MyportfolioFetchOne extends MyportfolioEvent {
  MyportfolioFetchOne(String userid) : super(userid: userid);
}

class MyportfolioUpdate extends MyportfolioEvent {
  final PortfolioModel portfolio;
  MyportfolioUpdate(String userid, this.portfolio) : super(userid: userid);
}

class MyportfolioDelete extends MyportfolioEvent {
  final String portfolioId;
  final List<PortfolioModel> portfolios;
  MyportfolioDelete(String userid, this.portfolioId, this.portfolios)
      : super(userid: userid);
}
