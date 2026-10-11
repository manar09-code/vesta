import React, {useMemo, useState} from 'react';
import {
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {colors, fonts} from '../core/theme';
import {Listing} from '../models/listing';
import {useApp} from '../app_state';
import {
  TRANSACTION_OPTIONS,
  TYPE_OPTIONS,
} from '../controllers/search_controller';
import {BrandLogo, Eyebrow} from '../widgets/brand';
import {ListingCard} from '../widgets/listing_card';
import {useToast} from '../widgets/toast';

/**
 * Écran liste — sert l'onglet « Explorer » (tous les biens) et
 * l'onglet « Favoris » (favoris uniquement), comme dans la maquette.
 */
export function SearchScreen({
  favoritesOnly,
  onOpenListing,
}: {
  favoritesOnly: boolean;
  onOpenListing: (listing: Listing) => void;
}) {
  const app = useApp();
  const toast = useToast();
  const insets = useSafeAreaInsets();

  const [query, setQuery] = useState('');
  const [transaction, setTransaction] = useState('all');
  const [type, setType] = useState('all');
  const [maxPriceInput, setMaxPriceInput] = useState('');
  const [filtersOpen, setFiltersOpen] = useState(false);

  const maxPrice = useMemo(() => {
    const digits = maxPriceInput.replace(/\s/g, '');
    return digits.length > 0 ? Number.parseInt(digits, 10) : null;
  }, [maxPriceInput]);

  const results = app.filteredListings({
    query,
    transaction,
    type,
    maxPrice: maxPrice !== null && Number.isNaN(maxPrice) ? null : maxPrice,
    favoritesOnly,
  });

  const noFavorites = favoritesOnly && app.favorites.length === 0;
  const countLabel = `${results.length} bien${results.length > 1 ? 's' : ''} trouvé${
    results.length > 1 ? 's' : ''
  }`;

  function toggleFavorite(listing: Listing) {
    app.toggleFavorite(listing.id);
    toast.show(
      app.isFavorite(listing.id)
        ? 'Bien retiré des favoris (mode démo).'
        : 'Bien ajouté aux favoris (mode démo).',
    );
  }

  function emptyAction() {
    if (noFavorites) {
      // « Voir les annonces » : les favoris restent l'onglet courant,
      // on remet juste les filtres à zéro (le contenu vient de l'état).
      setQuery('');
      setTransaction('all');
      setType('all');
      setMaxPriceInput('');
      return;
    }
    setQuery('');
    setTransaction('all');
    setType('all');
    setMaxPriceInput('');
  }

  return (
    <ScrollView
      style={styles.screen}
      contentContainerStyle={styles.content}
      keyboardShouldPersistTaps="handled"
      showsVerticalScrollIndicator={false}>
      {/* ——— En-tête ——— */}
      <View style={[styles.header, {paddingTop: insets.top + 34}]}>
        <View style={styles.headerTop}>
          <BrandLogo />
          <View style={styles.locationPill}>
            <Text style={styles.locationPin}>⌖</Text>
            <Text style={styles.locationText}>Tunisie</Text>
          </View>
        </View>

        <View style={styles.headerCopy}>
          <Eyebrow text="Votre prochain chapitre commence ici" />
          <Text style={[styles.title, favoritesOnly && styles.titleFavorites]}>
            {favoritesOnly ? (
              <>
                Vos biens{'\n'}
                <Text style={styles.titleAccent}>préférés.</Text>
              </>
            ) : (
              <>
                Le bon endroit{'\n'}pour{' '}
                <Text style={styles.titleAccent}>vivre mieux.</Text>
              </>
            )}
          </Text>
        </View>

        {/* ——— Recherche ——— */}
        <View style={styles.searchBox}>
          <Text style={styles.searchIcon}>⌕</Text>
          <TextInput
            style={styles.searchInput}
            value={query}
            onChangeText={setQuery}
            placeholder="Ville, quartier ou type de bien"
            placeholderTextColor={colors.placeholder}
          />
        </View>
      </View>

      <View style={styles.body}>
        {/* ——— Titre de section + Filtres ——— */}
        <View style={styles.sectionHead}>
          <View style={styles.sectionHeadCopy}>
            <Eyebrow text="Découvrez" />
            <Text style={styles.sectionTitle}>
              {favoritesOnly ? 'Mes favoris' : 'Biens à explorer'}
            </Text>
          </View>
          <Pressable
            style={styles.filterButton}
            onPress={() => setFiltersOpen(open => !open)}
            accessibilityRole="button">
            <Text style={styles.filterButtonText}>⚲ Filtres</Text>
          </Pressable>
        </View>

        {/* ——— Chips de transaction ——— */}
        <View style={styles.chips}>
          {TRANSACTION_OPTIONS.map(([label, value]) => {
            const active = transaction === value;
            return (
              <Pressable
                key={value}
                style={[styles.chip, active && styles.chipActive]}
                onPress={() => setTransaction(value)}>
                <Text style={[styles.chipText, active && styles.chipTextActive]}>
                  {label}
                </Text>
              </Pressable>
            );
          })}
        </View>

        {/* ——— Panneau de filtres ——— */}
        {filtersOpen && (
          <View style={styles.panel}>
            <View style={styles.panelRow}>
              <View style={styles.panelField}>
                <Text style={styles.label}>Type de bien</Text>
                <View style={styles.selectWrap}>
                  {TYPE_OPTIONS.map(([label, value]) => (
                    <Pressable
                      key={value}
                      onPress={() => setType(value)}
                      style={[styles.selectItem, type === value && styles.selectItemActive]}>
                      <Text
                        style={[
                          styles.selectItemText,
                          type === value && styles.selectItemTextActive,
                        ]}>
                        {label}
                      </Text>
                    </Pressable>
                  ))}
                </View>
              </View>
              <View style={[styles.panelField, styles.panelFieldRight]}>
                <Text style={styles.label}>Prix maximum (TND)</Text>
                <View style={styles.priceWrap}>
                  <TextInput
                    style={styles.priceInput}
                    value={maxPriceInput}
                    onChangeText={setMaxPriceInput}
                    placeholder="Sans limite"
                    placeholderTextColor={colors.placeholder}
                    keyboardType="number-pad"
                  />
                </View>
              </View>
            </View>
            <Pressable onPress={emptyAction} hitSlop={6}>
              <Text style={styles.resetLink}>Réinitialiser les filtres</Text>
            </Pressable>
          </View>
        )}

        {/* ——— Compteur de résultats ——— */}
        <View style={styles.resultsRow}>
          <Text style={styles.resultCount} testID="result-count">
            {countLabel}
          </Text>
          <Text style={styles.resultMention}>Choisis pour vous ✦</Text>
        </View>

        {/* ——— Cartes ——— */}
        {results.map(listing => (
          <ListingCard
            key={listing.id}
            listing={listing}
            isFavorite={app.isFavorite(listing.id)}
            onToggleFavorite={() => toggleFavorite(listing)}
            onOpen={() => onOpenListing(listing)}
          />
        ))}

        {/* ——— État vide ——— */}
        {results.length === 0 && (
          <View style={styles.empty}>
            <Text style={styles.emptyIcon}>⌕</Text>
            <Text style={styles.emptyTitle}>
              {noFavorites ? 'Aucun favori pour le moment' : 'Aucun bien trouvé'}
            </Text>
            <Text style={styles.emptyBody}>
              {noFavorites
                ? 'Enregistrez un bien avec le cœur pour le retrouver ici.'
                : 'Essayez une autre ville ou élargissez vos filtres.'}
            </Text>
            <Pressable style={styles.emptyButton} onPress={emptyAction}>
              <Text style={styles.emptyButtonText}>
                {noFavorites ? 'Voir les annonces' : 'Effacer les filtres'}
              </Text>
            </Pressable>
          </View>
        )}
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
  headerTop: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  locationPill: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(255,255,255,0.66)',
    borderRadius: 99,
    borderWidth: 1,
    borderColor: colors.borderInput,
    paddingHorizontal: 11,
    paddingVertical: 8,
  },
  locationPin: {
    fontSize: 13,
    color: colors.link,
    marginRight: 5,
  },
  locationText: {
    fontFamily: fonts.sans,
    fontSize: 11,
    fontWeight: '700',
    color: colors.ink,
  },
  headerCopy: {
    marginTop: 38,
  },
  title: {
    fontFamily: fonts.serif,
    fontSize: 37,
    lineHeight: 40,
    letterSpacing: -0.7,
    color: colors.ink,
    marginTop: 9,
  },
  titleFavorites: {
    fontSize: 32,
    lineHeight: 35,
  },
  titleAccent: {
    color: colors.goldEm,
    fontStyle: 'italic',
  },
  searchBox: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 51,
    backgroundColor: '#FFFFFF',
    borderRadius: 13,
    paddingHorizontal: 15,
    marginTop: 26,
    shadowColor: '#184239',
    shadowOpacity: 0.06,
    shadowRadius: 24,
    shadowOffset: {width: 0, height: 9},
    elevation: 3,
  },
  searchIcon: {
    fontSize: 16,
    color: colors.ink,
    marginRight: 10,
  },
  searchInput: {
    flex: 1,
    fontFamily: fonts.sans,
    fontSize: 12,
    color: colors.ink,
    paddingVertical: 0,
  },
  body: {
    paddingHorizontal: 20,
    paddingTop: 26,
  },
  sectionHead: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    justifyContent: 'space-between',
  },
  sectionHeadCopy: {
    flex: 1,
  },
  sectionTitle: {
    fontFamily: fonts.serif,
    fontSize: 25,
    color: colors.ink,
    marginTop: 3,
  },
  filterButton: {
    flexDirection: 'row',
    alignItems: 'center',
    minHeight: 38,
    paddingHorizontal: 10,
    paddingVertical: 9,
    borderWidth: 1,
    borderColor: colors.borderInput,
    borderRadius: 10,
    marginLeft: 12,
    backgroundColor: '#FFFFFF',
  },
  filterButtonText: {
    fontFamily: fonts.sans,
    fontSize: 11,
    fontWeight: '700',
    color: colors.ink,
  },
  chips: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginTop: 17,
    marginBottom: 8,
  },
  chip: {
    backgroundColor: '#FFFFFF',
    borderRadius: 100,
    borderWidth: 1,
    borderColor: colors.borderInput,
    paddingHorizontal: 12,
    paddingVertical: 9,
    marginRight: 8,
    marginBottom: 8,
  },
  chipActive: {
    backgroundColor: colors.inkSoft,
    borderColor: colors.inkSoft,
  },
  chipText: {
    fontFamily: fonts.sans,
    fontSize: 11,
    fontWeight: '700',
    color: colors.muted2,
  },
  chipTextActive: {
    color: '#FFFFFF',
  },
  panel: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    borderWidth: 1,
    borderColor: colors.borderSoft,
    padding: 15,
    marginTop: 10,
    shadowColor: '#173B37',
    shadowOpacity: 0.05,
    shadowRadius: 18,
    shadowOffset: {width: 0, height: 6},
    elevation: 2,
  },
  panelRow: {
    flexDirection: 'row',
    marginHorizontal: -4,
  },
  panelField: {
    flex: 1,
    paddingHorizontal: 4,
  },
  panelFieldRight: {
    marginLeft: 10,
  },
  label: {
    fontFamily: fonts.sans,
    fontSize: 12,
    fontWeight: '700',
    color: colors.ink,
    marginBottom: 7,
  },
  selectWrap: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  selectItem: {
    borderWidth: 1,
    borderColor: colors.borderInput,
    borderRadius: 12,
    paddingHorizontal: 8,
    paddingVertical: 8,
    marginRight: 6,
    marginBottom: 6,
    backgroundColor: '#FFFFFF',
  },
  selectItemActive: {
    backgroundColor: colors.inkSoft,
    borderColor: colors.inkSoft,
  },
  selectItemText: {
    fontFamily: fonts.sans,
    fontSize: 11,
    color: colors.ink,
  },
  selectItemTextActive: {
    color: '#FFFFFF',
    fontWeight: '700',
  },
  priceWrap: {
    borderWidth: 1,
    borderColor: colors.borderInput,
    borderRadius: 12,
    backgroundColor: '#FFFFFF',
    paddingHorizontal: 9,
    minHeight: 42,
    justifyContent: 'center',
  },
  priceInput: {
    fontFamily: fonts.sans,
    fontSize: 12,
    color: colors.ink,
    paddingVertical: 8,
  },
  resetLink: {
    fontFamily: fonts.sans,
    fontSize: 11,
    fontWeight: '700',
    color: colors.link,
    textDecorationLine: 'underline',
    marginTop: 4,
  },
  resultsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 14,
  },
  resultCount: {
    fontFamily: fonts.sans,
    fontSize: 11,
    fontWeight: '700',
    color: colors.inkSoft,
  },
  resultMention: {
    fontFamily: fonts.sans,
    fontSize: 11,
    color: colors.muted4,
  },
  empty: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    paddingHorizontal: 12,
    paddingVertical: 40,
    alignItems: 'center',
  },
  emptyIcon: {
    fontSize: 54,
    color: '#CFC9B8',
    lineHeight: 56,
  },
  emptyTitle: {
    fontFamily: fonts.serif,
    fontSize: 23,
    color: colors.ink,
    marginTop: 6,
  },
  emptyBody: {
    fontFamily: fonts.sans,
    fontSize: 12,
    color: colors.muted,
    textAlign: 'center',
    marginTop: 7,
  },
  emptyButton: {
    minHeight: 44,
    justifyContent: 'center',
    paddingHorizontal: 18,
    borderWidth: 1,
    borderColor: colors.inkSoft,
    borderRadius: 12,
    marginTop: 18,
  },
  emptyButtonText: {
    fontFamily: fonts.sans,
    fontSize: 13,
    fontWeight: '700',
    color: colors.inkSoft,
  },
});
