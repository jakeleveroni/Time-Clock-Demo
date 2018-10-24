import 'dart:async';
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
  final _formKey = GlobalKey<FormState>();
  _AccountPageState() {
    this._db = FirebaseDatabaseService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('My Account'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => this._updateUser()
            );
          }
        )],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            this._buildUserImage(),
            this._buildUserInfoDisplay(),
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
                          widget._state.user.userName = value;
                        }
                      }
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.email),
                    title: new TextFormField(
                      decoration: new InputDecoration(hintText: "Email"),
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return 'Please enter an email';
                      //   } else {
                      //     widget._state.user.email = value;
                      //   }
                      // }
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.phone),
                    title: new TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: new InputDecoration(hintText: "Phone Number"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an email';
                        } else {
                          widget._state.user.phoneNumber = value;
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

  Future<void> _updateUser() async {
    if (this._formKey.currentState.validate()) {
      var res = await this._db.updateUser(widget._state.user);

      if (res != null) {
        print(res);
      }
      return;
    }
  }

  Widget _buildUserInfoDisplay() {
    var user = this.widget._state.user;
    var widgets = new List<Widget>();

    var userInfoStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 15.0,
    );

    if (user.userName != null && user.userName.isNotEmpty) {
      widgets.add(Text(user.userName, style: userInfoStyle));
    }

    if (user.email != null && user.email.isNotEmpty) {
      widgets.add(Text(user.email, style: userInfoStyle));
    }

    if (user.phoneNumber != null && user.phoneNumber.isNotEmpty) {
      widgets.add(Text(user.phoneNumber, style: userInfoStyle));
    }

    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets.toList(),
        )
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