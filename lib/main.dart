import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';
import 'package:portstacks1/authenticate/screens/basePage.dart';
import 'package:portstacks1/myportfolio/bloc/myportfolio_bloc.dart';
import 'package:portstacks1/myportfolio/models/portfoliomodel.dart';
import 'package:portstacks1/myportfolio/screens/portfoliohome.dart';
import 'package:portstacks1/myportfolio/widget/summarywidget.dart';
import 'package:portstacks1/router/app_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox("authbox");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  final AuthenticateBloc _authenticateBloc = AuthenticateBloc();
  final MyportfolioBloc _myportfolioBloc = MyportfolioBloc();

  @override
  void dispose() {
    // TODO: dispose used blocks
    super.dispose();
    _authenticateBloc.close();
    _myportfolioBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authenticateBloc),
        BlocProvider.value(value: _myportfolioBloc),
      ],
      child: MaterialApp(
        home: SafeArea(
          child: BlocBuilder<AuthenticateBloc, AuthenticateState>(
            builder: (context, state) {
              if (state is AuthenticateLoggedIn) {
                return PortfolioHome();
              }
              // TODO return basepage
              return BasePage();
              // return Scaffold(
              //   body: Center(
              //     child: SummaryWidget(
              //         name: "Portfolio Name", portfolio: PortfolioModel()),
              //   ),
              // );
            },
          ),
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
