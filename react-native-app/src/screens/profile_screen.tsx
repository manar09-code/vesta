import React from 'react';
import {Pressable, ScrollView, StyleSheet, Text, View} from 'react-native';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {colors, fonts} from '../core/theme';
import {useApp} from '../app_state';
import {BrandLogo} from '../widgets/brand';
import {useToast} from '../widgets/toast';

/**
 * Écran Compte : identité, raccourcis et déconnexion.
 * Miroir de `ProfileScreen` côté Flutter.
 */
export function ProfileScreen({
  onOpenFavorites,
  onOpenNotifications,
}: {
  onOpenFavorites: () => void;
  onOpenNotifications: () => void;
}) {
  const app = useApp();
  const toast = useToast();
  const insets = useSafeAreaInsets();

  const name = app.userName ?? 'Visiteur Vesta';
  const email = app.userEmail ?? 'visiteur@vesta.tn';
  const initial = name.length > 0 ? name[0].toUpperCase() : 'V';

  return (
    <ScrollView
      style={styles.screen}
      contentContainerStyle={styles.content}
      showsVerticalScrollIndicator={false}>
      {/* ——— En-tête ——— */}
      <View style={[styles.header, {paddingTop: insets.top + 34}]}>
        <BrandLogo />
        <View style={styles.identity}>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>{initial}</Text>
          </View>
          <View style={styles.identityCopy}>
            <Text style={styles.name}>{name}</Text>
            <Text style={styles.email}>{email}</Text>
          </View>
        </View>

        <View style={styles.stats}>
          <View style={styles.stat}>
            <Text style={styles.statValue}>{app.favorites.length}</Text>
            <Text style={styles.statLabel}>Favoris</Text>
          </View>
          <View style={styles.statSpacer} />
          <View style={styles.stat}>
            <Text style={styles.statValue}>{app.listings.length}</Text>
            <Text style={styles.statLabel}>Annonces</Text>
          </View>
          <View style={styles.statSpacer} />
          <View style={styles.stat}>
            <Text style={styles.statValue}>Tunis</Text>
            <Text style={styles.statLabel}>Ville</Text>
          </View>
        </View>
      </View>

      {/* ——— Menu ——— */}
      <View style={styles.menu}>
        <MenuTile icon="♡" label="Mes favoris" onPress={onOpenFavorites} />
        <MenuTile icon="◉" label="Notifications" onPress={onOpenNotifications} />
        <MenuTile
          icon="✎"
          label="Conditions et aide"
          onPress={() => toast.show('Aide : voir docs/mockups/README.md (mode démo).')}
        />
        <View style={styles.menuGap} />
        <MenuTile
          icon="⇄"
          label="Se déconnecter"
          danger
          onPress={() => {
            app.signOut();
            toast.show('Vous êtes déconnecté (mode démo).');
          }}
        />
        <View style={styles.menuGap} />
        <Text style={styles.footer}>Vesta — version React Native · prototype sans Firebase</Text>
      </View>
    </ScrollView>
  );
}

/** Ligne de menu du profil. */
function MenuTile({
  icon,
  label,
  onPress,
  danger = false,
}: {
  icon: string;
  label: string;
  onPress: () => void;
  danger?: boolean;
}) {
  const color = danger ? colors.errorText : colors.ink;
  return (
    <Pressable
      onPress={onPress}
      accessibilityRole="button"
      style={({pressed}) => [
        styles.tile,
        pressed && styles.tilePressed,
        danger && !pressed && styles.tileDanger,
      ]}>
      <Text style={[styles.tileIcon, {color}]}>{icon}</Text>
      <Text style={[styles.tileLabel, {color}]}>{label}</Text>
      <Text style={[styles.tileChevron, {color: danger ? colors.errorText : colors.muted2}]}>
        ›
      </Text>
    </Pressable>
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
    paddingBottom: 30,
  },
  identity: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 30,
  },
  avatar: {
    width: 64,
    height: 64,
    borderRadius: 32,
    backgroundColor: colors.gold,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    fontFamily: fonts.serif,
    fontSize: 28,
    color: colors.ink,
  },
  identityCopy: {
    flex: 1,
    marginLeft: 14,
  },
  name: {
    fontFamily: fonts.serif,
    fontSize: 24,
    color: colors.ink,
  },
  email: {
    fontFamily: fonts.sans,
    fontSize: 12,
    color: colors.muted,
    marginTop: 2,
  },
  stats: {
    flexDirection: 'row',
    marginTop: 18,
  },
  stat: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: colors.borderCard,
    paddingVertical: 12,
    alignItems: 'center',
  },
  statSpacer: {
    width: 10,
  },
  statValue: {
    fontFamily: fonts.sans,
    fontSize: 16,
    fontWeight: '700',
    color: colors.inkSoft,
  },
  statLabel: {
    fontFamily: fonts.sans,
    fontSize: 10,
    color: colors.muted2,
    marginTop: 2,
  },
  menu: {
    padding: 20,
  },
  tile: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: colors.borderCard,
    paddingHorizontal: 14,
    minHeight: 56,
    marginBottom: 10,
  },
  tilePressed: {
    backgroundColor: '#F2EDE1',
  },
  tileDanger: {
    backgroundColor: '#FFFFFF',
  },
  tileIcon: {
    fontFamily: fonts.sans,
    fontSize: 16,
    width: 26,
  },
  tileLabel: {
    flex: 1,
    fontFamily: fonts.sans,
    fontSize: 13,
    fontWeight: '700',
    marginLeft: 4,
  },
  tileChevron: {
    fontFamily: fonts.sans,
    fontSize: 20,
  },
  menuGap: {
    height: 10,
  },
  footer: {
    fontFamily: fonts.sans,
    fontSize: 11,
    color: colors.muted2,
    textAlign: 'center',
    marginTop: 8,
  },
});
