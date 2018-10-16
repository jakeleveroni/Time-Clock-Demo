import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase-database.dart';
import '../models/dtos/user-dto.dart';

class AuthenticationService {
  static final AuthenticationService _singleton = new AuthenticationService._internal();
  FirebaseAuth _auth;
  FirebaseDatabaseService _db;
  FirebaseUser _user;
  UserDto currentUser;

  factory AuthenticationService() {
    return _singleton;
  } 

  AuthenticationService._internal() {
    _auth = FirebaseAuth.instance;
    _db = FirebaseDatabaseService();
  }

  bool isLoggedIn() {
    return (this.currentUser != null);
  }

  Future<dynamic> login(String email, String pass) async {
    this._user = await this._auth.signInWithEmailAndPassword(email: email, password: pass);
    
    if (this._user == null) {
      print('User is null');
      return false;
    } else {
      return await this._db.getUser(this._user.uid).then((QuerySnapshot userSnap) {
        if (userSnap.documents.length == 1) {
          this.currentUser = UserDto.fromDocument(userSnap.documents[0]);
        }
      });
    }
  }

  Future<bool> createAccount(String email, String pass) async {
    var user = await this._auth.createUserWithEmailAndPassword(email: email, password: pass);
    if (user == null) {
      print('Error could not create user');
      return false;
    } else {  
      var newUser = new UserDto(user.displayName, user.email, user.uid, phone: user.phoneNumber, imageUrl: user.photoUrl);
      await this._db.createUser(newUser);
      this.currentUser = newUser;
      return true;
    }
  }

  Future<void> logout() async {
    return await this._auth.signOut();
  }
}