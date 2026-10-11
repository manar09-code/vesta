import React from 'react';
import {ScrollView, StyleSheet, Text, View} from 'react-native';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {money} from '../core/formatters';
import {colors, fonts} from '../core/theme';
import {Listing} from '../models/listing';
import {Eyebrow, ListingIllustration} from '../widgets/brand';

/**
 * Écran Carte : les biens positionnés sur une carte stylisée.
 * La carte réelle (Google Maps) sera branchée avec la clé API ; le
 * comportement et le style restent identiques.
 */
export function MapScreen({
  listings,
  onOpen,
}: {
  listings: Listing[];
  onOpen: (listing: Listing) => void;
}) {
  const insets = useSafeAreaInsets();
  const positions: Array<[number, number]> = [
    [58, 46],
    [188, 118],
    [96, 208],
    [240, 232],
  ];

  return (
    <ScrollView
      style={styles.screen}
      contentContainerStyle={styles.content}
      showsVerticalScrollIndicator={false}>
      {/* En-tête */}
      <View style={[styles.header, {paddingTop: insets.top + 34}]}>
        <Eyebrow text="Explorer par région" />
        <Text style={styles.title}>
          La carte des{'\n'}bons plans.
        </Text>
      </View>

      {/* Carte stylisée avec pastilles des biens */}
      <View style={styles.map}>
        {listings.map((listing, index) => {
          const [left, top] = positions[index % positions.length];
          return (
            <View key={listing.id} style={[styles.pinWrap, {left, top}]}>
              <View style={styles.pinPrice}>
                <Text style={styles.pinPriceText}>{money(listing.price)}</Text>
              </View>
              <Text style={styles.pinIcon}>⌖</Text>
              <Text style={styles.pinLink} onPress={() => onOpen(listing)}>
                Voir
              </Text>
            </View>
          );
        })}
        <Text style={styles.mapNote}>
          Carte interactive dans l’application finale
        </Text>
      </View>

      {/* Liste des biens sous la carte */}
      <View style={styles.list}>
        {listings.map(listing => (
          <View key={listing.id} style={styles.tile}>
            <View style={styles.tileThumb}>
              <ListingIllustration imageKey={listing.image} style={styles.thumb} />
            </View>
            <View style={styles.tileBody}>
              <Text style={styles.tileTitle} numberOfLines={1}>
                {listing.title}
              </Text>
              <Text style={styles.tileLocation} numberOfLines={1}>
                ⌖ {listing.location}
              </Text>
            </View>
            <Text style={styles.tilePrice}>{money(listing.price)}</Text>
          </View>
        ))}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.shell,
  },
  content: {
    paddingBottom: 24,
  },
  header: {
    backgroundColor: colors.header,
    borderBottomLeftRadius: 29,
    borderBottomRightRadius: 29,
    paddingHorizontal: 23,
    paddingTop: 34,
    paddingBottom: 25,
  },
  title: {
    fontFamily: fonts.serif,
    fontSize: 32,
    lineHeight: 34,
    letterSpacing: -0.7,
    color: colors.ink,
    marginTop: 9,
  },
  map: {
    height: 320,
    marginHorizontal: 20,
    marginTop: 20,
    marginBottom: 8,
    borderRadius: 16,
    overflow: 'hidden',
    backgroundColor: '#DCE2EC',
    borderWidth: 1,
    borderColor: '#C9D2DF',
  },
  pinWrap: {
    position: 'absolute',
    alignItems: 'center',
  },
  pinPrice: {
    backgroundColor: colors.primary,
    borderRadius: 8,
    paddingHorizontal: 8,
    paddingVertical: 5,
    shadowColor: '#173B37',
    shadowOpacity: 0.2,
    shadowRadius: 8,
    shadowOffset: {width: 0, height: 3},
    elevation: 3,
  },
  pinPriceText: {
    fontFamily: fonts.sans,
    fontSize: 10,
    fontWeight: '700',
    color: '#FFFFFF',
  },
  pinIcon: {
    fontSize: 26,
    color: colors.gold,
    lineHeight: 28,
  },
  pinLink: {
    fontFamily: fonts.sans,
    fontSize: 10,
    fontWeight: '700',
    color: colors.link,
    textDecorationLine: 'underline',
  },
  mapNote: {
    position: 'absolute',
    left: 12,
    bottom: 12,
    fontFamily: fonts.sans,
    fontSize: 10,
    color: '#5A6B84',
  },
  list: {
    paddingHorizontal: 20,
    paddingTop: 12,
  },
  tile: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: colors.borderCard,
    padding: 10,
    marginBottom: 10,
  },
  tileThumb: {
    borderRadius: 10,
    overflow: 'hidden',
  },
  thumb: {
    width: 58,
    height: 58,
  },
  tileBody: {
    flex: 1,
    marginHorizontal: 12,
  },
  tileTitle: {
    fontFamily: fonts.sans,
    fontSize: 13,
    fontWeight: '700',
    color: colors.ink,
  },
  tileLocation: {
    fontFamily: fonts.sans,
    fontSize: 11,
    color: colors.muted3,
    marginTop: 2,
  },
  tilePrice: {
    fontFamily: fonts.sans,
    fontSize: 12,
    fontWeight: '700',
    color: colors.price,
    marginLeft: 8,
  },
});
