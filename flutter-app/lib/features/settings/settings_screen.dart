import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_links.dart';
import '../../core/config/locale_provider.dart';
import '../../core/router/app_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/auth_controller.dart';

/// Settings opened from the Profile tab (VST-95): language, about, sign out.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// Names are always written in their own language.
  static const _languages = {
    'ar': 'العربية التونسية',
    'fr': 'Français',
    'en': 'English',
  };

  Future<void> _open(BuildContext context, Uri uri) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
    if (!opened) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.settingsLinkError)));
    }
  }

  void _signOut(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signOut();
    // Back to the guest home: nothing of the previous user stays on screen.
    context.go(AppRoutes.explore);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final current = Localizations.localeOf(context).languageCode;
    final signedIn = ref.watch(authStateProvider).value != null;
    final privacyUri = Uri.parse(AppLinks.privacyAndDeletionUrl);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _SectionTitle(l10n.languageLabel),
        RadioGroup<String>(
          groupValue: current,
          onChanged: (code) {
            if (code != null) {
              ref.read(localeProvider.notifier).setLocale(Locale(code));
            }
          },
          child: Column(
            children: [
              for (final entry in _languages.entries)
                RadioListTile<String>(
                  value: entry.key,
                  title: Text(entry.value),
                ),
            ],
          ),
        ),
        const Divider(),
        _SectionTitle(l10n.settingsAbout),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final info = snapshot.data;
            return ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.settingsVersion),
              subtitle: info == null
                  ? null
                  : Text('${info.version} (${info.buildNumber})'),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text(l10n.settingsPrivacy),
          onTap: () => _open(context, privacyUri),
        ),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: Text(l10n.settingsContact),
          subtitle: const Text(AppLinks.contactEmail),
          onTap: () => _open(
            context,
            Uri(scheme: 'mailto', path: AppLinks.contactEmail),
          ),
        ),
        if (signedIn) ...[
          const Divider(),
          // The deletion itself is handled by the Play Store rules ticket
          // (VST-84): for now this opens the page that explains how to ask.
          ListTile(
            leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            title: Text(
              l10n.settingsDeleteAccount,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _open(context, privacyUri),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.authLogoutButton),
            onTap: () => _signOut(context, ref),
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
