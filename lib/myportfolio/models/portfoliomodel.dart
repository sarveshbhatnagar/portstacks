import 'package:equatable/equatable.dart';
import 'package:portstacks1/myportfolio/services/portfolio_calculator.dart';

// TODO weighted portfolio sharpe ratio.

class PortfolioModel extends Equatable {
  final List<dynamic> stocks;
  final Map<String, dynamic> data;
  final String id;
  final String portfolioName;

  PortfolioModel({this.stocks, this.data, this.id, this.portfolioName});

  Future<Map<String, num>> portSharpeRatio() async {
    Map<String, num> sharpeRatio = {};
    final pa = PortfolioAnalysis();
    for (var i in stocks) {
      sharpeRatio[i] = await pa.sharpeRatioOfStock(i);
    }
    return sharpeRatio;
  }

  Future<num> sharpeRatioAverage() async {
    final sharpeRatio = await portSharpeRatio();
    final portValue = getPortfolioValue();
    num total = 0;
    for (var i in stocks) {
      total += portValue[i];
    }
    Map<String, num> weights = {};
    for (var i in stocks) {
      weights[i] = (portValue[i] / total);
    }
    num portfolioSharpeRatio = 0;
    for (var i in stocks) {
      portfolioSharpeRatio += (weights[i] * sharpeRatio[i]);
    }

    return portfolioSharpeRatio;
  }

  /// Returns map for total buy price of stocks.
  Map<String, num> getPortfolioValue() {
    Map<String, num> value = {};
    for (var i in stocks) {
      value[i] = data[i]["price"] * data[i]["quant"];
    }

    return value;
  }

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
