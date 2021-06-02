import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
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
