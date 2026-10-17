import React from 'react';
import { Pressable, StyleSheet, PressableProps } from 'react-native';
import { AppText } from './AppText';
import { theme } from '../theme';

type Props = PressableProps & { labelKey: string };
export function PrimaryButton({
  labelKey,
  style,
  ...props
}: Props): React.JSX.Element {
  return (
    <Pressable
      accessibilityRole="button"
      style={state => [
        styles.button,
        typeof style === 'function' ? style(state) : style,
      ]}
      {...props}
    >
      <AppText translationKey={labelKey} style={styles.label} />
    </Pressable>
  );
}
const styles = StyleSheet.create({
  button: {
    alignItems: 'center',
    backgroundColor: theme.colors.primary,
    borderRadius: theme.radius.md,
    padding: theme.spacing.md,
  },
  label: { color: theme.colors.white, fontWeight: '700' },
});
