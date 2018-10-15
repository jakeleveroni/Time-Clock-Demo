import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<UserDto> login(String email, String pass) async {
    this._user = await this._auth.signInWithEmailAndPassword(email: email, password: pass);
    
    if (this._user == null) {
      print('User is null');
      return null;
    } else {
      this.currentUser = new UserDto(this._user.displayName, this._user.email, this._user.uid);
      return this.currentUser;
    }
  }

  Future<bool> createAccount(String email, String pass) async {
    var user = await this._auth.createUserWithEmailAndPassword(email: email, password: pass);
    if (user == null) {
      print('Error could not create user');
      return false;
    } else {  
      await this._db.createUser(new UserDto(user.displayName, user.email, user.uid));
      return true;
    }
  }

  Future<void> logout() async {
    return await this._auth.signOut();
  }
}