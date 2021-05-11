import 'package:flutter/material.dart';
import 'package:meteo/main.dart';
import 'package:meteo/models/user.dart';
import 'package:meteo/pages/auth_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.watch<User>();
    final bool isLoggedIn = user != null;
    return isLoggedIn ? MyHomePage() : AuthorizationPage();
  }
}
