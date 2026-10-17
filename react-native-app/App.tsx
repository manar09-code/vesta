import React, { useEffect, useState } from 'react';
import { I18nextProvider } from 'react-i18next';
import { ActivityIndicator, View } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { AuthProvider, useAuth } from './src/features/auth/authController';
import { AppText } from './src/core/components/AppText';
import { theme } from './src/core/theme';
import { i18n, initializeLanguage } from './src/core/i18n';
import { AuthStack } from './src/navigation/AuthStack';
import { MainStack } from './src/navigation/MainStack';

function RootNavigation(): React.JSX.Element {
  const { isSignedIn } = useAuth();
  return <NavigationContainer>{isSignedIn ? <MainStack /> : <AuthStack />}</NavigationContainer>;
}

export default function App(): React.JSX.Element {
  const [ready, setReady] = useState(false);
  useEffect(() => {
    initializeLanguage().finally(() => setReady(true));
  }, []);

  return (
    <I18nextProvider i18n={i18n}>
      <AuthProvider>
        {ready ? (
          <RootNavigation />
        ) : (
          <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: theme.colors.background }}>
            <ActivityIndicator color={theme.colors.primary} />
            <AppText translationKey="loading" />
          </View>
        )}
      </AuthProvider>
    </I18nextProvider>
  );
}
