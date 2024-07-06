import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi{
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login()=> _googleSignIn.signIn();
  static Future<void> logout() async {
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.disconnect();
    } else {
      print('No user is currently signed in by google.');
    }
  }
}