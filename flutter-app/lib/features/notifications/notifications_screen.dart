import 'package:flutter/material.dart';

import '../../core/widgets/app_states.dart';
import '../../l10n/generated/app_localizations.dart';

/// Notification center. The real list comes with VST-99 part 2; until then the
/// screen shows the standard empty state of the UI kit.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.notifications_none,
      title: l10n.notificationsTitle,
      message: l10n.comingSoon,
    );
  }
}
