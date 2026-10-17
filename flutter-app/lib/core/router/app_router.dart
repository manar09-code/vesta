import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/listings/listings_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/search/search_screen.dart';
import '../../l10n/generated/app_localizations.dart';

abstract class AppRoutes {
  static const explore = '/';
  static const search = '/search';
  static const map = '/map';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const login = '/login';
  static const chat = '/chat';
  static const notifications = '/notifications';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.explore,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _MainShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.explore,
            builder: (context, state) => const ListingsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.search,
            builder: (context, state) => const SearchScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.map,
            builder: (context, state) => const MapScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.favorites,
            builder: (context, state) => const FavoritesScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const _SubPage(child: LoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (context, state) => const _SubPage(child: ChatScreen()),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) =>
          const _SubPage(child: NotificationsScreen()),
    ),
  ],
);

/// Bottom navigation shared by the 5 main tabs.
class _MainShell extends StatelessWidget {
  const _MainShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titles = [
      l10n.tabExplore,
      l10n.tabSearch,
      l10n.tabMap,
      l10n.tabFavorites,
      l10n.tabProfile,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[shell.currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: l10n.chatTitle,
            onPressed: () => context.push(AppRoutes.chat),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            tooltip: l10n.notificationsTitle,
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_work_outlined), label: titles[0]),
          NavigationDestination(
              icon: const Icon(Icons.search), label: titles[1]),
          NavigationDestination(
              icon: const Icon(Icons.map_outlined), label: titles[2]),
          NavigationDestination(
              icon: const Icon(Icons.favorite_border), label: titles[3]),
          NavigationDestination(
              icon: const Icon(Icons.person_outline), label: titles[4]),
        ],
      ),
    );
  }
}

/// Simple page with a back button, used for screens outside the tabs.
class _SubPage extends StatelessWidget {
  const _SubPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: child);
  }
}
