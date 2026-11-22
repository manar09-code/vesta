import React, { useEffect, useMemo, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { Calendar, DateData } from 'react-native-calendars';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { useTranslation } from 'react-i18next';
import { AppText } from '../../core/components/AppText';
import { theme } from '../../core/theme';
import { PriceText } from '../../core/ui/PriceText';
import { BookingFailure } from '../../data/repositories/bookingErrors';
import { bookingRepository } from '../../data/repositories/bookingRepository';
import { MainStackParamList } from '../../navigation/MainStack';
import { useListingDetail } from '../listings/useListingDetail';
import {
  dateFromKey,
  hasBlockedNight,
  nightKey,
  nightsCount,
  nightsOf,
  totalPrice,
} from './bookingDates';

type Props = NativeStackScreenProps<MainStackParamList, 'BookingRequest'>;

type Marking = {
  disabled?: boolean;
  startingDay?: boolean;
  endingDay?: boolean;
  color?: string;
  textColor?: string;
};

const defaultMaxGuests = 30;

function errorKeyFor(error: unknown): string {
  if (error instanceof BookingFailure) {
    switch (error.code) {
      case 'ownListing':
        return 'bookingErrorOwnListing';
      case 'nightTaken':
        return 'bookingErrorNightTaken';
      case 'datesRequired':
        return 'bookingDatesRequired';
      default:
        return 'bookingErrorGeneric';
    }
  }
  return 'bookingErrorGeneric';
}

export function BookingRequestScreen({
  route,
  navigation,
}: Props): React.JSX.Element {
  const { t } = useTranslation();
  const { state, retry } = useListingDetail(route.params.listingId);
  const [blocked, setBlocked] = useState<Set<string>>(new Set());
  const [start, setStart] = useState<string | null>(null);
  const [end, setEnd] = useState<string | null>(null);
  const [guests, setGuests] = useState(1);
  const [message, setMessage] = useState('');
  const [errorKey, setErrorKey] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    let active = true;
    bookingRepository
      .getBlockedNights(route.params.listingId)
      .then(nights => {
        if (active) {
          setBlocked(nights);
        }
      })
      .catch(() => {
        if (active) {
          setErrorKey('bookingErrorGeneric');
        }
      });
    return () => {
      active = false;
    };
  }, [route.params.listingId]);

  const marked = useMemo(() => {
    const result: Record<string, Marking> = {};
    blocked.forEach(key => {
      result[key] = { disabled: true };
    });
    if (start !== null) {
      const color = theme.colors.primary;
      const textColor = theme.colors.white;
      result[start] = {
        startingDay: true,
        endingDay: end === null,
        color,
        textColor,
      };
      if (end !== null) {
        nightsOf(dateFromKey(start), dateFromKey(end)).forEach(night => {
          const key = nightKey(night);
          if (key !== start) {
            result[key] = { color, textColor };
          }
        });
        result[end] = { endingDay: true, color, textColor };
      }
    }
    return result;
  }, [blocked, start, end]);

  if (state.status === 'loading') {
    return (
      <View style={styles.center}>
        <ActivityIndicator color={theme.colors.primary} />
      </View>
    );
  }
  if (state.status === 'notFound') {
    return (
      <View style={styles.center}>
        <AppText translationKey="listingDetailNotFound" />
      </View>
    );
  }
  if (state.status === 'error') {
    return (
      <View style={styles.center}>
        <AppText translationKey="listingDetailLoadError" />
        <Pressable style={styles.button} onPress={retry}>
          <AppText translationKey="favoritesRetry" style={styles.buttonText} />
        </Pressable>
      </View>
    );
  }

  const { listing } = state;
  const maxGuests = listing.maxGuests ?? defaultMaxGuests;
  const nights =
    start !== null && end !== null
      ? nightsCount(dateFromKey(start), dateFromKey(end))
      : 0;

  function onDayPress(day: DateData): void {
    const key = day.dateString;
    setErrorKey(null);
    if (start === null || end !== null || key <= start) {
      if (blocked.has(key)) {
        setErrorKey('bookingErrorNightTaken');
        return;
      }
      setStart(key);
      setEnd(null);
      return;
    }
    setEnd(key);
    if (hasBlockedNight(dateFromKey(start), dateFromKey(key), blocked)) {
      setErrorKey('bookingErrorNightTaken');
    }
  }

  async function submit(): Promise<void> {
    if (submitting) {
      return;
    }
    if (start === null || end === null || nights < 1) {
      setErrorKey('bookingDatesRequired');
      return;
    }
    setSubmitting(true);
    setErrorKey(null);
    try {
      await bookingRepository.createBooking(listing, {
        checkIn: dateFromKey(start),
        checkOut: dateFromKey(end),
        guests,
        message,
      });
      Alert.alert(t('bookingSent'));
      navigation.goBack();
    } catch (error) {
      setErrorKey(errorKeyFor(error));
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.content}>
      <Text style={styles.title}>{listing.title}</Text>
      <Text style={styles.city}>{listing.city}</Text>

      <AppText translationKey="bookingDatesLabel" style={styles.label} />
      <Calendar
        markingType="period"
        markedDates={marked}
        minDate={nightKey(new Date())}
        onDayPress={onDayPress}
        theme={{
          calendarBackground: theme.colors.white,
          todayTextColor: theme.colors.primary,
          arrowColor: theme.colors.primary,
          textDisabledColor: theme.colors.border,
          dayTextColor: theme.colors.navy,
          monthTextColor: theme.colors.navy,
        }}
      />
      <Text style={styles.hint}>
        {start === null || end === null
          ? t('bookingDatesSelect')
          : `${start}  -  ${end}`}
      </Text>

      <AppText translationKey="bookingGuestsLabel" style={styles.label} />
      <View style={styles.guestsRow}>
        <Pressable
          style={[styles.round, guests <= 1 && styles.roundOff]}
          disabled={guests <= 1 || submitting}
          onPress={() => setGuests(guests - 1)}>
          <Text style={styles.roundText}>-</Text>
        </Pressable>
        <Text style={styles.guests}>{guests}</Text>
        <Pressable
          style={[styles.round, guests >= maxGuests && styles.roundOff]}
          disabled={guests >= maxGuests || submitting}
          onPress={() => setGuests(guests + 1)}>
          <Text style={styles.roundText}>+</Text>
        </Pressable>
        <Text style={styles.hint}>
          {t('bookingGuestsMax', { count: maxGuests })}
        </Text>
      </View>

      <AppText translationKey="bookingMessageLabel" style={styles.label} />
      <TextInput
        style={styles.input}
        value={message}
        onChangeText={setMessage}
        editable={!submitting}
        multiline
        maxLength={500}
      />

      {nights > 0 ? (
        <View style={styles.summary}>
          <SummaryRow labelKey="bookingSummaryPriceNight">
            <PriceText
              price={listing.price}
              currency={listing.currency}
              period={null}
            />
          </SummaryRow>
          <SummaryRow labelKey="bookingSummaryNights">
            <Text style={styles.value}>{nights}</Text>
          </SummaryRow>
          <SummaryRow labelKey="bookingSummaryTotal">
            <PriceText
              price={totalPrice(nights, listing.price)}
              currency={listing.currency}
              period={null}
              priceStyle={styles.total}
            />
          </SummaryRow>
        </View>
      ) : null}

      <AppText translationKey="bookingPayNote" style={styles.hint} />
      {errorKey !== null ? (
        <Text style={styles.error}>{t(errorKey)}</Text>
      ) : null}

      <Pressable
        style={[styles.button, submitting && styles.roundOff]}
        disabled={submitting}
        onPress={submit}>
        {submitting ? (
          <ActivityIndicator color={theme.colors.white} />
        ) : (
          <AppText translationKey="bookingSubmit" style={styles.buttonText} />
        )}
      </Pressable>
    </ScrollView>
  );
}

