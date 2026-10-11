/**
 * @format
 *
 * Tests de l'application Vesta — miroir des 3 tests Flutter
 * (flutter-app/test/widget_test.dart) : écran de connexion, entrée
 * sans compte et messages de validation du formulaire.
 */

import React from 'react';
import ReactTestRenderer from 'react-test-renderer';
import App from '../App';

// Le provider natif n’émet aucune mesure en environnement de test :
// on utilise le mock officiel de la bibliothèque.
jest.mock('react-native-safe-area-context', () =>
  require('react-native-safe-area-context/jest/mock').default,
);

/** Rend l'application et rend la main une fois l'arbre monté. */
function renderApp(): ReactTestRenderer.ReactTestRenderer {
  let renderer!: ReactTestRenderer.ReactTestRenderer;
  ReactTestRenderer.act(() => {
    renderer = ReactTestRenderer.create(<App />);
  });
  return renderer;
}

/** Nœuds dont le texte est exactement `text` (chaîne ou dans un tableau). */
function textNodes(
  renderer: ReactTestRenderer.ReactTestRenderer,
  text: string,
) {
  return renderer.root.findAll(
    node =>
      node.props.children === text ||
      (Array.isArray(node.props.children) && node.props.children.includes(text)),
  );
}

/** Remonte l'arbre jusqu'au premier ancêtre cliquable (`onPress`). */
function pressableForText(
  renderer: ReactTestRenderer.ReactTestRenderer,
  text: string,
): Record<string, any> {
  const matches = textNodes(renderer, text);
  if (matches.length === 0) {
    throw new Error(`Texte introuvable dans l’arbre : ${text}`);
  }
  let node: ReactTestRenderer.ReactTestInstance | null = matches[0];
  while (node !== null && typeof node.props.onPress !== 'function') {
    node = node.parent;
  }
  if (node === null) {
    throw new Error(`Aucun conteneur cliquable pour : ${text}`);
  }
  return node.props;
}

let active: ReactTestRenderer.ReactTestRenderer | null = null;

afterEach(() => {
  if (active !== null) {
    ReactTestRenderer.act(() => active?.unmount());
    active = null;
  }
});

test("Vesta affiche l’écran de connexion au démarrage", () => {
  active = renderApp();

  expect(textNodes(active, 'Trouvez votre place.').length).toBeGreaterThan(0);
  expect(textNodes(active, 'CONNEXION').length).toBeGreaterThan(0);
  expect(textNodes(active, 'INSCRIPTION').length).toBeGreaterThan(0);
});

test("L’entrée sans compte ouvre la liste des biens", () => {
  active = renderApp();

  const entry = pressableForText(active, 'Explorer sans compte');
  ReactTestRenderer.act(() => {
    entry.onPress();
  });

  // Les annonces du jeu de démo s’affichent (liste + carte).
  expect(textNodes(active, 'Villa des Oliviers').length).toBeGreaterThan(0);
  expect(textNodes(active, 'Le Patio Bleu').length).toBeGreaterThan(0);
});

test('Les erreurs de formulaire s’affichent (connexion vide)', async () => {
  active = renderApp();

  const submit = pressableForText(active, 'SE CONNECTER');
  // La validation du repository est délibérément différée (latence réseau).
  await ReactTestRenderer.act(async () => {
    submit.onPress();
    await new Promise<void>(resolve => setTimeout(resolve, 600));
  });

  expect(
    textNodes(active, 'Entrez une adresse e-mail valide.').length,
  ).toBeGreaterThan(0);
});
