import React, { useEffect, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Pressable,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { useTranslation } from 'react-i18next';
import { AppText } from '../../core/components/AppText';
import { theme } from '../../core/theme';
import { PriceText } from '../../core/ui/PriceText';
import { Booking, BookingStatus } from '../../data/models/booking';
import { BookingFailure } from '../../data/repositories/bookingErrors';
import { bookingRepository } from '../../data/repositories/bookingRepository';
import { chatRepository } from '../../data/repositories/chatRepository';
import { useListingDetail } from '../listings/useListingDetail';
import { nightKey } from './bookingDates';

type Tab = 'trips' | 'requests';

const statusKeys: Record<BookingStatus, string> = {
  pending: 'bookingStatusPending',
  accepted: 'bookingStatusAccepted',
  declined: 'bookingStatusDeclined',
  cancelled: 'bookingStatusCancelled',
};

const statusColors: Record<BookingStatus, string> = {
  pending: theme.colors.terracotta,
  accepted: theme.colors.primary,
  declined: theme.colors.error,
  cancelled: theme.colors.grey,
};

function errorKeyFor(error: unknown): string {
  if (error instanceof BookingFailure) {
    switch (error.code) {
      case 'nightTaken':
        return 'bookingErrorNightTaken';
      case 'notPending':
        return 'bookingErrorNotPending';
      case 'permissionDenied':
        return 'listingErrorPermissionDenied';
      default:
        return 'bookingErrorAction';
    }
  }
  return 'bookingErrorAction';
}

function day(date: Date | null): string {
  return date === null ? '' : nightKey(date);
}

export function BookingsScreen(): React.JSX.Element {
  const { t } = useTranslation();
  const [tab, setTab] = useState<Tab>('trips');
  const [trips, setTrips] = useState<Booking[] | null>(null);
  const [requests, setRequests] = useState<Booking[] | null>(null);
  const [loadFailed, setLoadFailed] = useState(false);
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    const stopTrips = bookingRepository.watchMyTrips(setTrips, () =>
      setLoadFailed(true),
    );
    const stopRequests = bookingRepository.watchRequests(setRequests, () =>
      setLoadFailed(true),
    );
    return () => {
      stopTrips();
      stopRequests();
    };
  }, []);

  function confirm(titleKey: string, onYes: () => void): void {
    Alert.alert(t(titleKey), undefined, [
      { text: t('bookingConfirmNo'), style: 'cancel' },
      { text: t('bookingConfirmYes'), onPress: onYes },
    ]);
  }

  async function decide(
    booking: Booking,
    decision: 'accepted' | 'declined',
    title: string,
  ): Promise<void> {
    setBusy(true);
    try {
      await bookingRepository.decide(booking, decision);
      try {
        await chatRepository.sendMessage({
          listingId: booking.listingId,
          buyerId: booking.guestId,
          ownerId: booking.ownerId,
          text: t(
            decision === 'accepted'
              ? 'bookingChatAccepted'
              : 'bookingChatDeclined',
            {
              title,
              checkIn: day(booking.checkIn),
              checkOut: day(booking.checkOut),
            },
          ),
        });
      } catch {
        // The decision is saved. The chat message is only a bonus.
      }
    } catch (error) {
      Alert.alert(t(errorKeyFor(error)));
    } finally {
      setBusy(false);
    }
  }

  async function cancel(booking: Booking): Promise<void> {
    setBusy(true);
    try {
      await bookingRepository.cancel(booking);
    } catch (error) {
      Alert.alert(t(errorKeyFor(error)));
    } finally {
      setBusy(false);
    }
  }

  const data = tab === 'trips' ? trips : requests;

  let body: React.JSX.Element;
  if (loadFailed) {
    body = (
      <View style={styles.center}>
        <AppText translationKey="bookingErrorLoad" />
      </View>
    );
  } else if (data === null) {
    body = (
      <View style={styles.center}>
        <ActivityIndicator color={theme.colors.primary} />
      </View>
    );
  } else {
    body = (
      <FlatList
        data={data}
        keyExtractor={item => item.id}
        contentContainerStyle={styles.list}
        ListEmptyComponent={
          <AppText
            translationKey={
              tab === 'trips' ? 'bookingsEmptyTrips' : 'bookingsEmptyRequests'
            }
            style={styles.empty}
          />
        }
        renderItem={({ item }) => (
          <BookingCard
            booking={item}
            asOwner={tab === 'requests'}
            busy={busy}
            onAccept={title =>
              confirm('bookingConfirmAccept', () =>
                decide(item, 'accepted', title),
              )
            }
            onDecline={title =>
              confirm('bookingConfirmDecline', () =>
                decide(item, 'declined', title),
              )
            }
            onCancel={() =>
              confirm('bookingConfirmCancel', () => cancel(item))
            }
          />
        )}
      />
    );
  }

  return (
    <View style={styles.screen}>
      <View style={styles.tabs}>
        <TabButton
          labelKey="bookingsMyTrips"
          active={tab === 'trips'}
          onPress={() => setTab('trips')}
        />
        <TabButton
          labelKey="bookingsRequests"
          active={tab === 'requests'}
          onPress={() => setTab('requests')}
        />
      </View>
      {body}
    </View>
  );
}

function TabButton({
  labelKey,
  active,
  onPress,
}: {
  labelKey: string;
  active: boolean;
  onPress: () => void;
}): React.JSX.Element {
  return (
    <Pressable
      style={[styles.tab, active && styles.tabActive]}
      onPress={onPress}>
      <AppText
        translationKey={labelKey}
        style={active ? styles.tabTextActive : styles.tabText}
      />
    </Pressable>
  );
}

