import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Optional: Add serverClientId for web support
    // serverClientId: 'YOUR_SERVER_CLIENT_ID.apps.googleusercontent.com',
  );

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current user
  User? get currentUser => _auth.currentUser;

  /// Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Email sign in error: ${e.code} - ${e.message}");
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optional: Send email verification
      await result.user?.sendEmailVerification();

      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Sign up error: ${e.code} - ${e.message}");
      rethrow;
    }
  }

  /// Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Attempt to sign in silently first (for returning users)
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signInSilently().catchError((_) => null) ??
          await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(
        credential,
      );
      return result.user;
    } catch (e) {
      print("Google sign in error: $e");
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print("Password reset error: ${e.code} - ${e.message}");
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      print("Sign out error: $e");
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      print("Account deletion error: ${e.code} - ${e.message}");
      rethrow;
    }
  }

  /// Check if email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Reload user data (useful after email verification)
  Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  /// Get authentication provider
  String getProvider() {
    if (currentUser == null) return 'none';
    final providers = currentUser!.providerData;
    if (providers.any((userInfo) => userInfo.providerId == 'google.com')) {
      return 'google';
    } else if (providers.any((userInfo) => userInfo.providerId == 'password')) {
      return 'email';
    }
    return 'unknown';
  }
}
