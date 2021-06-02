import 'package:equatable/equatable.dart';

class PortfolioModel extends Equatable {
  final List<dynamic> stocks;
  final Map<String, dynamic> data;
  final String id;
  final String portfolioName;

  PortfolioModel({this.stocks, this.data, this.id, this.portfolioName});

  factory PortfolioModel.fromJson(Map<String, dynamic> json) => PortfolioModel(
      stocks: json["stocks"],
      id: json["id"],
      portfolioName: json["portfolio_name"],
      data: json["data"]);

  Map<String, dynamic> toJson() => {
        "stocks": stocks,
        "portfolio_name": portfolioName,
        "data": data,
      };

  @override
  List<Object> get props => [id, stocks.length];
}
