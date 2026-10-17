import React from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { useTranslation } from 'react-i18next';
import { appConfig, formatPrice } from '../../core/config';
import { AppText } from '../../core/components/AppText';
import { PrimaryButton } from '../../core/components/PrimaryButton';
import { changeAppLanguage } from '../../core/i18n';
import { theme } from '../../core/theme';

export function HomeScreen(): React.JSX.Element {
  const { t } = useTranslation();
  return (
    <ScrollView contentContainerStyle={styles.container}>
      <AppText translationKey="appName" style={styles.title} />
      <AppText translationKey="homePriceExample" values={{ price: formatPrice(450000) }} />
      <AppText translationKey="language" style={styles.languageLabel} />
      <View style={styles.languages}>
        {appConfig.supportedLanguages.map(language => (
          <PrimaryButton key={language} labelKey={`language${language.toUpperCase()}`} onPress={() => void changeAppLanguage(language)} accessibilityLabel={t('language')} />
        ))}
      </View>
    </ScrollView>
  );
}
const styles = StyleSheet.create({ container: { alignItems: 'center', backgroundColor: theme.colors.background, flexGrow: 1, gap: theme.spacing.lg, justifyContent: 'center', padding: theme.spacing.lg }, title: { color: theme.colors.primary, fontSize: theme.fontSizes.heading, fontWeight: '700' }, languageLabel: { marginTop: theme.spacing.lg }, languages: { flexDirection: 'row', gap: theme.spacing.sm } });
