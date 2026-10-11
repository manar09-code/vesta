import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Une notification de démonstration.
class AppNotification {
  const AppNotification({required this.title, required this.body, required this.time, this.unread = false});

  final String title;
  final String body;
  final String time;
  final bool unread;
}

/// Notifications de démo (sera alimentées par FCM dans la version finale).
const demoNotifications = <AppNotification>[
  AppNotification(
    title: 'Nouveau bien à La Marsa',
    body: 'Une villa similaire à vos favoris vient d’être publiée.',
    time: 'Il y a 12 min',
    unread: true,
  ),
  AppNotification(
    title: 'Prix en baisse',
    body: 'Le prix de « Le Patio Bleu » a baissé de 100 TND.',
    time: 'Hier',
    unread: true,
  ),
  AppNotification(
    title: 'Bienvenue sur Vesta',
    body: 'Complétez votre profil pour recevoir des alertes personnalisées.',
    time: 'Cette semaine',
  ),
];

/// Écran Notifications.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VestaColors.shell,
      appBar: AppBar(
        backgroundColor: VestaColors.header,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: VestaColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: Theme.of(context).extension<VestaTextStyle>()!.serifStyle(22),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demoNotifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final notification = demoNotifications[index];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: notification.unread ? const Color(0xFFF6F1E4) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: VestaColors.borderCard),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: notification.unread ? VestaColors.badgeBg : VestaColors.spec,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 19,
                    color: notification.unread ? VestaColors.badgeText : VestaColors.muted2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 13, fontWeight: FontWeight.w700, color: VestaColors.ink),
                            ),
                          ),
                          if (notification.unread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: VestaColors.gold, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(notification.body, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, height: 1.45, color: VestaColors.muted)),
                      const SizedBox(height: 5),
                      Text(notification.time, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, color: VestaColors.muted2)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
