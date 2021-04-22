import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;


  UserRepository() : _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    print('User is SignIn With credential');

    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(String email, String password) {
    print('User is SignUp');

    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    print('User is SignOut');

    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    print('User isSignIn');
//    final currentUser = await _firebaseAuth.currentUser();
    final currentUser =  _firebaseAuth.currentUser;

    return currentUser != null;
  }

  Future<User> getUser() async {
    print ('User is get user');
    // return await _firebaseAuth.currentUser();
    return  _firebaseAuth.currentUser;

  }
}
// import 'package:firebase_auth/firebase_auth.dart' as auth;
//
// Future<auth.User> loginWithEmailPassword(String email,String password) async {
//   auth.UserCredential credential = await auth
//       .FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: email, password: password)
//       .catchError((error) => print("LogIn error:${error.toString()}"));
//
//   if (credential == null) {
//     return null;
//   }else{
//     return credential.user;
//   }
// }
// Future<auth.User> createUserWithEmailPassword(String email,String password) async {
//   auth.UserCredential credential = await auth
//       .FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email, password: password)
//       .catchError((error) => print("Create account error:${error.toString()}"));
//
//   if (credential == null) {
//     return null;
//   }else{
//     return credential.user;
//   }
// }
// Future<void> get signOut{
//   return auth.FirebaseAuth.instance.signOut();
// }