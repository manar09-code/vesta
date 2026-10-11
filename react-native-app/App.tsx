import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

/**
 * Vesta — version React Native.
 * VST-22 : point de départ minimal (« hello world »).
 * Les écrans et contrôleurs arrivent en Sprint 2 (voir le backlog).
 */
export default function App(): React.JSX.Element {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Vesta</Text>
      <Text style={styles.hello}>Hello World</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#FFFFFF',
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    color: '#13294B',
    marginBottom: 8,
  },
  hello: {
    fontSize: 16,
    color: '#5E6575',
  },
});
