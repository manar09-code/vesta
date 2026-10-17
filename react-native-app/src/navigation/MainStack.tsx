import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { HomeScreen } from '../features/home/HomeScreen';

export type MainStackParamList = { Home: undefined };
const Stack = createNativeStackNavigator<MainStackParamList>();

export function MainStack(): React.JSX.Element {
  return <Stack.Navigator screenOptions={{ headerShown: false }}><Stack.Screen name="Home" component={HomeScreen} /></Stack.Navigator>;
}
