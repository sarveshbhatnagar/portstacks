import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:stats/stats.dart';
import 'package:yahoofin/yahoofin.dart';

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

class PortfolioHelpers {
  List<num> normalizeList(List<num> data) {
    List<num> newData = [];

    for (var i in data) {
      newData.add(i / data[0]);
    }

    return newData;
  }

  List<num> weightList(List<num> weights) {
    num total = 0;
    for (var i in weights) {
      total += i;
    }
    List<num> newWeight = [];

    for (var i in weights) {
      newWeight.add(i / total);
    }

    return newWeight;
  }
}

class PortfolioAnalysis {
  YahooFin yfin = YahooFin();

  Map<String, num> extractValueOfPortfolio(PortfolioModel model) {
    Map<String, num> value;
    for (var i in model.stocks) {
      value[i] = model.data[i]["price"] * model.data[i]["quant"];
    }

    return value;
  }

  Future<num> sharpeRatioOfStock(String stock) async {
    final hist = yfin.initStockHistory(ticker: stock);
    final chart = await yfin.getChartQuotes(stockHistory: hist);
    // TODO change interval or period.
    final st = Stats.fromData(chart.chartQuotes.close);
    final ret = chart.chartQuotes.close[chart.chartQuotes.close.length - 1] /
        chart.chartQuotes.close[0];

    return ret / st.standardDeviation;
  }
}