function SummaryRow({
  labelKey,
  children,
}: {
  labelKey: string;
  children: React.ReactNode;
}): React.JSX.Element {
  return (
    <View style={styles.summaryRow}>
      <AppText translationKey={labelKey} style={styles.value} />
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { backgroundColor: theme.colors.background, flex: 1 },
  content: { gap: theme.spacing.sm, padding: theme.spacing.lg },
  center: {
    alignItems: 'center',
    backgroundColor: theme.colors.background,
    flex: 1,
    gap: theme.spacing.lg,
    justifyContent: 'center',
    padding: theme.spacing.lg,
  },
  title: {
    color: theme.colors.navy,
    fontSize: theme.fontSizes.title,
    fontWeight: '700',
  },
  city: { color: theme.colors.grey, fontSize: theme.fontSizes.body },
  label: {
    color: theme.colors.navy,
    fontSize: theme.fontSizes.body,
    fontWeight: '700',
    marginTop: theme.spacing.md,
  },
  hint: { color: theme.colors.grey, fontSize: theme.fontSizes.small },
  guestsRow: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: theme.spacing.md,
  },
  guests: { color: theme.colors.navy, fontSize: theme.fontSizes.title },
  round: {
    alignItems: 'center',
    backgroundColor: theme.colors.primary,
    borderRadius: theme.radius.round,
    height: 40,
    justifyContent: 'center',
    width: 40,
  },
  roundOff: { opacity: 0.4 },
  roundText: { color: theme.colors.white, fontSize: theme.fontSizes.title },
  input: {
    backgroundColor: theme.colors.white,
    borderColor: theme.colors.border,
    borderRadius: theme.radius.field,
    borderWidth: 1,
    color: theme.colors.navy,
    fontSize: theme.fontSizes.body,
    minHeight: 80,
    padding: theme.spacing.sm,
    textAlignVertical: 'top',
  },
  summary: {
    backgroundColor: theme.colors.sand,
    borderRadius: theme.radius.md,
    gap: theme.spacing.xs,
    marginTop: theme.spacing.md,
    padding: theme.spacing.md,
  },
  summaryRow: {
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  value: { color: theme.colors.navy, fontSize: theme.fontSizes.body },
  total: {
    color: theme.colors.primary,
    fontSize: theme.fontSizes.body,
    fontWeight: '700',
  },
  error: { color: theme.colors.error, fontSize: theme.fontSizes.body },
  button: {
    alignItems: 'center',
    backgroundColor: theme.colors.primary,
    borderRadius: theme.radius.md,
    marginTop: theme.spacing.md,
    padding: theme.spacing.md,
  },
  buttonText: {
    color: theme.colors.white,
    fontSize: theme.fontSizes.body,
    fontWeight: '700',
  },
});
