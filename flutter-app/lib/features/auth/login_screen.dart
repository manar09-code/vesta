import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../l10n/generated/app_localizations.dart';
import 'auth_controller.dart';
import 'auth_messages.dart';
import 'require_sign_in.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authControllerProvider).isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signIn(_email.text, _password.text);
    // Back to the screen that asked for the account (see requireSignIn).
    if (ok && mounted) finishSignIn(context);
  }

  Future<void> _goToSignUp() async {
    final signedUp = await context.push<bool>(AppRoutes.signup);
    if (signedUp == true && mounted) finishSignIn(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.loginTitle,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: l10n.authEmailLabel),
                  validator: (value) =>
                      authErrorOrNull(l10n, validateEmail(value)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  decoration:
                      InputDecoration(labelText: l10n.authPasswordLabel),
                  validator: (value) =>
                      authErrorOrNull(l10n, validatePassword(value)),
                  onFieldSubmitted: (_) => _submit(),
                ),
                if (auth.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    authErrorMessage(l10n, auth.error!),
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: auth.isLoading ? null : _submit,
                  child: auth.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.authLoginButton),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: auth.isLoading ? null : _goToSignUp,
                  child: Text(l10n.authGoToSignUp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

