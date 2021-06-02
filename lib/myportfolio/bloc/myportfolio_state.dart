part of 'myportfolio_bloc.dart';

abstract class MyportfolioState extends Equatable {
  const MyportfolioState();

  @override
  List<Object> get props => [];
}

class MyportfolioInitial extends MyportfolioState {}

class MyportfolioLoading extends MyportfolioState {}

class MyportfolioLoaded extends MyportfolioState {
  final List<PortfolioModel> portfolios;
  MyportfolioLoaded({this.portfolios});
}

class MyportfolioEmpty extends MyportfolioState {}

class MyportfolioError extends MyportfolioState {
  final String message;
  MyportfolioError({this.message});
}

class MyportfolioUploading extends MyportfolioState {
  final PortfolioModel portfolio;
  final String userid;
  MyportfolioUploading({this.portfolio, this.userid});
}

class MyportfolioUploaded extends MyportfolioState {}
