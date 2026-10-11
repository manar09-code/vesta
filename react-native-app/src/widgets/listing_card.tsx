import React from 'react';
import {Pressable, StyleSheet, Text, View} from 'react-native';
import {money} from '../core/formatters';
import {colors, fonts} from '../core/theme';
import {isSale, Listing, transactionLabel} from '../models/listing';
import {ListingIllustration} from './brand';

/**
 * Carte d'annonce (liste et favoris) — même anatomy que la maquette :
 * visuel + badge + cœur, puis type, titre, localisation, prix et surface.
 */
export function ListingCard({
  listing,
  isFavorite,
  onToggleFavorite,
  onOpen,
}: {
  listing: Listing;
  isFavorite: boolean;
  onToggleFavorite: () => void;
  onOpen: () => void;
}) {
  return (
    <View style={styles.card}>
      {/* ——— Visuel, badge et favori ——— */}
      <View style={styles.media}>
        <Pressable onPress={onOpen} accessibilityRole="button">
          <ListingIllustration imageKey={listing.image} style={styles.image} />
        </Pressable>
        <View style={styles.badge}>
          <Text style={styles.badgeText}>{transactionLabel(listing)}</Text>
        </View>
        <Pressable
          onPress={onToggleFavorite}
          accessibilityRole="button"
          accessibilityLabel={
            isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris'
          }
          style={styles.heart}>
          <Text
            style={[
              styles.heartIcon,
              {color: isFavorite ? colors.heart : colors.ink},
            ]}>
            {isFavorite ? '♥' : '♡'}
          </Text>
        </Pressable>
      </View>

      {/* ——— Contenu ——— */}
      <View style={styles.body}>
        <View style={styles.bodyHead}>
          <Text style={styles.eyebrowLabel}>{listing.type.toUpperCase()}</Text>
          <Text style={styles.eyebrowLabel}>✦ Sélection Vesta</Text>
        </View>
        <Pressable onPress={onOpen}>
          <Text style={styles.title}>{listing.title}</Text>
        </Pressable>
        <Text style={styles.location}>⌖ {listing.location}</Text>
        <View style={styles.divider} />
        <View style={styles.foot}>
          <View style={styles.priceRow}>
            <Text style={styles.price} numberOfLines={1}>
              {money(listing.price)}
            </Text>
            {!isSale(listing) && <Text style={styles.perMonth}> / mois</Text>}
          </View>
          <Text style={styles.area} numberOfLines={1}>
            {listing.area} m² · {listing.rooms} ch.
          </Text>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 17,
    borderWidth: 1,
    borderColor: colors.borderCard,
    overflow: 'hidden',
    marginBottom: 17,
    shadowColor: '#213E34',
    shadowOpacity: 0.06,
    shadowRadius: 25,
    shadowOffset: {width: 0, height: 8},
    elevation: 3,
  },
  media: {
    height: 185,
    backgroundColor: colors.spec,
  },
  image: {
    width: '100%',
    height: 185,
  },
  badge: {
    position: 'absolute',
    top: 13,
    left: 13,
    backgroundColor: '#FFFFFF',
    borderRadius: 6,
    paddingHorizontal: 9,
    paddingVertical: 6,
  },
  badgeText: {
    fontFamily: fonts.sans,
    fontSize: 10,
    fontWeight: '700',
    color: colors.badgeText,
  },
  heart: {
    position: 'absolute',
    top: 10,
    right: 10,
    width: 34,
    height: 34,
    borderRadius: 17,
    backgroundColor: 'rgba(255,255,255,0.95)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  heartIcon: {
    fontSize: 20,
    lineHeight: 22,
    fontFamily: fonts.sans,
  },
  body: {
    padding: 15,
  },
  bodyHead: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 7,
  },
  eyebrowLabel: {
    fontFamily: fonts.sans,
    fontSize: 10,
    fontWeight: '700',
    letterSpacing: 0.8,
    color: colors.goldCard,
  },
  title: {
    fontFamily: fonts.serif,
    fontSize: 21,
    color: colors.ink,
  },
  location: {
    fontFamily: fonts.sans,
    fontSize: 11,
    color: colors.muted3,
    marginTop: 5,
  },
  divider: {
    height: 1,
    backgroundColor: colors.borderCard,
    marginTop: 13,
    marginBottom: 11,
  },
  foot: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  priceRow: {
    flexDirection: 'row',
    alignItems: 'baseline',
    flexShrink: 1,
  },
  price: {
    fontFamily: fonts.sans,
    fontSize: 18,
    fontWeight: '700',
    color: colors.price,
  },
  perMonth: {
    fontFamily: fonts.sans,
    fontSize: 10,
    color: colors.muted3,
  },
  area: {
    fontFamily: fonts.sans,
    fontSize: 11,
    color: colors.cardFoot,
    marginLeft: 8,
  },
});
