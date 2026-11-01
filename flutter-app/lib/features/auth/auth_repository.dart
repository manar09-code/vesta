import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Errors the UI can show. Screens turn them into translated messages.
enum AuthError {
  invalidEmail,
  passwordTooShort,
  nameRequired,
  emailInUse,
  wrongPassword,
  noNetwork,
  unknown,
}

class AuthFailure implements Exception {
  const AuthFailure(this.error);

  final AuthError error;
}

/// Only place that talks to Firebase Auth and to the `users` collection.
class AuthRepository {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// Emits the signed-in user, or null when signed out.
  /// Until Firebase is configured, the app behaves as signed out.
  Stream<User?> authStateChanges() {
    if (Firebase.apps.isEmpty) return Stream.value(null);
    return _auth.authStateChanges();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    User? created;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      created = credential.user!;
      await created.updateDisplayName(displayName);

      // Data model v3: public profile + private contact, one batch write.
      final userRef = _db.collection('users').doc(created.uid);
      final batch = _db.batch();
      batch.set(userRef, {
        'displayName': displayName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      batch.set(userRef.collection('private').doc('contact'), {
        'email': email,
      });
      await batch.commit();

      // First verification mail. If it fails the account is still fine: the
      // user can ask again from the banner.
      try {
        await created.sendEmailVerification();
      } catch (_) {}
    } on FirebaseAuthException catch (e) {
      await _rollback(created);
      throw AuthFailure(_mapAuthCode(e.code));
    } on FirebaseException catch (e) {
      // Firestore error (for example no network or rules not deployed yet).
      // The Auth account would stay without a profile, so remove it.
      await _rollback(created);
      throw AuthFailure(
        e.code == 'unavailable' ? AuthError.noNetwork : AuthError.unknown,
      );
    }
  }

  /// Deletes the just-created Auth account so a retry does not fail with
  /// "email already in use". Never hides the original error.
  Future<void> _rollback(User? user) async {
    try {
      await user?.delete();
    } catch (_) {}
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthCode(e.code));
    }
  }

  Future<void> signOut() => _auth.signOut();

  /// Sends the verification mail to the signed-in user.
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthCode(e.code));
    }
  }

  /// Reloads the signed-in user from Firebase and tells if the email is now
  /// verified (the local user object does not change by itself).
  Future<bool> reloadEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return true;
    await user.reload();
    return _auth.currentUser?.emailVerified ?? true;
  }

  /// Sends the reset mail. An unknown email gives the same result as a known
  /// one, so nobody can find out which emails have an account.
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return;
      throw AuthFailure(_mapAuthCode(e.code));
    }
  }

  AuthError _mapAuthCode(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthError.invalidEmail;
      case 'email-already-in-use':
        return AuthError.emailInUse;
      case 'weak-password':
        return AuthError.passwordTooShort;
      case 'wrong-password':
      case 'invalid-credential':
      case 'user-not-found':
        return AuthError.wrongPassword;
      case 'network-request-failed':
        return AuthError.noNetwork;
      default:
        return AuthError.unknown;
    }
  }
}