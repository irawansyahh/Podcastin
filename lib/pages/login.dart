import 'package:Podcastin/services/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = '';
  var password = '';
  bool isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  updateLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  showSnackBar(msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('$msg'),
      behavior: SnackBarBehavior.fixed,
    ));
  }

  void onLogin() {
    if (email.isNotEmpty && password.isNotEmpty) {
      updateLoading();
      AuthService()
          .loginWithEmail(email, password)
          .then((value) => Navigator.of(context).pushReplacementNamed('/'))
          .catchError((error) {
        updateLoading();
        showSnackBar(error.message);
      });
    } else {
      showSnackBar('Email & password fields cannot be empty.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Podcastin',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Ideazy Studio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Password', prefixIcon: Icon(Icons.lock)),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            SizedBox(height: 20),
            Container(
              child: isLoading
                  ? Container(
                      child: CircularProgressIndicator(),
                      width: 35,
                    )
                  : RaisedButton(
                      child: Text('Login'),
                      color: Theme.of(context).primaryColor,
                      onPressed: onLogin,
                    ),
              height: 35,
            ),
            SizedBox(height: 60),
            // Text('Don\'t have account yet?'),
            Text(
              'Don\'t have account yet?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            FlatButton(
              child: Text(
                'Register',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              highlightColor: Colors.amber[100],
              splashColor: Colors.amber[50],
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/register');
              },
            )
          ],
        ),
      ),
    );
  }
}
