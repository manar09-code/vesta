import React from 'react';
import {Pressable, ScrollView, StyleSheet, Text, View} from 'react-native';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {colors, fonts} from '../core/theme';
import {ArrowBackIcon} from '../widgets/icons';

/** Une notification de démonstration. */
interface AppNotification {
  title: string;
  body: string;
  time: string;
  unread?: boolean;
}

/** Notifications de démo (sera alimentées par FCM dans la version finale). */
const demoNotifications: AppNotification[] = [
  {
    title: 'Nouveau bien à La Marsa',
    body: 'Une villa similaire à vos favoris vient d’être publiée.',
    time: 'Il y a 12 min',
    unread: true,
  },
  {
    title: 'Prix en baisse',
    body: 'Le prix de « Le Patio Bleu » a baissé de 100 TND.',
    time: 'Hier',
    unread: true,
  },
  {
    title: 'Bienvenue sur Vesta',
    body: 'Complétez votre profil pour recevoir des alertes personnalisées.',
    time: 'Cette semaine',
  },
];

/** Écran Notifications. Miroir de `NotificationsScreen` côté Flutter. */
export function NotificationsScreen({onBack}: {onBack: () => void}) {
  const insets = useSafeAreaInsets();
  return (
    <View style={styles.screen}>
      {/* ——— En-tête ——— */}
      <View style={[styles.header, {paddingTop: insets.top + 14}]}>
        <Pressable
          onPress={onBack}
          accessibilityRole="button"
          accessibilityLabel="Retour"
          hitSlop={8}
          style={styles.back}>
          <ArrowBackIcon size={20} color={colors.ink} />
        </Pressable>
        <Text style={styles.title}>Notifications</Text>
      </View>

      <ScrollView
        contentContainerStyle={styles.content}
        showsVerticalScrollIndicator={false}>
        {demoNotifications.map(notification => (
          <View
            key={notification.title}
            style={[styles.card, notification.unread && styles.cardUnread]}>
            <View
              style={[
                styles.iconWrap,
                {backgroundColor: notification.unread ? colors.badgeBg : colors.spec},
              ]}>
              <Text
                style={[
                  styles.icon,
                  {color: notification.unread ? colors.badgeText : colors.muted2},
                ]}>
                ◉
              </Text>
            </View>
            <View style={styles.cardCopy}>
              <View style={styles.cardHead}>
                <Text style={styles.cardTitle} numberOfLines={1}>
                  {notification.title}
                </Text>
                {notification.unread && <View style={styles.dot} />}
              </View>
              <Text style={styles.cardBody}>{notification.body}</Text>
              <Text style={styles.cardTime}>{notification.time}</Text>
            </View>
          </View>
        ))}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.shell,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.header,
    paddingHorizontal: 14,
    paddingTop: 14,
    paddingBottom: 14,
    borderBottomWidth: 1,
    borderBottomColor: colors.borderInput,
  },
  back: {
    paddingRight: 10,
  },
  title: {
    fontFamily: fonts.serif,
    fontSize: 22,
    color: colors.ink,
  },
  content: {
    padding: 16,
  },
  card: {
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: colors.borderCard,
    padding: 14,
    marginBottom: 10,
  },
  cardUnread: {
    backgroundColor: '#F6F1E4',
  },
  iconWrap: {
    width: 38,
    height: 38,
    borderRadius: 19,
    alignItems: 'center',
    justifyContent: 'center',
  },
  icon: {
    fontFamily: fonts.sans,
    fontSize: 15,
  },
  cardCopy: {
    flex: 1,
    marginLeft: 12,
  },
  cardHead: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  cardTitle: {
    flex: 1,
    fontFamily: fonts.sans,
    fontSize: 13,
    fontWeight: '700',
    color: colors.ink,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: colors.gold,
    marginLeft: 8,
  },
  cardBody: {
    fontFamily: fonts.sans,
    fontSize: 12,
    lineHeight: 17,
    color: colors.muted,
    marginTop: 3,
  },
  cardTime: {
    fontFamily: fonts.sans,
    fontSize: 10,
    color: colors.muted2,
    marginTop: 5,
  },
});
