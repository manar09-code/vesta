/// Résultat d'une opération d'authentification.
class AuthResult {
  const AuthResult.ok() : error = null;
  const AuthResult.failure(this.error);

  final String? error;
  bool get isSuccess => error == null;
}

/// Authentification. En démo, la validation reprend les messages de la
/// maquette ; une implémentation FirebaseAuth pourra être branchée ici.
abstract class AuthRepository {
  Future<AuthResult> signIn({required String email, required String password});
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
    required String confirm,
  });
}

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Repository de démonstration : validation locale, aucun compte créé.
class DemoAuthRepository implements AuthRepository {
  /// Simule la latence d'un appel réseau.
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 450));

  @override
  Future<AuthResult> signIn({required String email, required String password}) async {
    await _delay();
    if (!_emailPattern.hasMatch(email.trim())) {
      return const AuthResult.failure('Entrez une adresse e-mail valide.');
    }
    if (password.length < 6) {
      return const AuthResult.failure('Le mot de passe doit contenir au moins 6 caractères.');
    }
    return const AuthResult.ok();
  }

  @override
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
    required String confirm,
  }) async {
    await _delay();
    if (name.trim().isEmpty) {
      return const AuthResult.failure('Indiquez votre nom.');
    }
    if (!_emailPattern.hasMatch(email.trim())) {
      return const AuthResult.failure('Entrez une adresse e-mail valide.');
    }
    if (password.length < 6) {
      return const AuthResult.failure('Le mot de passe doit contenir au moins 6 caractères.');
    }
    if (password != confirm) {
      return const AuthResult.failure('Les mots de passe ne correspondent pas.');
    }
    return const AuthResult.ok();
  }
}
