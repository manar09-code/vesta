import 'package:flutter/widgets.dart';

import '../../data/auth_repository.dart';

/// Contrôleur de l'écran d'authentification : validation et soumission.
/// La logique reproduit `validateAuth()` de la maquette.
class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  // Champs.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  // Onglet actif.
  bool signupTab = false;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  String? error;
  bool loading = false;

  bool get canSubmit => !loading;

  void setTab({required bool signup}) {
    if (signupTab == signup) return;
    signupTab = signup;
    error = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  /// Valide et connecte (ou inscrit) en mode démo.
  /// Retourne true si l'utilisateur doit entrer dans l'application.
  Future<bool> submit() async {
    if (loading) return false;
    loading = true;
    error = null;
    notifyListeners();

    final result = signupTab
        ? await _repository.signUp(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            confirm: confirmController.text,
          )
        : await _repository.signIn(
            email: emailController.text,
            password: passwordController.text,
          );

    loading = false;
    if (!result.isSuccess) {
      error = result.error;
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}
