import React from 'react';
import {Image, ImageStyle, StyleProp, StyleSheet, Text, View} from 'react-native';
import {colors, fonts} from '../core/theme';

const IMAGES: Record<string, number> = {
  villa: require('../../assets/images/villa.png'),
  apartment: require('../../assets/images/apartment.png'),
  coast: require('../../assets/images/coast.png'),
  'living-room': require('../../assets/images/living-room.png'),
  kitchen: require('../../assets/images/kitchen.png'),
};

/**
 * Illustration d'un bien. Les PNG sont extraits des SVG de la maquette ;
 * si l'asset manque, on retombe sur une plaque de couleur thème.
 */
export function ListingIllustration({
  imageKey,
  style,
}: {
  imageKey: string;
  style?: StyleProp<ImageStyle>;
}) {
  const source = IMAGES[imageKey];
  if (source) {
    return <Image source={source} style={style} resizeMode="cover" />;
  }
  return (
    <View style={[styles.fallback, style]}>
      <Text style={styles.fallbackIcon}>⌂</Text>
    </View>
  );
}

/**
 * Maison dorée dessinée en pur React Native (toit en Λ + porte en arc),
 * équivalent du `HouseLogoPainter` Flutter.
 */
export function HouseIcon({
  size = 40,
  color = colors.gold,
}: {
  size?: number;
  color?: string;
}) {
  const stroke = Math.max(2, Math.round(size * 0.09));
  return (
    <View style={{width: size, height: size}}>
      {/* Toit : carré bordé en haut/gauche pivoté de 45°. */}
      <View
        style={{
          position: 'absolute',
          left: size * 0.2,
          top: size * 0.12,
          width: size * 0.6,
          height: size * 0.6,
          borderTopWidth: stroke,
          borderLeftWidth: stroke,
          borderTopColor: color,
          borderLeftColor: color,
          transform: [{rotate: '45deg'}],
        }}
      />
      {/* Murs. */}
      <View
        style={{
          position: 'absolute',
          left: size * 0.14,
          top: size * 0.42,
          width: size * 0.72,
          height: size * 0.5,
          borderLeftWidth: stroke,
          borderRightWidth: stroke,
          borderBottomWidth: stroke,
          borderLeftColor: color,
          borderRightColor: color,
          borderBottomColor: color,
        }}
      />
      {/* Porte en arc. */}
      <View
        style={{
          position: 'absolute',
          left: size * 0.37,
          top: size * 0.6,
          width: size * 0.26,
          height: size * 0.32,
          borderWidth: stroke,
          borderBottomWidth: 0,
          borderTopLeftRadius: size * 0.13,
          borderTopRightRadius: size * 0.13,
          borderLeftColor: color,
          borderRightColor: color,
          borderTopColor: color,
        }}
      />
    </View>
  );
}

/** Logo Vesta : maison dorée + « Vesta » + mention « IMMOBILIER ». */
export function BrandLogo({light = false, size = 28}: {light?: boolean; size?: number}) {
  const textColor = light ? '#FFFFFF' : colors.ink;
  return (
    <View style={styles.brandRow}>
      <HouseIcon size={size * 1.35} color={colors.gold} />
      <View style={{marginLeft: size * 0.4}}>
        <Text style={[styles.brandWord, {fontSize: size, color: textColor}]}>Vesta</Text>
        <Text style={[styles.brandTagline, {fontSize: size * 0.31, letterSpacing: size * 0.16}]}>
          IMMOBILIER
        </Text>
      </View>
    </View>
  );
}

/** Eyebrow : petit libellé capitales espacées. */
export function Eyebrow({
  text,
  color = colors.goldDeep,
}: {
  text: string;
  color?: string;
}) {
  return <Text style={[styles.eyebrow, {color}]}>{text.toUpperCase()}</Text>;
}

const styles = StyleSheet.create({
  fallback: {
    backgroundColor: colors.spec,
    alignItems: 'center',
    justifyContent: 'center',
  },
  fallbackIcon: {
    fontSize: 42,
    color: colors.muted2,
  },
  brandRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  brandWord: {
    fontFamily: fonts.serif,
    letterSpacing: -0.5,
    lineHeight: undefined,
  },
  brandTagline: {
    fontFamily: fonts.sans,
    fontWeight: '700',
    color: colors.goldEm,
    marginTop: 2,
  },
  eyebrow: {
    fontFamily: fonts.sans,
    fontSize: 10,
    fontWeight: '700',
    letterSpacing: 2,
  },
});
