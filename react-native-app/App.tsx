import React from 'react';
import {StatusBar, StyleSheet, View} from 'react-native';
import {SafeAreaProvider} from 'react-native-safe-area-context';
import {AppProvider, useApp} from './src/app_state';
import {colors} from './src/core/theme';
import {HomeShell} from './src/home_shell';
import {NavigatorProvider, Route, useNavigator} from './src/navigation';
import {AuthScreen} from './src/screens/auth_screen';
import {ChatScreen} from './src/screens/chat_screen';
import {DetailsScreen} from './src/screens/details_screen';
import {NotificationsScreen} from './src/screens/notifications_screen';
import {ToastProvider} from './src/widgets/toast';

/**
 * Vesta — version React Native.
 * Structure identique à la version Flutter : écran → contrôleur →
 * repository → service, thème commun à la maquette web.
 */
export default function App() {
  return (
    <SafeAreaProvider>
      <StatusBar barStyle="dark-content" />
      <AppProvider>
        <ToastProvider>
          <NavigatorProvider>
            <RootGate />
          </NavigatorProvider>
        </ToastProvider>
      </AppProvider>
    </SafeAreaProvider>
  );
}

/**
 * Écran d'authentification ou coquille selon l'état de session, puis
 * superposition des routes empilées (détails, chat, notifications).
 */
function RootGate() {
  const {isSignedIn} = useApp();
  const {stack, pop} = useNavigator();

  return (
    <View style={styles.root}>
      {isSignedIn ? <HomeShell /> : <AuthScreen />}
      {stack.map((route, index) => (
        <View
          key={`${route.name}-${index}`}
          style={[styles.overlay, {zIndex: 10 + index}]}>
          <RouteView route={route} onBack={pop} />
        </View>
      ))}
    </View>
  );
}

/** Rendu d'une route de la pile. */
function RouteView({route, onBack}: {route: Route; onBack: () => void}) {
  const app = useApp();
  const {push} = useNavigator();

  if (route.name === 'notifications') {
    return <NotificationsScreen onBack={onBack} />;
  }

  const listing = app.byId(route.listingId);
  if (listing === null) {
    // Annonce introuvable (rouge de démarrage) : on referme l’écran.
    return null;
  }

  if (route.name === 'chat') {
    return <ChatScreen listing={listing} onBack={onBack} />;
  }

  return (
    <DetailsScreen
      listing={listing}
      onBack={onBack}
      onContact={contacted => push({name: 'chat', listingId: contacted.id})}
    />
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: colors.shell,
  },
  overlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: colors.shell,
  },
});
