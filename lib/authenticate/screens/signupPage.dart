import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';
import 'package:portstacks1/authenticate/services/hive_services.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "";
  String password = "";
  String confirmation = "";

  String errorMessage = "No Error";

  HiveAuthServices hs = HiveAuthServices();

  bool showError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticateBloc, AuthenticateState>(
        listener: (context, state) {
          if (state is AuthenticateError) {
            setState(() {
              errorMessage = state.errorMessage;
              showError = true;
            });
          }
          if (state is AuthenticateLoggedIn) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/portfoliohome", (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthenticateInitial || state is AuthenticateError) {
            return ListView(
              children: [
                Image.asset("images/forms.png"),
                Form(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),

                      // Enter your email form.
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            // TODO change color to a lighter shade
                            fillColor: Colors.black12,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            hintText: "Enter your Email",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            // TODO change color to a lighter shade
                            fillColor: Colors.black12,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            hintText: "Enter your Password",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            confirmation = value;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            // TODO change color to a lighter shade
                            fillColor: Colors.black12,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            hintText: "Confirm Password",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      showError ? Text(errorMessage) : Text(""),

                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (password == confirmation &&
                              password != "" &&
                              email != "") {
                            setState(() {
                              showError = false;
                            });
                            BlocProvider.of<AuthenticateBloc>(context)
                                .add(AuthenticateUserSignUp(
                              email: email,
                              password: password,
                            ));
                            hs.putlogin(email, password);
                          } else {
                            setState(() {
                              showError = true;
                              errorMessage = "Password does not match";
                            });
                          }
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black54),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 50,
                            ),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Return to homepage"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is AuthenticateLoadingState ||
              state is AuthenticateLoggedIn) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // IF All cases fail, there is some error.
            return Center(
              child: Icon(Icons.error),
            );
          }
        },
      ),
    );
  }
}
