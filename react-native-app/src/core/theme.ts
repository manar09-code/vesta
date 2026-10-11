import {Platform, TextStyle} from 'react-native';

/**
 * Jetons de design Vesta — palette navy / or / crème, alignée sur la
 * maquette de refonte et identique à lib/core/theme.dart côté Flutter.
 */
export const colors = {
  ink: '#13294B', // texte principal / navy
  inkSoft: '#1B3760', // onglet actif, chips actives
  primary: '#13294B', // bouton principal
  primaryHover: '#1C3A64',
  link: '#1B3760',

  gold: '#C6973F', // marque + CTA
  goldDeep: '#AF7F2E', // eyebrow sur crème
  goldTab: '#C6973F', // piste / onglet actif
  goldEm: '#D9A75C', // <em> doré sur navy
  goldCard: '#AF7F2E', // sur-titre carte
  focus: '#C6973F', // anneau de focus

  page: '#EFEAE0', // fond de page
  shell: '#F8F4EC', // fond de l'« app shell »
  header: '#F1ECDF', // en-tête de la liste
  spec: '#F0ECE1', // pastilles surface/chambres
  badgeBg: '#F6EFDF',
  badgeText: '#8A6522',

  border: '#E7E1D4',
  borderInput: '#E2DCCE',
  borderCard: '#EEE9DD',
  borderSoft: '#E7E1D4',

  muted: '#6E7688',
  muted2: '#7E8595',
  muted3: '#868D9C',
  muted4: '#868D9A',
  placeholder: '#A5A9B4',

  errorBg: '#FFF0ED',
  errorText: '#9C4031',

  heart: '#BF624C',
  navActive: '#13294B',
  navIdle: '#9AA0AE',

  // ——— Héros d'authentification (refonte) ———
  authTop1: '#1E3A66',
  authTop2: '#16305A',
  authTop3: '#0F2445',
  heroPhoto: '#24406B', // repli si l'image manque
  sheet: '#F7F2E8', // panneau crème
  sheetTrack: '#EBE5D8', // piste des onglets segmentés
  wave: '#EFE3CB', // vague décorative
  eyebrowOnDark: '#D9A75C',

  price: '#13294B',
  priceStrong: '#13294B',
  specText: '#2E4066',
  cardFoot: '#5E6575',
  mapText: '#1D3F6B',
};

/** Polices DM Sans / DM Serif Display, embarquées dans les dossiers natifs. */
export const fonts = {
  sans: Platform.select({ios: 'DM Sans', default: 'DMSans'}) as string,
  serif: Platform.select({ios: 'DM Serif Display', default: 'DMSerifDisplay'}) as string,
};

/** Titre sérif façon « DM Serif Display ». */
export const serifStyle = (size: number, color: string = colors.ink): TextStyle => ({
  fontFamily: fonts.serif,
  fontSize: size,
  color,
  includeFontPadding: false,
});

/** Texte courant « DM Sans ». */
export const sansStyle = (
  size: number,
  color: string = colors.ink,
  weight: TextStyle['fontWeight'] = '400',
): TextStyle => ({
  fontFamily: fonts.sans,
  fontSize: size,
  color,
  fontWeight: weight,
});

/** Eyebrow : petit libellé capitales très espacé. */
export const eyebrowStyle: TextStyle = {
  fontFamily: fonts.sans,
  fontSize: 10,
  fontWeight: '700',
  letterSpacing: 2,
  color: colors.goldDeep,
};

/** Rayons communs, alignés sur la maquette. */
export const radius = {
  input: 14,
  card: 17,
  headerBottom: 36,
  chip: 100,
  panel: 16,
};
