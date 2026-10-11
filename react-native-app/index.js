/**
 * Point d'entrée Expo : enregistre l'arbre racine et charge les polices DM
 * (dans Expo Go, l'enregistrement natif des polices n'est pas actif, elles
 * doivent donc être chargées à l'exécution).
 */
import { registerRootComponent } from 'expo';
import * as Font from 'expo-font';

import App from './App';

Font.loadAsync({
  DMSans: require('./assets/fonts/DMSans.ttf'),
  DMSerifDisplay: require('./assets/fonts/DMSerifDisplay.ttf'),
}).catch(() => {
  // Repli silencieux sur la police système si le chargement échoue.
});

registerRootComponent(App);
