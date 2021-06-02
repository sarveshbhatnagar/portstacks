import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/myportfolio/services/myportfolio_service.dart';
import 'package:portstacks1/myportfolio/services/portfolio_calculator.dart';

calculateTotal(PortfolioModel portfolio) {
  int total = 0;
  print(portfolio.stocks);
  print(portfolio.data);
  portfolio.stocks.forEach((element) {
    print(element);

    total = total +
        (portfolio.data[element]["price"] * portfolio.data[element]["quant"]);
  });

  return total;
}

void main() async {
  final portfolio = MyPortfolioService();
  final calculations = PortfolioCalculations();
  PortfolioModel mod =
      await portfolio.getPortfolio("myuser", "7hBx5Qb8HNNC1npBZBnB");

  num t = await calculations.calculateCurrent(mod);

  bool pdeleted =
      await portfolio.deletePortfolio("myuser", "o4F8VziJxP84ySyN6qcF");
  print(pdeleted);

  // bool success = await portfolio.addPortfolio("saruuu", mod);
  // print(success);
}
