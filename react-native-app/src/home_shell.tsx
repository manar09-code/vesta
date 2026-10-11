import React, {useState} from 'react';
import {Pressable, StyleSheet, Text, View} from 'react-native';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {colors, fonts} from './core/theme';
import {useApp} from './app_state';
import {useNavigator} from './navigation';
import {MapScreen} from './screens/map_screen';
import {ProfileScreen} from './screens/profile_screen';
import {PublishScreen} from './screens/publish_screen';
import {SearchScreen} from './screens/search_screen';
import {
  CompassIcon,
  HeartIcon,
  PersonIcon,
  PinIcon,
  PlusIcon,
} from './widgets/icons';

type TabKey = 'explorer' | 'favorites' | 'publish' | 'map' | 'profile';

const TABS: Array<{key: TabKey; label: string}> = [
  {key: 'explorer', label: 'Explorer'},
  {key: 'favorites', label: 'Favoris'},
  {key: 'publish', label: 'Publier'},
  {key: 'map', label: 'Carte'},
  {key: 'profile', label: 'Compte'},
];

/**
 * Coquille de l'application : contenu + barre de navigation du bas.
 * Les onglets restent montés (comme un IndexedStack) pour préserver
 * filtres et saisies lors des changements d'onglet.
 */
export function HomeShell() {
  const app = useApp();
  const {push} = useNavigator();
  const insets = useSafeAreaInsets();
  const [active, setActive] = useState<TabKey>('explorer');

  return (
    <View style={styles.screen}>
      <View style={styles.content}>
        <View style={[styles.pane, active !== 'explorer' && styles.paneHidden]}>
          <SearchScreen
            favoritesOnly={false}
            onOpenListing={listing => push({name: 'details', listingId: listing.id})}
          />
        </View>
        <View style={[styles.pane, active !== 'favorites' && styles.paneHidden]}>
          <SearchScreen
            favoritesOnly
            onOpenListing={listing => push({name: 'details', listingId: listing.id})}
          />
        </View>
        <View style={[styles.pane, active !== 'publish' && styles.paneHidden]}>
          <PublishScreen />
        </View>
        <View style={[styles.pane, active !== 'map' && styles.paneHidden]}>
          <MapScreen
            listings={app.listings}
            onOpen={listing => push({name: 'details', listingId: listing.id})}
          />
        </View>
        <View style={[styles.pane, active !== 'profile' && styles.paneHidden]}>
          <ProfileScreen
            onOpenFavorites={() => setActive('favorites')}
            onOpenNotifications={() => push({name: 'notifications'})}
          />
        </View>
      </View>

      {/* ——— Barre de navigation ——— */}
      <View style={[styles.nav, {paddingBottom: Math.max(insets.bottom, 9)}]}>
        {TABS.map(tab => {
          const isActive = active === tab.key;
          const color = isActive ? colors.navActive : colors.navIdle;
          return (
            <Pressable
              key={tab.key}
              style={styles.navButton}
              onPress={() => setActive(tab.key)}
              accessibilityRole="tab"
              accessibilityState={{selected: isActive}}
              accessibilityLabel={tab.label}>
              <View style={styles.navIcon}>
                <TabIcon tab={tab.key} active={isActive} color={color} />
              </View>
              <Text style={[styles.navLabel, {color}]}>{tab.label}</Text>
            </Pressable>
          );
        })}
      </View>
    </View>
  );
}

/** Pictogramme de l'onglet (dessiné, sans dépendance d'icônes). */
function TabIcon({
  tab,
  active,
  color,
}: {
  tab: TabKey;
  active: boolean;
  color: string;
}) {
  switch (tab) {
    case 'explorer':
      return <CompassIcon size={24} color={color} />;
    case 'favorites':
      return <HeartIcon size={24} color={color} filled={active} />;
    case 'publish':
      return <PlusIcon size={24} color={color} />;
    case 'map':
      return <PinIcon size={24} color={color} />;
    default:
      return <PersonIcon size={24} color={color} />;
  }
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.shell,
  },
  content: {
    flex: 1,
  },
  pane: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  paneHidden: {
    display: 'none',
  },
  nav: {
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    borderTopWidth: 1,
    borderTopColor: colors.border,
    paddingHorizontal: 8,
    paddingTop: 9,
    elevation: 14,
    shadowColor: '#143B37',
    shadowOpacity: 0.06,
    shadowRadius: 30,
    shadowOffset: {width: 0, height: -6},
  },
  navButton: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: 4,
    borderRadius: 12,
  },
  navIcon: {
    height: 26,
    alignItems: 'center',
    justifyContent: 'center',
  },
  navLabel: {
    fontFamily: fonts.sans,
    fontSize: 10,
    fontWeight: '700',
    marginTop: 2,
  },
});
