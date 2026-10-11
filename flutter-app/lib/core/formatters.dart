// Formatage et recherche insensible à la casse/accents — miroir des
// fonctions `money()` et `normalized()` de la maquette (app.js).

/// 1250000 → « 1 250 000 TND ».
String money(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('\u202F');
    buffer.write(digits[i]);
  }
  return '${buffer.toString()} TND';
}

/// Retire les accents et met en minuscules (recherche « Sousse » ≈ « sousse »).
String normalized(String text) {
  const accents = 'ÀÁÂÃÄÅàáâãäåÇçÈÉÊËèéêëÌÍÎÏìíîïÑñÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÝŸýÿŠšŽžÆæŒœß';
  const plain = 'AAAAAAaaaaaaacceeeeeeeeeiiiiiinnooooooooouuuuuuyyYySsZzAEaeOoes';
  final out = StringBuffer();
  for (final char in text.toLowerCase().split('')) {
    final index = accents.indexOf(char);
    out.write(index == -1 ? char : plain[index]);
  }
  return out.toString();
}
