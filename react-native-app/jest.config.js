module.exports = {
  preset: '@react-native/jest-preset',
  // Le preset n'autorise pas la transformation de react-native-safe-area-context,
  // dont le mock Jest est livré en TypeScript brut (jest/mock.tsx).
  transformIgnorePatterns: [
    'node_modules/(?!((jest-)?react-native|@react-native(-community)?|react-native-safe-area-context)/)',
  ],
};
