import React, {useState} from 'react';
import {
  ActivityIndicator,
  Image,
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
import {useApp, useServices} from '../app_state';
import {BrandLogo, Eyebrow} from '../widgets/brand';
import {LockIcon, MailIcon, UserIcon} from '../widgets/icons';
import {useToast} from '../widgets/toast';

const VILLA = require('../../assets/images/villa.png');

/**
 * Écran Connexion / Inscription — refonte navy + or + crème :
 * héros de marque avec photo en arche, panneau crème, onglets segmentés,
 * champs à icône, CTA doré et connexion Google (démo).
 * Miroir de `AuthScreen` côté Flutter.
 */
export function AuthScreen() {
  const app = useApp();
  const {auth} = useServices();
  const toast = useToast();
  const insets = useSafeAreaInsets();

  const [signupTab, setSignupTab] = useState(false);
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirm, setConfirm] = useState('');
  const [obscure, setObscure] = useState(true);
  const [obscureConfirm, setObscureConfirm] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function submit() {
    if (loading) {
      return;
    }
    setLoading(true);
    setError(null);
    const result = signupTab
      ? await auth.signUp(name, email, password, confirm)
      : await auth.signIn(email, password);
    setLoading(false);
    if (result.error !== null) {
      setError(result.error);
      return;
    }
    app.signIn(email, name);
    toast.show('Mode démo : navigation uniquement, aucune donnée enregistrée.');
  }

  function enterWithoutAccount() {
    app.signIn('visiteur@vesta.tn');
    toast.show('Mode démo : navigation uniquement, aucune donnée enregistrée.');
  }

  return (
    <KeyboardAvoidingView
      style={styles.screen}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <ScrollView
        contentContainerStyle={styles.scroll}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}>
        {/* ————————————— Héros ————————————— */}
        <View style={[styles.hero, {paddingTop: insets.top + 30}]}>
          <View style={styles.heroGlow} />

          {/* Photo en arche, liseré doré en retrait. */}
          <View style={styles.photoOutline} />
          <View style={styles.photo}>
            <Image source={VILLA} style={styles.photoImage} resizeMode="cover" />
          </View>

          <BrandLogo light size={30} />

          <View style={styles.heroCopy}>
            <Eyebrow text="Votre prochain chez-vous" color={colors.eyebrowOnDark} />
            <Text style={styles.heroTitle}>
              {'Un lieu à vous, '}
              <Text style={styles.heroEm}>une</Text>
              {' histoire à écrire.'}
            </Text>
          </View>
        </View>

        {/* ————————————— Panneau crème ————————————— */}
        <View style={styles.sheet}>
          <View style={[styles.wave, styles.waveRight]} />
          <View style={[styles.wave, styles.waveLeft]} />
          <LeafBranch />

          <View style={styles.sheetContent}>
            <Eyebrow text="Bienvenue sur Vesta" />
            <Text style={styles.title}>Trouvez votre place.</Text>
            <Text style={styles.subtitle}>
              {'Explorez les biens qui vous ressemblent,\npartout en Tunisie.'}
            </Text>

            {/* Onglets segmentés. */}
            <View style={styles.track}>
              <Pressable
                style={[styles.segment, !signupTab && styles.segmentActive]}
                onPress={() => {
                  setSignupTab(false);
                  setError(null);
                }}
                accessibilityRole="tab"
                accessibilityState={{selected: !signupTab}}>
                <Text style={[styles.segmentText, !signupTab && styles.segmentTextActive]}>
                  CONNEXION
                </Text>
              </Pressable>
              <Pressable
                style={[styles.segment, signupTab && styles.segmentActive]}
                onPress={() => {
                  setSignupTab(true);
                  setError(null);
                }}
                accessibilityRole="tab"
                accessibilityState={{selected: signupTab}}>
                <Text style={[styles.segmentText, signupTab && styles.segmentTextActive]}>
                  INSCRIPTION
                </Text>
              </Pressable>
            </View>

            {/* Formulaire. */}
            <View style={styles.form}>
              {signupTab && (
                <Field
                  label="Nom complet"
                  icon={<UserIcon size={19} color={colors.muted2} />}
                  value={name}
                  onChangeText={setName}
                  placeholder="Votre nom"
                  autoCapitalize="words"
                />
              )}

              <Field
                label="Adresse e-mail"
                icon={<MailIcon size={19} color={colors.muted2} />}
                value={email}
                onChangeText={setEmail}
                placeholder="nom@exemple.com"
                keyboardType="email-address"
                autoCapitalize="none"
              />

              <Field
                label="Mot de passe"
                icon={<LockIcon size={19} color={colors.muted2} />}
                value={password}
                onChangeText={setPassword}
                placeholder={signupTab ? '6 caractères minimum' : 'Votre mot de passe'}
                secureTextEntry={obscure}
                onToggleSecure={() => setObscure(v => !v)}
                toggleLabel={obscure ? 'AFFICHER' : 'MASQUER'}
              />

              {signupTab && (
                <Field
                  label="Confirmer le mot de passe"
                  icon={<LockIcon size={19} color={colors.muted2} />}
                  value={confirm}
                  onChangeText={setConfirm}
                  placeholder="Répétez le mot de passe"
                  secureTextEntry={obscureConfirm}
                  onToggleSecure={() => setObscureConfirm(v => !v)}
                  toggleLabel={obscureConfirm ? 'AFFICHER' : 'MASQUER'}
                />
              )}

              {error !== null && (
                <View style={styles.errorBox}>
                  <Text style={styles.errorText}>{error}</Text>
                </View>
              )}

              {/* CTA doré. */}
              <Pressable
                style={[styles.submit, loading && styles.submitDisabled]}
                onPress={submit}
                disabled={loading}
                accessibilityRole="button">
                {loading ? (
                  <ActivityIndicator color="#FFFFFF" />
                ) : (
                  <>
                    <Text style={styles.submitText}>
                      {signupTab ? 'CRÉER MON COMPTE' : 'SE CONNECTER'}
                    </Text>
                    <Text style={styles.submitArrow}>→</Text>
                  </>
                )}
              </Pressable>

              {/* Séparateur OU. */}
              <View style={styles.orRow}>
                <View style={styles.orLine} />
                <Text style={styles.orText}>OU</Text>
                <View style={styles.orLine} />
              </View>

              {/* Google (démo). */}
              <Pressable
                style={styles.google}
                onPress={() =>
                  toast.show('Connexion Google : prototype de navigation uniquement.')
                }
                accessibilityRole="button">
                <View style={styles.googleMark}>
                  <Text style={styles.googleLetter}>G</Text>
                </View>
                <Text style={styles.googleText}>Se connecter avec Google</Text>
              </Pressable>

              <Text style={styles.demoNote}>
                Prototype de navigation uniquement : aucun compte n’est créé.
              </Text>
              <Pressable onPress={enterWithoutAccount} accessibilityRole="button">
                <Text style={styles.demoLink}>Explorer sans compte</Text>
              </Pressable>
            </View>
          </View>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

/** Champ : libellé capitales, boîte blanche, icône et bascule de visibilité. */
function Field({
  label,
  icon,
  value,
  onChangeText,
  placeholder,
  keyboardType,
  autoCapitalize,
  secureTextEntry,
  onToggleSecure,
  toggleLabel,
}: {
  label: string;
  icon: React.ReactNode;
  value: string;
  onChangeText: (text: string) => void;
  placeholder?: string;
  keyboardType?: 'email-address' | 'default' | 'number-pad';
  autoCapitalize?: 'none' | 'words';
  secureTextEntry?: boolean;
  onToggleSecure?: () => void;
  toggleLabel?: string;
}) {
  return (
    <View style={styles.field}>
      <Text style={styles.label}>{label.toUpperCase()}</Text>
      <View style={styles.inputWrap}>
        <View style={styles.inputIcon}>{icon}</View>
        <TextInput
          style={styles.input}
          value={value}
          onChangeText={onChangeText}
          placeholder={placeholder}
          placeholderTextColor={colors.placeholder}
          keyboardType={keyboardType}
          autoCapitalize={autoCapitalize}
          autoCorrect={false}
          secureTextEntry={secureTextEntry}
        />
        {onToggleSecure && (
          <Pressable onPress={onToggleSecure} hitSlop={8}>
            <Text style={styles.toggleText}>{toggleLabel}</Text>
          </Pressable>
        )}
      </View>
    </View>
  );
}

/** Branche de feuilles navy (décor de bas de page). */
function LeafBranch() {
  const leaves = [
    {left: 2, bottom: 8, rotate: '32deg'},
    {left: 20, bottom: 20, rotate: '32deg'},
    {left: 6, bottom: 36, rotate: '-28deg'},
    {left: 32, bottom: 44, rotate: '32deg'},
    {left: 22, bottom: 62, rotate: '-28deg'},
    {left: 46, bottom: 70, rotate: '32deg'},
  ];
  return (
    <View style={styles.branch} pointerEvents="none">
      <View style={styles.branchStem} />
      {leaves.map((leaf, index) => (
        <View
          key={index}
          style={[
            styles.branchLeaf,
            {left: leaf.left, bottom: leaf.bottom, transform: [{rotate: leaf.rotate}]},
          ]}
        />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.sheet,
  },
  scroll: {
    paddingBottom: 40,
  },

  // ——— Héros ———
  hero: {
    position: 'relative',
    backgroundColor: colors.authTop3,
    paddingHorizontal: 24,
    paddingBottom: 76,
    minHeight: 372,
    justifyContent: 'flex-start',
  },
  heroGlow: {
    position: 'absolute',
    top: -120,
    right: -60,
    width: 320,
    height: 320,
    borderRadius: 160,
    backgroundColor: colors.authTop1,
    opacity: 0.75,
  },
  photoOutline: {
    position: 'absolute',
    right: -58,
    top: -34,
    width: 288,
    height: 348,
    borderWidth: 1.5,
    borderColor: colors.goldEm,
    borderTopLeftRadius: 144,
    borderBottomLeftRadius: 144,
    borderRightWidth: 0,
  },
  photo: {
    position: 'absolute',
    right: -44,
    top: -22,
    width: 262,
    height: 330,
    backgroundColor: colors.heroPhoto,
    borderTopLeftRadius: 131,
    borderBottomLeftRadius: 131,
    overflow: 'hidden',
  },
  photoImage: {
    width: '100%',
    height: '100%',
  },
  heroCopy: {
    marginTop: 40,
    width: '62%',
  },
  heroTitle: {
    fontFamily: fonts.serif,
    fontSize: 37,
    lineHeight: 41,
    color: '#FFFFFF',
    marginTop: 12,
  },
  heroEm: {
    color: colors.goldEm,
    fontStyle: 'italic',
  },

  // ——— Panneau crème ———
  sheet: {
    position: 'relative',
    marginTop: -30,
    backgroundColor: colors.sheet,
    borderTopLeftRadius: 36,
    borderTopRightRadius: 36,
    paddingHorizontal: 26,
    paddingTop: 34,
    paddingBottom: 34,
    overflow: 'hidden',
  },
  sheetContent: {
    position: 'relative',
  },
  wave: {
    position: 'absolute',
    borderRadius: 999,
  },
  waveRight: {
    right: -70,
    bottom: -78,
    width: 300,
    height: 170,
    backgroundColor: colors.wave,
  },
  waveLeft: {
    left: -80,
    bottom: -96,
    width: 250,
    height: 150,
    backgroundColor: '#F6EEDC',
  },
  branch: {
    position: 'absolute',
    left: -6,
    bottom: 6,
    width: 74,
    height: 96,
  },
  branchStem: {
    position: 'absolute',
    left: 16,
    bottom: 4,
    width: 2.5,
    height: 92,
    borderRadius: 2,
    backgroundColor: colors.ink,
    transform: [{rotate: '26deg'}],
  },
  branchLeaf: {
    position: 'absolute',
    width: 26,
    height: 11,
    borderRadius: 99,
    backgroundColor: colors.ink,
  },

  title: {
    fontFamily: fonts.serif,
    fontSize: 31,
    lineHeight: 34,
    color: colors.ink,
    marginTop: 8,
  },
  subtitle: {
    fontFamily: fonts.sans,
    fontSize: 13.5,
    lineHeight: 20,
    color: colors.muted,
    marginTop: 8,
  },

  // ——— Onglets segmentés ———
  track: {
    flexDirection: 'row',
    height: 56,
    backgroundColor: colors.sheetTrack,
    borderRadius: 28,
    padding: 4,
    marginTop: 22,
  },
  segment: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 24,
  },
  segmentActive: {
    backgroundColor: colors.primary,
  },
  segmentText: {
    fontFamily: fonts.sans,
    fontSize: 13,
    fontWeight: '700',
    letterSpacing: 1.6,
    color: colors.muted2,
  },
  segmentTextActive: {
    color: '#FFFFFF',
  },

  // ——— Formulaire ———
  form: {
    marginTop: 24,
  },
  field: {
    marginBottom: 18,
  },
  label: {
    fontFamily: fonts.sans,
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 1.3,
    color: colors.ink,
    marginBottom: 9,
  },
  inputWrap: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 54,
    backgroundColor: '#FFFFFF',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: colors.borderInput,
    paddingHorizontal: 14,
  },
  inputIcon: {
    marginRight: 11,
  },
  input: {
    flex: 1,
    fontFamily: fonts.sans,
    fontSize: 13.5,
    color: colors.ink,
    paddingVertical: 0,
  },
  toggleText: {
    fontFamily: fonts.sans,
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 1,
    color: colors.ink,
    marginLeft: 10,
  },
  errorBox: {
    backgroundColor: colors.errorBg,
    borderRadius: 10,
    padding: 10,
    marginBottom: 14,
  },
  errorText: {
    fontFamily: fonts.sans,
    fontSize: 12,
    color: colors.errorText,
  },

  // ——— CTA ———
  submit: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    height: 54,
    backgroundColor: colors.gold,
    borderRadius: 14,
  },
  submitDisabled: {
    opacity: 0.6,
  },
  submitText: {
    fontFamily: fonts.sans,
    fontSize: 14,
    fontWeight: '700',
    letterSpacing: 1.6,
    color: '#FFFFFF',
  },
  submitArrow: {
    fontFamily: fonts.sans,
    fontSize: 15,
    fontWeight: '700',
    color: '#FFFFFF',
    marginLeft: 14,
  },

  // ——— OU / Google ———
  orRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 22,
    marginBottom: 16,
  },
  orLine: {
    flex: 1,
    height: 1,
    backgroundColor: colors.borderInput,
  },
  orText: {
    fontFamily: fonts.sans,
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 1.5,
    color: colors.muted2,
    marginHorizontal: 14,
  },
  google: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    height: 54,
    backgroundColor: '#FFFFFF',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: colors.borderInput,
  },
  googleMark: {
    width: 26,
    height: 26,
    borderRadius: 13,
    borderWidth: 1,
    borderColor: colors.borderInput,
    backgroundColor: '#FFFFFF',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  googleLetter: {
    fontFamily: fonts.sans,
    fontSize: 14,
    fontWeight: '700',
    color: '#4285F4',
    lineHeight: 16,
  },
  googleText: {
    fontFamily: fonts.sans,
    fontSize: 14,
    fontWeight: '600',
    color: colors.ink,
    flexShrink: 1,
  },

  demoNote: {
    fontFamily: fonts.sans,
    fontSize: 11.5,
    lineHeight: 18,
    color: colors.muted2,
    textAlign: 'center',
    marginTop: 20,
  },
  demoLink: {
    fontFamily: fonts.sans,
    fontSize: 13,
    fontWeight: '700',
    color: colors.ink,
    textDecorationLine: 'underline',
    textAlign: 'center',
    marginTop: 6,
  },
});
