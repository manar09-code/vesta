/**
 * @format
 *
 * Test minimal de VST-22 : l'application s'affiche (« hello world »).
 * Les tests d'écrans arrivent avec le Sprint 2.
 */

import React from 'react';
import { act, create, ReactTestRenderer } from 'react-test-renderer';

import App from '../App';

test('Vesta affiche hello world au démarrage', () => {
  let tree!: ReactTestRenderer;
  act(() => {
    tree = create(<App />);
  });

  const rendered = JSON.stringify(tree.toJSON());
  expect(rendered).toContain('Vesta');
  expect(rendered).toContain('Hello World');
});
