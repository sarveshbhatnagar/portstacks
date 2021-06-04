import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portstacks1/authenticate/bloc/authenticate_bloc.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget();

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 1,
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<AuthenticateBloc>(context)
                  .add(AuthenticateUserLogout());

              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
            child: Text(
              "Logout",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
