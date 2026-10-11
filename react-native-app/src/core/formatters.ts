/**
 * Formatage et recherche insensible à la casse/accents — miroir des
 * fonctions `money()` et `normalized()` de la maquette (app.js)
 * et de lib/core/formatters.dart côté Flutter.
 */

/** 1250000 → « 1 250 000 TND ». */
export function money(amount: number): string {
  const digits = Math.round(amount).toString();
  let out = '';
  for (let i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 === 0) {
      out += '\u202F'; // espace fine insécable, comme Intl fr-FR
    }
    out += digits[i];
  }
  return `${out} TND`;
}

const ACCENTS = 'ÀÁÂÃÄÅàáâãäåÇçÈÉÊËèéêëÌÍÎÏìíîïÑñÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÝŸýÿŠšŽžÆæŒœß';
const PLAIN = 'AAAAAAaaaaaaacceeeeeeeeeiiiiiinnooooooooouuuuuuyyYySsZzAEaeOoes';

/** Retire les accents et met en minuscules (recherche « Sousse » ≈ « sousse »). */
export function normalized(text: string): string {
  let out = '';
  for (const char of text.toLowerCase()) {
    const index = ACCENTS.indexOf(char);
    out += index === -1 ? char : PLAIN[index];
  }
  return out;
}
