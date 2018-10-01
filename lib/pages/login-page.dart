import 'dart:async';
import 'package:flutter/material.dart';

import 'home-page/home-page.dart';
import '../components/snackbar-builder-service.dart';
import '../services/authentication-service.dart';

class LoginPage extends StatefulWidget {
  final String title;
  AuthenticationService _auth;

  LoginPage({Key key, this.title = 'LFMX Login'}) : super(key: key) {
    _auth = new AuthenticationService();
  }

  @override
  _LoginPage createState() => new _LoginPage(this._auth);
}

class _LoginPage extends State<LoginPage> {
  _LoginPage(this._auth) {
  }

  final _formKey = GlobalKey<FormState>();
  AuthenticationService _auth;
  String inputEmail;
  String inputPass;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title, 
          style: new TextStyle(
            color: Colors.grey[850]
          )
        ),
      ),
      body: new Center(
        child: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child:  new Form(
            key: _formKey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'Login To Proceed',
                  style: TextStyle(
                    fontSize: 24.0
                  ),
                ),
                new TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  keyboardAppearance: Brightness.dark,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (val) {
                    this.inputEmail = val;
                    String emailRegex = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExpr = new RegExp(emailRegex);

                    if (val.isEmpty) {
                      return 'Email input cannot be empty';
                    }

                    if (!regExpr.hasMatch(val)) {
                      return 'Invalid email format provided.';
                    }

                  },
                ),
                new TextFormField(
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.dark,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (val) {
                    this.inputPass = val;
                    if (val.isEmpty) {
                      return 'Password must be specified.';
                    }

                    if (val.length < 6) {
                      return 'Password must be at least 6 characters in length.';
                    }
                  },
                ),
              ],
            ),
          )
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            await this._login();
            Navigator.pushReplacement(
              context,     
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }
        },
        foregroundColor: Colors.grey[850],
        tooltip: 'Login',
        child: new Icon(Icons.navigate_next),
      ), 
    );
  }

  Future<bool> _login() async {
    this._formKey.currentState;
    var result = await this._auth.login(this.inputEmail, this.inputPass);
    print(result);

    return result != null;
  }
}

