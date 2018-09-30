import 'package:flutter/material.dart';
import 'home-page/home-page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPage createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

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
        child: new Form(
          key: _formKey,
          child: new Column(        
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Enter Credentials',
              ),
              new TextFormField(
                validator: (val) {
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
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Password must be specified.';
                  }

                  if (val.length < 6) {
                    return 'Password must be at least 6 characters in length.';
                  }
                },
              ),

              new RaisedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, we want to show a Snackbar
                    // Scaffold.of(context)
                        // .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,     
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        foregroundColor: Colors.grey[850],
        tooltip: 'Start New Timer',
        child: new Icon(Icons.navigate_next),
      ), 
    );
  }
}

