import React from 'react';
import { StyleSheet, TextInput, TextInputProps, View } from 'react-native';
import { AppText } from './AppText';
import { theme } from '../theme';

type Props = TextInputProps & { labelKey: string };
export function AppTextField({ labelKey, style, ...props }: Props): React.JSX.Element {
  return <View style={styles.container}><AppText translationKey={labelKey} /><TextInput placeholderTextColor={theme.colors.muted} style={[styles.input, style]} {...props} /></View>;
}
const styles = StyleSheet.create({ container: { gap: theme.spacing.xs }, input: { borderColor: theme.colors.border, borderRadius: theme.radius.sm, borderWidth: 1, color: theme.colors.text, padding: theme.spacing.md } });