function BookingCard({
  booking,
  asOwner,
  busy,
  onAccept,
  onDecline,
  onCancel,
}: {
  booking: Booking;
  asOwner: boolean;
  busy: boolean;
  onAccept: (title: string) => void;
  onDecline: (title: string) => void;
  onCancel: () => void;
}): React.JSX.Element {
  const { state } = useListingDetail(booking.listingId);
  const [guestName, setGuestName] = useState<string | null>(null);
  const title =
    state.status === 'loading' ||
    state.status === 'notFound' ||
    state.status === 'error'
      ? ''
      : state.listing.title;

  useEffect(() => {
    if (!asOwner) {
      return;
    }
    let active = true;
    chatRepository
      .getUserName(booking.guestId)
      .then(name => {
        if (active) {
          setGuestName(name);
        }
      })
      .catch(() => {});
    return () => {
      active = false;
    };
  }, [asOwner, booking.guestId]);

  return (
    <View style={styles.card}>
      <View style={styles.cardHeader}>
        <Text style={styles.cardTitle} numberOfLines={1}>
          {title}
        </Text>
        <AppText
          translationKey={statusKeys[booking.status]}
          style={[styles.status, { color: statusColors[booking.status] }]}
        />
      </View>
      {asOwner && guestName !== null ? (
        <Text style={styles.line}>{guestName}</Text>
      ) : null}
      <Text style={styles.line}>
        {day(booking.checkIn)}  -  {day(booking.checkOut)}
      </Text>
      <Text style={styles.line}>
        {booking.nights} x {booking.guests}
      </Text>
      <PriceText
        price={booking.total}
        currency={booking.currency}
        period={null}
        priceStyle={styles.total}
      />
      {booking.message.length > 0 ? (
        <Text style={styles.message}>{booking.message}</Text>
      ) : null}

      <View style={styles.actions}>
        {asOwner && booking.status === 'pending' ? (
          <>
            <ActionButton
              labelKey="bookingAccept"
              disabled={busy}
              onPress={() => onAccept(title)}
            />
            <ActionButton
              labelKey="bookingDecline"
              danger
              disabled={busy}
              onPress={() => onDecline(title)}
            />
          </>
        ) : null}
        {!asOwner &&
        (booking.status === 'pending' || booking.status === 'accepted') ? (
          <ActionButton
            labelKey="bookingCancel"
            danger
            disabled={busy}
            onPress={onCancel}
          />
        ) : null}
      </View>
    </View>
  );
}

function ActionButton({
  labelKey,
  danger,
  disabled,
  onPress,
}: {
  labelKey: string;
  danger?: boolean;
  disabled: boolean;
  onPress: () => void;
}): React.JSX.Element {
  return (
    <Pressable
      style={[
        styles.action,
        danger ? styles.actionDanger : styles.actionMain,
        disabled && styles.disabled,
      ]}
      disabled={disabled}
      onPress={onPress}>
      <AppText
        translationKey={labelKey}
        style={danger ? styles.actionDangerText : styles.actionMainText}
      />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  screen: { backgroundColor: theme.colors.background, flex: 1 },
  center: {
    alignItems: 'center',
    flex: 1,
    justifyContent: 'center',
    padding: theme.spacing.lg,
  },
  tabs: {
    borderBottomColor: theme.colors.border,
    borderBottomWidth: 1,
    flexDirection: 'row',
  },
  tab: {
    alignItems: 'center',
    borderBottomColor: 'transparent',
    borderBottomWidth: 3,
    flex: 1,
    padding: theme.spacing.md,
  },
  tabActive: { borderBottomColor: theme.colors.primary },
  tabText: { color: theme.colors.grey, fontSize: theme.fontSizes.body },
  tabTextActive: {
    color: theme.colors.primary,
    fontSize: theme.fontSizes.body,
    fontWeight: '700',
  },
  list: { flexGrow: 1, gap: theme.spacing.md, padding: theme.spacing.lg },
  empty: { color: theme.colors.grey, textAlign: 'center' },
  card: {
    backgroundColor: theme.colors.white,
    borderColor: theme.colors.border,
    borderRadius: theme.radius.card,
    borderWidth: 1,
    gap: theme.spacing.xs,
    padding: theme.spacing.md,
  },
  cardHeader: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: theme.spacing.sm,
    justifyContent: 'space-between',
  },
  cardTitle: {
    color: theme.colors.navy,
    flex: 1,
    fontSize: theme.fontSizes.body,
    fontWeight: '700',
  },
  status: { fontSize: theme.fontSizes.small, fontWeight: '700' },
  line: { color: theme.colors.navy, fontSize: theme.fontSizes.body },
  total: {
    color: theme.colors.primary,
    fontSize: theme.fontSizes.body,
    fontWeight: '700',
  },
  message: { color: theme.colors.grey, fontSize: theme.fontSizes.small },
  actions: {
    flexDirection: 'row',
    gap: theme.spacing.sm,
    marginTop: theme.spacing.sm,
  },
  action: {
    alignItems: 'center',
    borderRadius: theme.radius.md,
    borderWidth: 1,
    flex: 1,
    padding: theme.spacing.sm,
  },
  actionMain: {
    backgroundColor: theme.colors.primary,
    borderColor: theme.colors.primary,
  },
  actionDanger: {
    backgroundColor: theme.colors.white,
    borderColor: theme.colors.error,
  },
  actionMainText: { color: theme.colors.white, fontWeight: '700' },
  actionDangerText: { color: theme.colors.error, fontWeight: '700' },
  disabled: { opacity: 0.4 },
});