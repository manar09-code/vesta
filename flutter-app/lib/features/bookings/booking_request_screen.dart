import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/price_text.dart';
import '../../l10n/generated/app_localizations.dart';
import '../listings/listing.dart';
import 'booking_dates.dart';

/// What the guest typed, ready to be saved.
class BookingDraft {
  const BookingDraft({
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.message,
    required this.nights,
    required this.total,
  });

  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final String message;
  final int nights;
  final num total;
}

/// Request to book a stay (VST-92). It does not write to Firestore itself:
/// [onSubmit] does, so the screen can be tested alone.
/// [blockedKeys] are the `yyyy-MM-dd` keys of `blockedNights`.
class BookingRequestScreen extends StatefulWidget {
  const BookingRequestScreen({
    super.key,
    required this.listing,
    required this.onSubmit,
    this.blockedKeys = const {},
  });

  final Listing listing;
  final Future<void> Function(BookingDraft draft) onSubmit;
  final Set<String> blockedKeys;

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  static const _defaultMaxGuests = 30;

  DateTimeRange? _range;
  int _guests = 1;
  final _message = TextEditingController();
  String? _error;
  bool _submitting = false;

  int get _maxGuests => widget.listing.maxGuests?.toInt() ?? _defaultMaxGuests;

  int get _nights =>
      _range == null ? 0 : nightsCount(_range!.start, _range!.end);

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  /// Date in the language of the app, always with Latin digits (0-9).
  String _date(DateTime d) {
    final text = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).format(d);
    return text.replaceAllMapped(
      RegExp('[\u0660-\u0669]'),
      (m) => String.fromCharCode(m[0]!.codeUnitAt(0) - 0x0660 + 0x30),
    );
  }

  Future<void> _pickDates() async {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final first = DateTime(now.year, now.month, now.day);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: first,
      lastDate: DateTime(first.year + 2, first.month, first.day),
      initialDateRange: _range,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _range = picked;
      _error = hasBlockedNight(picked.start, picked.end, widget.blockedKeys)
          ? l10n.bookingErrorNightTaken
          : null;
    });
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final l10n = AppLocalizations.of(context);
    final range = _range;
    if (range == null || _nights < 1) {
      setState(() => _error = l10n.bookingDatesRequired);
      return;
    }
    if (hasBlockedNight(range.start, range.end, widget.blockedKeys)) {
      setState(() => _error = l10n.bookingErrorNightTaken);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.onSubmit(
        BookingDraft(
          checkIn: range.start,
          checkOut: range.end,
          guests: _guests,
          message: _message.text.trim(),
          nights: _nights,
          total: totalPrice(_nights, widget.listing.price),
        ),
      );
    } catch (_) {
      if (mounted) setState(() => _error = l10n.bookingErrorGeneric);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final listing = widget.listing;
    final range = _range;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookingRequestTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(listing.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            listing.city,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.bookingDatesLabel, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _submitting ? null : _pickDates,
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(
              range == null
                  ? l10n.bookingDatesSelect
                  : '${_date(range.start)}  -  ${_date(range.end)}',
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.bookingGuestsLabel, style: theme.textTheme.titleSmall),
          Row(
            children: [
              IconButton(
                onPressed: _guests > 1 && !_submitting
                    ? () => setState(() => _guests--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_guests', style: theme.textTheme.titleMedium),
              IconButton(
                onPressed: _guests < _maxGuests && !_submitting
                    ? () => setState(() => _guests++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.bookingGuestsMax(_maxGuests),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _message,
            enabled: !_submitting,
            maxLines: 3,
            maxLength: 500,
            decoration: InputDecoration(
              labelText: l10n.bookingMessageLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          if (_nights > 0) ...[
            const SizedBox(height: 12),
            _SummaryRow(
              label: l10n.bookingSummaryPriceNight,
              value: PriceText(
                price: listing.price,
                currency: listing.currency,
              ),
            ),
            _SummaryRow(
              label: l10n.bookingSummaryNights,
              value: Text('$_nights'),
            ),
            _SummaryRow(
              label: l10n.bookingSummaryTotal,
              value: PriceText(
                price: totalPrice(_nights, listing.price),
                currency: listing.currency,
                priceStyle: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            l10n.bookingPayNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.bookingSubmit),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), value],
      ),
    );
  }
}