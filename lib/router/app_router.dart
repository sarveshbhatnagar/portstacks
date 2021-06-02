import 'package:flutter/material.dart';
import 'package:portstacks1/authenticate/screens/basePage.dart';
import 'package:portstacks1/authenticate/screens/loginPage.dart';
import 'package:portstacks1/authenticate/screens/signupPage.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/myportfolio/screens/addposition.dart';
import 'package:portstacks1/myportfolio/screens/myportfolio.dart';
import 'package:portstacks1/myportfolio/screens/newposition.dart';
import 'package:portstacks1/myportfolio/screens/portfoliohome.dart';

class AppRouterArguments {
  // Refer
  // https://github.com/sarveshbhatnagar/sarvesh-photo-app/blob/main/lib/screens/router/app_router.dart
  final PortfolioModel portfolio;
  AppRouterArguments({this.portfolio});
}

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BasePage(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => SignUpPage(),
        );
      case '/portfoliohome':
        return MaterialPageRoute(builder: (_) => PortfolioHome());
      case '/myportfolio':
        final AppRouterArguments args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => MyPortfolio(
                  portfolio: args.portfolio,
                ));
      case '/addposition':
        return MaterialPageRoute(builder: (_) => AddPosition());

      case '/newposition':
        final AppRouterArguments args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => NewPosition(
                  portfolio: args.portfolio,
                ));

      default:
        return null;
    }
  }
}
