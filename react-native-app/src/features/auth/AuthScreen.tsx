import React from 'react';
import { StyleSheet, View } from 'react-native';
import { AppText } from '../../core/components/AppText';
import { theme } from '../../core/theme';

export function AuthScreen(): React.JSX.Element {
  return <View style={styles.container}><AppText translationKey="login" /></View>;
}
const styles = StyleSheet.create({ container: { alignItems: 'center', backgroundColor: theme.colors.background, flex: 1, justifyContent: 'center', padding: theme.spacing.lg } });
