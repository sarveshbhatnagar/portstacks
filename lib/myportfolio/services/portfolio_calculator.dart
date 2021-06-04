import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:yahoofin/yahoofin.dart';

import '../models/portfoliomodel.dart';
import '../models/portfoliomodel.dart';
import '../models/portfoliomodel.dart';
import '../models/portfoliomodel.dart';

class PortfolioCalculations {
  /// Calculates total value invested in a portfolio
  num calculateTotal(PortfolioModel portfolio) {
    num total = 0;

    portfolio.stocks.forEach((element) {
      total = total +
          (portfolio.data[element]["price"] * portfolio.data[element]["quant"]);
    });

    return total;
  }

  Future<num> calculateCurrentReturns(PortfolioModel portfolio) async {
    num totalCurrent = 0;
    num totalActual = 0;
    final yfin = YahooFin();
    for (var i in portfolio.stocks) {
      final info = yfin.getStockInfo(ticker: i);
      final quote = await yfin.getPrice(stockInfo: info);

      totalCurrent += quote.currentPrice * portfolio.data[i]["quant"];
      totalActual += portfolio.data[i]["price"] * portfolio.data[i]["quant"];
    }
    return totalCurrent - totalActual;
  }

  Future<num> calculateCurrent(PortfolioModel portfolio) async {
    num totalCurrent = 0;
    final yfin = YahooFin();
    for (var i in portfolio.stocks) {
      final info = yfin.getStockInfo(ticker: i);

      final quote = await yfin.getPrice(stockInfo: info);
      totalCurrent += quote.currentPrice * portfolio.data[i]["quant"];
    }
    return totalCurrent;
  }

  Future<List<Map<String, num>>> calculateCurrentModels(
      List<PortfolioModel> portfolios) async {
    List<Map<String, num>> updatedPortfoliosTotal = [];
    try {
      for (var i in portfolios) {
        num tot = await calculateCurrent(i);
        updatedPortfoliosTotal.add({i.portfolioName: tot});
      }
    } catch (e) {
      return [];
    }

    return updatedPortfoliosTotal;
  }
}
