import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';
import 'package:portstacks1/authenticate/services/hive_services.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  void initState() {
    // TODO: implement initState
    HiveAuthServices hs = HiveAuthServices();

    String email = hs.getEmail();
    String password = hs.getPassword();

    if (email != null && password != null) {
      BlocProvider.of<AuthenticateBloc>(context)
          .add(AuthenticateUserLogin(email: email, password: password));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // TOP IMAGE
          Image.asset("images/savings.png"),
          SizedBox(
            height: 25,
          ),

          // HEADLINE TEXT
          Text(
            "Welcome to PortStacks.",
            style: TextStyle(fontSize: 35),
          ),
          SizedBox(
            height: 35,
          ),

          // NEW USER SIGNUP BUTTON
          Container(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text(
                "New User? SignUp",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black54),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 25,
            ),
          ),

          // SizedBox
          SizedBox(
            height: 20,
          ),

          // Login Button
          Container(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                "Returning User? Login",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black26),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 25,
            ),
          ),
        ],
      ),
    );
  }
}
