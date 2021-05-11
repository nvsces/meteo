import 'package:flutter/material.dart';
import 'package:meteo/models/user.dart';
import 'package:meteo/services/auth.dart';
import 'package:meteo/widgets/help_widgets.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController _loginC = TextEditingController();
  TextEditingController _passwordC = TextEditingController();
  bool showLogin = true;
  String labelText = "Зарегистрироваться";

  void _registrActions() async {
    final String email = _loginC.text.trim();
    final String password = _passwordC.text.trim();
    User user =
        await AuthService().registrWithEmailAndPassword(email, password);
  }

  void _loginActions() async {
    final String email = _loginC.text.trim();
    final String password = _passwordC.text.trim();
    User user = await AuthService().signInWithEmailAndPassword(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Get Meteo',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
                controller: _loginC,
                textAlign: TextAlign.center,
                decoration: inputDecorationBuild(labelText: 'Логин')),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              controller: _passwordC,
              decoration: inputDecorationBuild(labelText: 'Пароль'),
            ),
          ),
          showLogin
              ? RaisedButton(child: Text('Вход'), onPressed: _loginActions)
              : RaisedButton(
                  child: Text('Регистрация'), onPressed: _registrActions),
          GestureDetector(
              onTap: () {
                setState(() {
                  showLogin = !showLogin;
                });
              },
              child: Text(showLogin ? "Зарегистрироваться" : "Войти"))
        ],
      ),
    );
  }
}
