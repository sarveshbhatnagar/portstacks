import 'package:http/http.dart' as http;
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'dart:convert';

class MyPortfolioService {
  var client = http.Client();

  String apiUrl = 'us-central1-portstacks.cloudfunctions.net';

  String getPortfoliosUrl = '/app/api/portfolio/v1/readportfolios';

  String getPortfolioUrl = '/app/api/portfolio/v1/readportfolio';

  String addPortfolioUrl = '/app/api/portfolio/v1/addportfolio';

  String deletePortfolioUrl = '/app/api/portfolio/v1/deleteportfolio';

  Future<List<PortfolioModel>> getPortfolios(String userid) async {
    final response =
        await client.get(Uri.https(apiUrl, getPortfoliosUrl + "/$userid"));

    List<dynamic> lis = jsonDecode(response.body);

    List<PortfolioModel> portfolios = [];
    lis.forEach((element) {
      portfolios.add(PortfolioModel.fromJson(element));
    });

    return portfolios;
  }

  Future<PortfolioModel> getPortfolio(String userid, String portfolioId) async {
    final response = await client
        .get(Uri.https(apiUrl, getPortfolioUrl + "/$userid/$portfolioId"));

    return PortfolioModel.fromJson(jsonDecode(response.body));
  }

  Future<bool> addPortfolio(String userid, PortfolioModel portfolio) async {
    Map<String, dynamic> params = portfolio.toJson();

    final response = await http.post(
      Uri.parse(
          "https://us-central1-portstacks.cloudfunctions.net/app/api/portfolio/v1/addportfolio/$userid"),
      body: jsonEncode(params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePortfolio(String userid, String portfolioId) async {
    final response = await http.delete(Uri.parse(
        "https://us-central1-portstacks.cloudfunctions.net/app/api/portfolio/v1/deleteportfolio/$userid/$portfolioId"));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updatePortfolio(String userid, PortfolioModel portfolio) async {
    Map<String, dynamic> params = portfolio.toJson();
    final response = await http.post(
      Uri.parse(
          "https://us-central1-portstacks.cloudfunctions.net/app/api/portfolio/v1/updateportfolio/$userid/${portfolio.id}"),
      body: jsonEncode(params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
