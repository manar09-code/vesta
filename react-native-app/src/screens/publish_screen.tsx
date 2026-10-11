import React from 'react';
import {
  KeyboardAvoidingView,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {colors, fonts} from '../core/theme';
import {Transaction} from '../models/listing';
import {useApp} from '../app_state';
import {usePublishController} from '../controllers/publish_controller';
import {BrandLogo, Eyebrow} from '../widgets/brand';
import {useToast} from '../widgets/toast';

/**
 * Écran Publication : formulaire de mise en ligne d'une annonce.
 * Miroir de `PublishScreen` côté Flutter.
 */
export function PublishScreen() {
  const app = useApp();
  const toast = useToast();
  const c = usePublishController();
  const insets = useSafeAreaInsets();

  function submit() {
    const listing = c.validate();
    if (listing === null) {
      return;
    }
    app.publish(listing);
    c.clear();
    toast.show('Annonce publiée (mode démo) : visible dans « Explorer ».');
  }

  return (
    <KeyboardAvoidingView
      style={styles.screen}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <ScrollView
        contentContainerStyle={styles.content}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}>
        {/* En-tête. */}
        <View style={[styles.header, {paddingTop: insets.top + 34}]}>
          <BrandLogo />
          <View style={styles.headerCopy}>
            <Eyebrow text="Partagez votre bien" />
            <Text style={styles.title}>
              {'Publiez une annonce\nen quelques lignes.'}
            </Text>
          </View>
        </View>

        {/* Formulaire. */}
        <View style={styles.form}>
          <Segmented
            label="Type de transaction"
            value={c.transaction}
            options={[
              ['À vendre', 'vente'],
              ['À louer', 'location'],
            ]}
            onChange={value => c.setTransaction(value as Transaction)}
          />
          <Segmented
            label="Type de bien"
            value={c.type}
            options={[
              ['Villa', 'Villa'],
              ['Appartement', 'Appartement'],
            ]}
            onChange={c.setType}
          />

          <Field label="Titre de l’annonce">
            <TextInput
              style={styles.input}
              value={c.title}
              onChangeText={c.setTitle}
              placeholder="Ex. Villa des Oliviers"
              placeholderTextColor={colors.placeholder}
            />
          </Field>
          <Field label="Ville, quartier">
            <TextInput
              style={styles.input}
              value={c.location}
              onChangeText={c.setLocation}
              placeholder="Ex. La Marsa, Tunis"
              placeholderTextColor={colors.placeholder}
            />
          </Field>
          <Field label="Prix (TND)">
            <TextInput
              style={styles.input}
              value={c.price}
              onChangeText={c.setPrice}
              placeholder="Ex. 1250000"
              placeholderTextColor={colors.placeholder}
              keyboardType="number-pad"
            />
          </Field>

          <View style={styles.row}>
            <View style={[styles.column, styles.columnFirst]}>
              <Field label="Surface (m²)">
                <TextInput
                  style={styles.input}
                  value={c.area}
                  onChangeText={c.setArea}
                  placeholder="Ex. 240"
                  placeholderTextColor={colors.placeholder}
                  keyboardType="number-pad"
                />
              </Field>
            </View>
            <View style={[styles.column, styles.columnMiddle]}>
              <Field label="Chambres">
                <TextInput
                  style={styles.input}
                  value={c.rooms}
                  onChangeText={c.setRooms}
                  placeholder="Ex. 4"
                  placeholderTextColor={colors.placeholder}
                  keyboardType="number-pad"
                />
              </Field>
            </View>
            <View style={styles.column}>
              <Field label="S. de bain">
                <TextInput
                  style={styles.input}
                  value={c.baths}
                  onChangeText={c.setBaths}
                  placeholder="Ex. 3"
                  placeholderTextColor={colors.placeholder}
                  keyboardType="number-pad"
                />
              </Field>
            </View>
          </View>

          <Field label="Description">
            <TextInput
              style={[styles.input, styles.textarea]}
              value={c.description}
              onChangeText={c.setDescription}
              placeholder="Décrivez les atouts du bien…"
              placeholderTextColor={colors.placeholder}
              multiline
              numberOfLines={4}
              textAlignVertical="top"
            />
          </Field>

          {c.error !== null && (
            <View style={styles.errorBox}>
              <Text style={styles.errorText}>{c.error}</Text>
            </View>
          )}

          <Pressable style={styles.submit} onPress={submit} accessibilityRole="button">
            <Text style={styles.submitText}>Publier l’annonce</Text>
            <Text style={[styles.submitText, styles.submitArrow]}>→</Text>
          </Pressable>

          <Text style={styles.demoNote}>
            Mode démo : l’annonce reste sur cet appareil et disparaît au
            redémarrage.
          </Text>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

/** Groupe de boutons segmentés (transaction, type de bien). */
function Segmented({
  label,
  value,
  options,
  onChange,
}: {
  label: string;
  value: string;
  options: Array<[string, string]>;
  onChange: (value: string) => void;
}) {
  return (
    <View style={styles.field}>
      <Text style={styles.label}>{label}</Text>
      <View style={styles.segmentRow}>
        {options.map(([optionLabel, optionValue], index) => {
          const active = value === optionValue;
          return (
            <Pressable
              key={optionValue}
              onPress={() => onChange(optionValue)}
              accessibilityRole="button"
              style={[
                styles.segment,
                index === options.length - 1 && styles.segmentLast,
                active && styles.segmentActive,
              ]}>
              <Text style={[styles.segmentText, active && styles.segmentTextActive]}>
                {optionLabel}
              </Text>
            </Pressable>
          );
        })}
      </View>
    </View>
  );
}

/** Libellé + champ de saisie. */
function Field({label, children}: {label: string; children: React.ReactNode}) {
  return (
    <View style={styles.field}>
      <Text style={styles.label}>{label}</Text>
      <View style={styles.inputWrap}>{children}</View>
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
  header: {
    backgroundColor: colors.header,
    borderBottomLeftRadius: 29,
    borderBottomRightRadius: 29,
    paddingHorizontal: 23,
    paddingTop: 34,
    paddingBottom: 25,
  },
  headerCopy: {
    marginTop: 30,
  },
  title: {
    fontFamily: fonts.serif,
    fontSize: 32,
    lineHeight: 34,
    letterSpacing: -0.7,
    color: colors.ink,
    marginTop: 9,
  },
  form: {
    padding: 23,
  },
  field: {
    marginBottom: 17,
  },
  label: {
    fontFamily: fonts.sans,
    fontSize: 12,
    fontWeight: '700',
    color: colors.ink,
    marginBottom: 7,
  },
  segmentRow: {
    flexDirection: 'row',
  },
  segment: {
    flex: 1,
    height: 42,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.borderInput,
    marginRight: 10,
  },
  segmentLast: {
    marginRight: 0,
  },
  segmentActive: {
    backgroundColor: colors.inkSoft,
    borderColor: colors.inkSoft,
  },
  segmentText: {
    fontFamily: fonts.sans,
    fontSize: 12,
    fontWeight: '700',
    color: colors.ink,
  },
  segmentTextActive: {
    color: '#FFFFFF',
  },
  inputWrap: {
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.borderInput,
    paddingHorizontal: 14,
    minHeight: 48,
    justifyContent: 'center',
  },
  input: {
    fontFamily: fonts.sans,
    fontSize: 13,
    color: colors.ink,
    paddingVertical: 12,
  },
  textarea: {
    minHeight: 100,
    paddingTop: 12,
  },
  row: {
    flexDirection: 'row',
    marginHorizontal: -5,
  },
  column: {
    flex: 1,
    paddingHorizontal: 5,
  },
  columnFirst: {
    marginLeft: 0,
  },
  columnMiddle: {
    marginHorizontal: 0,
  },
  errorBox: {
    backgroundColor: colors.errorBg,
    borderRadius: 8,
    padding: 10,
    marginBottom: 14,
  },
  errorText: {
    fontFamily: fonts.sans,
    fontSize: 12,
    color: colors.errorText,
  },
  submit: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.primary,
    borderRadius: 12,
    minHeight: 48,
    paddingHorizontal: 18,
  },
  submitText: {
    fontFamily: fonts.sans,
    fontSize: 14,
    fontWeight: '700',
    color: '#FFFFFF',
  },
  submitArrow: {
    marginLeft: 14,
  },
  demoNote: {
    fontFamily: fonts.sans,
    fontSize: 11,
    lineHeight: 18,
    color: colors.muted2,
    textAlign: 'center',
    marginTop: 8,
  },
});
