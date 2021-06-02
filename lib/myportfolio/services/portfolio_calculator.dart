import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:yahoofin/yahoofin.dart';

class PortfolioCalculations {
  /// Calculates total value invested in a portfolio
  num calculateTotal(PortfolioModel portfolio) {
    num total = 0;
    print(portfolio.stocks);
    print(portfolio.data);
    portfolio.stocks.forEach((element) {
      print(element);

      total = total +
          (portfolio.data[element]["price"] * portfolio.data[element]["quant"]);
    });

    return total;
  }

  Future<num> calculateCurrent(PortfolioModel portfolio) async {
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
}
