import React from 'react';
import {StyleSheet, Text, View} from 'react-native';
import {fonts} from '../core/theme';

/**
 * Petits pictogrammes dessinés en pur React Native : aucune dépendance
 * d'icônes externe, traits monochromes alignés sur la maquette.
 */

export function CompassIcon({size = 24, color}: {size?: number; color: string}) {
  return (
    <View
      style={[
        styles.ring,
        {width: size, height: size, borderRadius: size / 2, borderColor: color},
      ]}>
      <View
        style={{
          width: size * 0.3,
          height: size * 0.3,
          backgroundColor: color,
          transform: [{rotate: '45deg'}],
        }}
      />
    </View>
  );
}

export function HeartIcon({
  size = 24,
  color,
  filled,
}: {
  size?: number;
  color: string;
  filled?: boolean;
}) {
  return (
    <Text
      style={{
        fontFamily: fonts.sans,
        fontSize: size * 0.95,
        lineHeight: size * 1.08,
        color,
      }}>
      {filled ? '♥' : '♡'}
    </Text>
  );
}

export function PlusIcon({size = 24, color}: {size?: number; color: string}) {
  const bar = Math.max(2, Math.round(size * 0.11));
  return (
    <View style={{width: size, height: size, alignItems: 'center', justifyContent: 'center'}}>
      <View
        style={{
          position: 'absolute',
          width: size * 0.78,
          height: bar,
          borderRadius: bar,
          backgroundColor: color,
        }}
      />
      <View
        style={{
          position: 'absolute',
          width: bar,
          height: size * 0.78,
          borderRadius: bar,
          backgroundColor: color,
        }}
      />
    </View>
  );
}

export function PinIcon({size = 24, color}: {size?: number; color: string}) {
  return (
    <Text
      style={{
        fontFamily: fonts.sans,
        fontSize: size * 1.05,
        lineHeight: size * 1.1,
        color,
      }}>
      ⌖
    </Text>
  );
}

export function PersonIcon({size = 24, color}: {size?: number; color: string}) {
  const head = size * 0.36;
  return (
    <View style={{width: size, height: size, alignItems: 'center', justifyContent: 'flex-end'}}>
      <View
        style={{
          width: head,
          height: head,
          borderRadius: head / 2,
          backgroundColor: color,
          marginBottom: size * 0.06,
        }}
      />
      <View
        style={{
          width: size * 0.72,
          height: size * 0.34,
          backgroundColor: color,
          borderTopLeftRadius: size * 0.36,
          borderTopRightRadius: size * 0.36,
        }}
      />
    </View>
  );
}

/** Flèche de retour, titre du héros et boutons ronds. */
export function ArrowBackIcon({size = 20, color}: {size?: number; color: string}) {
  return (
    <Text
      style={{
        fontFamily: fonts.sans,
        fontSize: size * 1.05,
        lineHeight: size * 1.1,
        color,
      }}>
      ←
    </Text>
  );
}

export function SendIcon({size = 18, color}: {size?: number; color: string}) {
  return (
    <Text
      style={{
        fontFamily: fonts.sans,
        fontSize: size * 1.05,
        lineHeight: size * 1.1,
        color,
      }}>
      ➤
    </Text>
  );
}

/** Enveloppe (champ e-mail), tracée comme l'icône de la maquette. */
export function MailIcon({size = 20, color}: {size?: number; color: string}) {
  const stroke = Math.max(1.5, size * 0.09);
  return (
    <View
      style={{
        width: size * 1.1,
        height: size * 0.82,
        borderWidth: stroke,
        borderRadius: size * 0.16,
        alignItems: 'center',
        justifyContent: 'center',
      }}>
      <View
        style={{
          position: 'absolute',
          width: size * 0.66,
          height: stroke,
          backgroundColor: color,
          top: size * 0.12,
          left: size * 0.05,
          transform: [{rotate: '28deg'}],
        }}
      />
      <View
        style={{
          position: 'absolute',
          width: size * 0.66,
          height: stroke,
          backgroundColor: color,
          top: size * 0.12,
          right: size * 0.05,
          transform: [{rotate: '-28deg'}],
        }}
      />
    </View>
  );
}

/** Cadenas (champ mot de passe). */
export function LockIcon({size = 20, color}: {size?: number; color: string}) {
  const stroke = Math.max(1.5, size * 0.09);
  return (
    <View style={{width: size * 1.1, alignItems: 'center'}}>
      <View
        style={{
          width: size * 0.62,
          height: size * 0.42,
          borderWidth: stroke,
          borderBottomWidth: 0,
          borderTopLeftRadius: size * 0.31,
          borderTopRightRadius: size * 0.31,
          borderLeftColor: color,
          borderRightColor: color,
          borderTopColor: color,
        }}
      />
      <View
        style={{
          width: size * 0.86,
          height: size * 0.6,
          borderRadius: size * 0.12,
          backgroundColor: color,
          marginTop: size * 0.06,
        }}
      />
    </View>
  );
}

/** Personne (champ nom complet). */
export function UserIcon({size = 20, color}: {size?: number; color: string}) {
  return <PersonIcon size={size * 1.05} color={color} />;
}

const styles = StyleSheet.create({
  ring: {
    borderWidth: 2,
    alignItems: 'center',
    justifyContent: 'center',
  },
  glyph: {
    fontFamily: 'DMSans',
  },
});
