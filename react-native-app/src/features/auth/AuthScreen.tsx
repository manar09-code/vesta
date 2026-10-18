import React from 'react';
import { Image, StyleSheet, View } from 'react-native';
import { useTranslation } from 'react-i18next';
import { AppText } from '../../core/components/AppText';
import { theme } from '../../core/theme';

const logo = require('../../../assets/logo.png');

export function AuthScreen(): React.JSX.Element {
  const { t } = useTranslation();
  return (
    <View style={styles.container}>
      <Image
        source={logo}
        style={styles.logo}
        resizeMode="contain"
        accessibilityLabel={t('appName')}
      />
      <AppText translationKey="login" />
    </View>
  );
}
const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    backgroundColor: theme.colors.background,
    flex: 1,
    justifyContent: 'center',
    padding: theme.spacing.lg,
  },
  logo: {
    height: 200,
    marginBottom: theme.spacing.lg,
    width: 200,
  },
});
