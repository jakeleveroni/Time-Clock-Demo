import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'account-page-state.dart';
import '../../services/firebase-database.dart';

class AccountPage extends StatefulWidget {
  AccountPageState _state;

  AccountPage() {
    this._state = AccountPageState();
  }

  @override
  State<StatefulWidget> createState() => _AccountPageState();
  
}

class _AccountPageState extends State<AccountPage> {
  FirebaseDatabaseService _db;
  final GlobalKey _formKey = GlobalKey<FormState>();
  _AccountPageState() {
    this._db = FirebaseDatabaseService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Timer'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                await this._db.updateUser(widget._state.user);
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User Information Updated'),
                    duration: Duration(milliseconds: 2000),
                  )
                );
              }
            );
          }
        )],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            this._buildUserImage(),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    leading: const Icon(Icons.people),
                    title: new TextFormField(
                      decoration: new InputDecoration(hintText: "Username"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a user name';
                        } else {
                          widget._state.userName = value;
                        }
                      }
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.email),
                    title: new TextFormField(
                      decoration: new InputDecoration(hintText: "Email"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an email';
                        } else {
                          widget._state.email = value;
                        }
                      }
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.email),
                    title: new TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: new InputDecoration(hintText: "Phone Number"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an email';
                        } else {
                          widget._state.phoneNumber = value;
                        }
                      }
                    ),
                  ),
                ],  
              )
            ),
          ],
        )
    );
  }

  Widget _buildUserImage() {
    var user = this.widget._state.user;

    if (user.profileImageUrl == null || user.profileImageUrl.isEmpty) {
      return Container(
        height: 200.0,
        width: 200.0,
        decoration: BoxDecoration(
          color: Colors.pinkAccent,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(0.0),
        child: Center(
          child: Text(
          '${user.email[0].toUpperCase()}${user.email[user.email.length -1].toUpperCase()}',
          style: TextStyle(
            fontSize: 100.0,
            fontWeight: FontWeight.bold
          )),
        )
      );
    } else {
      return Container(
        height: 200.0,
        width: 200.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: 'https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg?raw=true',
            width: 200.0,
            height: 200.0,
            fit: BoxFit.fill,
          )
        ) 
      );
    }
  }
}