import '../../models/dtos/user-dto.dart';
import '../../services/authentication-service.dart';
import '../../services/firebase-database.dart';

class AccountPageState {
  AuthenticationService _auth;
  FirebaseDatabaseService _db;
  UserDto _user;

  AccountPageState() {
    this._auth = AuthenticationService();
    this._db = FirebaseDatabaseService();
    
  } 

  UserDto get user => this._auth.currentUser;
  set userName(String uname) {
    if (uname.isNotEmpty) {
      this._auth.currentUser.userName = uname;
    }
  }

  set phoneNumber(String number) {
    if (number.isNotEmpty) {
      this._auth.currentUser.phoneNumber = number;
    }
  }

  set email(String email) {
    if (email.isNotEmpty) {
      this._auth.currentUser.email = email;
    }
  }
}