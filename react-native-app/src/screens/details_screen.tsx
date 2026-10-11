import React from 'react';
import {
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {money} from '../core/formatters';
import {colors, fonts} from '../core/theme';
import {Listing} from '../models/listing';
import {useApp} from '../app_state';
import {useDetailsController} from '../controllers/details_controller';
import {ListingIllustration} from '../widgets/brand';
import {ArrowBackIcon} from '../widgets/icons';
import {useToast} from '../widgets/toast';

/**
 * Écran de détail d'un bien : héros + galerie + specs + carte + contact.
 * Miroir de `DetailsScreen` côté Flutter.
 */
export function DetailsScreen({
  listing,
  onBack,
  onContact,
}: {
  listing: Listing;
  onBack: () => void;
  onContact: (listing: Listing) => void;
}) {
  const app = useApp();
  const toast = useToast();
  const insets = useSafeAreaInsets();
  const c = useDetailsController(listing);
  const isFavorite = app.isFavorite(listing.id);

  const specs = [
    `${listing.area} m² de surface`,
    `${listing.rooms} chambres`,
    `${listing.baths} s. de bain`,
  ];

  return (
    <View style={styles.screen}>
      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
        {/* ——— Héros ——— */}
        <View style={styles.hero}>
          <ListingIllustration imageKey={c.selectedImageKey} style={styles.heroImage} />

          <View style={styles.heroActions}>
            <Pressable
              onPress={onBack}
              accessibilityRole="button"
              accessibilityLabel="Retour aux annonces"
              style={styles.roundButton}>
              <ArrowBackIcon size={20} color={colors.ink} />
            </Pressable>
            <Pressable
              onPress={() => {
                app.toggleFavorite(listing.id);
                toast.show(
                  app.isFavorite(listing.id)
                    ? 'Bien retiré des favoris (mode démo).'
                    : 'Bien ajouté aux favoris (mode démo).',
                );
              }}
              accessibilityRole="button"
              accessibilityLabel={
                isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris'
              }
              style={styles.roundButton}>
              <Text
                style={[
                  styles.heart,
                  {color: isFavorite ? colors.heart : colors.ink},
                ]}>
                {isFavorite ? '♥' : '♡'}
              </Text>
            </Pressable>
          </View>

          <View style={styles.counter}>
            <Text style={styles.counterText}>{c.counterLabel}</Text>
          </View>
        </View>

        {/* ——— Contenu ——— */}
        <View style={styles.body}>
          <View style={styles.badgeRow}>
            <View style={styles.badge}>
              <Text style={styles.badgeText}>
                {listing.transaction === 'vente' ? 'À vendre' : 'À louer'}
              </Text>
            </View>
            <Text style={styles.type}>{listing.type}</Text>
          </View>

          <Text style={styles.title}>{listing.title}</Text>
          <Text style={styles.location}>⌖ {listing.location}</Text>

          <View style={styles.priceRow}>
            <Text style={styles.price}>{money(listing.price)}</Text>
            {listing.transaction === 'vente' ? null : (
              <Text style={styles.perMonth}> / mois</Text>
            )}
          </View>

          {/* Pastilles de spécification. */}
          <View style={styles.specRow}>
            {specs.map(label => (
              <View key={label} style={styles.spec}>
                <Text style={styles.specText}>{label}</Text>
              </View>
            ))}
          </View>

          {/* Description. */}
          <Section title="À propos de ce bien">
            <Text style={styles.paragraph}>{listing.description}</Text>
          </Section>

          {/* Galerie. */}
          <Section title="Aperçu des visuels">
            <Text style={styles.note}>
              Illustrations temporaires pour la maquette ; les photos réelles
              seront chargées depuis Firebase Storage dans l’application.
            </Text>
            <View style={styles.gallery}>
              {c.gallery.map((imageKey, index) => (
                <Pressable
                  key={`${imageKey}-${index}`}
                  onPress={() => c.selectImage(index)}
                  accessibilityRole="button"
                  accessibilityLabel={`Afficher l’illustration ${index + 1}`}
                  style={[
                    styles.thumb,
                    index === c.selectedImage && styles.thumbSelected,
                  ]}>
                  <ListingIllustration imageKey={imageKey} style={styles.thumbImage} />
                </Pressable>
              ))}
            </View>
          </Section>

          {/* Carte. */}
          <Section title="Localisation">
            <View style={styles.mapCard}>
              <Text style={styles.mapPin}>⌖</Text>
              <Text style={styles.mapLocation}>{listing.location}</Text>
              <Text style={styles.mapNote}>
                Carte interactive dans l’application finale
              </Text>
            </View>
          </Section>
        </View>
      </ScrollView>

      {/* ——— Pied de page : prix + Contacter ——— */}
      <View
        style={[
          styles.footer,
          {paddingBottom: insets.bottom + 12},
        ]}>
        <View style={styles.footerCopy}>
          <Text style={styles.footerLabel}>Prix affiché</Text>
          <Text style={styles.footerPrice}>
            {money(listing.price)}
            {listing.transaction === 'vente' ? '' : ' / mois'}
          </Text>
        </View>
        <Pressable
          style={styles.contactButton}
          onPress={() => onContact(listing)}
          accessibilityRole="button">
          <Text style={styles.contactText}>Contacter</Text>
          <Text style={styles.contactArrow}>↗</Text>
        </Pressable>
      </View>
    </View>
  );
}

/** Titre + contenu de section. */
function Section({title, children}: {title: string; children: React.ReactNode}) {
  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>{title}</Text>
      {children}
    </View>
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
  hero: {
    height: 315,
    backgroundColor: colors.spec,
  },
  heroImage: {
    width: '100%',
    height: 315,
  },
  heroActions: {
    position: 'absolute',
    top: 18,
    left: 19,
    right: 19,
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  roundButton: {
    width: 38,
    height: 38,
    borderRadius: 19,
    backgroundColor: 'rgba(255,255,255,0.94)',
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 2,
    shadowColor: '#173B37',
    shadowOpacity: 0.18,
    shadowRadius: 8,
    shadowOffset: {width: 0, height: 3},
  },
  heart: {
    fontFamily: fonts.sans,
    fontSize: 21,
    lineHeight: 24,
  },
  counter: {
    position: 'absolute',
    right: 19,
    bottom: 20,
    backgroundColor: 'rgba(23,59,55,0.8)',
    borderRadius: 99,
    paddingHorizontal: 11,
    paddingVertical: 8,
  },
  counterText: {
    fontFamily: fonts.sans,
    fontSize: 10,
    color: '#FFFFFF',
  },
  body: {
    paddingHorizontal: 23,
    paddingTop: 22,
  },
  badgeRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  badge: {
    backgroundColor: colors.badgeBg,
    borderRadius: 5,
    paddingHorizontal: 10,
    paddingVertical: 6,
  },
  badgeText: {
    fontFamily: fonts.sans,
    fontSize: 10,
    fontWeight: '700',
    color: colors.badgeText,
  },
  type: {
    fontFamily: fonts.sans,
    fontSize: 11,
    color: '#9A8268',
    marginLeft: 10,
  },
  title: {
    fontFamily: fonts.serif,
    fontSize: 32,
    lineHeight: 35,
    color: colors.ink,
    marginTop: 14,
  },
  location: {
    fontFamily: fonts.sans,
    fontSize: 12,
    color: colors.muted2,
    marginTop: 9,
  },
  priceRow: {
    flexDirection: 'row',
    alignItems: 'baseline',
    borderBottomWidth: 1,
    borderBottomColor: colors.borderSoft,
    paddingBottom: 19,
    marginTop: 20,
  },
  price: {
    fontFamily: fonts.sans,
    fontSize: 25,
    fontWeight: '700',
    color: colors.priceStrong,
  },
  perMonth: {
    fontFamily: fonts.sans,
    fontSize: 11,
    color: colors.muted2,
    marginLeft: 4,
  },
  specRow: {
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderBottomColor: colors.borderSoft,
    paddingBottom: 22,
    marginVertical: 19,
  },
  spec: {
    flex: 1,
    marginHorizontal: 4,
    paddingVertical: 12,
    paddingHorizontal: 4,
    backgroundColor: colors.spec,
    borderRadius: 10,
    alignItems: 'center',
  },
  specText: {
    fontFamily: fonts.sans,
    fontSize: 11,
    fontWeight: '700',
    color: colors.specText,
    textAlign: 'center',
  },
  section: {
    marginTop: 24,
  },
  sectionTitle: {
    fontFamily: fonts.serif,
    fontSize: 23,
    color: colors.ink,
    marginBottom: 10,
  },
  paragraph: {
    fontFamily: fonts.sans,
    fontSize: 12,
    lineHeight: 20,
    color: '#6B7385',
  },
  note: {
    fontFamily: fonts.sans,
    fontSize: 11,
    lineHeight: 16,
    color: colors.muted2,
    marginBottom: 13,
  },
  gallery: {
    flexDirection: 'row',
  },
  thumb: {
    flex: 1,
    marginRight: 9,
    height: 76,
    borderRadius: 9,
    overflow: 'hidden',
    borderWidth: 2,
    borderColor: 'transparent',
    backgroundColor: colors.spec,
  },
  thumbSelected: {
    borderColor: colors.gold,
  },
  thumbImage: {
    width: '100%',
    height: 76,
  },
  mapCard: {
    height: 145,
    borderRadius: 12,
    backgroundColor: '#DCE2EC',
    alignItems: 'center',
    justifyContent: 'center',
  },
  mapPin: {
    fontSize: 30,
    lineHeight: 34,
    color: colors.mapText,
  },
  mapLocation: {
    fontFamily: fonts.sans,
    fontSize: 12,
    fontWeight: '700',
    color: colors.mapText,
    marginTop: 3,
  },
  mapNote: {
    fontFamily: fonts.sans,
    fontSize: 10,
    color: '#5A6B84',
    marginTop: 3,
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    paddingHorizontal: 21,
    paddingTop: 12,
    paddingBottom: 12,
    borderTopWidth: 1,
    borderTopColor: colors.borderCard,
    elevation: 12,
    shadowColor: '#143B37',
    shadowOpacity: 0.07,
    shadowRadius: 25,
    shadowOffset: {width: 0, height: -7},
  },
  footerCopy: {
    flex: 1,
  },
  footerLabel: {
    fontFamily: fonts.sans,
    fontSize: 10,
    color: colors.muted2,
  },
  footerPrice: {
    fontFamily: fonts.sans,
    fontSize: 15,
    fontWeight: '700',
    color: colors.ink,
    marginTop: 3,
  },
  contactButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.primary,
    borderRadius: 12,
    minHeight: 44,
    paddingHorizontal: 17,
  },
  contactText: {
    fontFamily: fonts.sans,
    fontSize: 13,
    fontWeight: '700',
    color: '#FFFFFF',
  },
  contactArrow: {
    fontFamily: fonts.sans,
    fontSize: 13,
    fontWeight: '700',
    color: '#FFFFFF',
    marginLeft: 10,
  },
});
