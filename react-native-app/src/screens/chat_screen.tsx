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
import {Listing} from '../models/listing';
import {useServices} from '../app_state';
import {useChatController} from '../controllers/chat_controller';
import {ListingIllustration} from '../widgets/brand';
import {ArrowBackIcon, SendIcon} from '../widgets/icons';

/**
 * Messagerie avec le propriétaire d'un bien (démo : réponses automatiques).
 * Miroir de `ChatScreen` côté Flutter.
 */
export function ChatScreen({
  listing,
  onBack,
}: {
  listing: Listing;
  onBack: () => void;
}) {
  const {chat} = useServices();
  const insets = useSafeAreaInsets();
  const c = useChatController(message => chat.replyTo(message));

  return (
    <KeyboardAvoidingView
      style={styles.screen}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
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
        <View style={styles.headerThumb}>
          <ListingIllustration imageKey={listing.image} style={styles.thumb} />
        </View>
        <View style={styles.headerCopy}>
          <Text style={styles.headerTitle} numberOfLines={1}>
            {listing.title}
          </Text>
          <Text style={styles.headerLocation} numberOfLines={1}>
            {listing.location}
          </Text>
        </View>
      </View>

      {/* ——— Messages ——— */}
      <ScrollView
        style={styles.thread}
        contentContainerStyle={styles.threadContent}
        showsVerticalScrollIndicator={false}>
        {c.messages.map(message => (
          <View
            key={message.id}
            style={[
              styles.bubbleRow,
              message.fromMe ? styles.bubbleRowMine : styles.bubbleRowTheirs,
            ]}>
            <View
              style={[
                styles.bubble,
                message.fromMe ? styles.bubbleMine : styles.bubbleTheirs,
              ]}>
              <Text style={[styles.bubbleText, message.fromMe && styles.bubbleTextMine]}>
                {message.text}
              </Text>
            </View>
          </View>
        ))}
        {c.sending && (
          <View style={styles.bubbleRowTheirs}>
            <View style={[styles.bubble, styles.bubbleTheirs]}>
              <Text style={styles.bubbleText}>…</Text>
            </View>
          </View>
        )}
      </ScrollView>

      {/* ——— Saisie ——— */}
      <View style={styles.composer}>
        <TextInput
          style={styles.input}
          value={c.input}
          onChangeText={c.setInput}
          placeholder="Votre message…"
          placeholderTextColor={colors.placeholder}
          returnKeyType="send"
          onSubmitEditing={() => c.send()}
        />
        <Pressable
          style={[styles.sendButton, !c.canSend && styles.sendDisabled]}
          onPress={() => c.send()}
          disabled={!c.canSend}
          accessibilityRole="button"
          accessibilityLabel="Envoyer">
          <SendIcon size={18} color={c.canSend ? '#FFFFFF' : colors.muted2} />
        </Pressable>
      </View>
    </KeyboardAvoidingView>
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
  headerThumb: {
    borderRadius: 8,
    overflow: 'hidden',
    backgroundColor: colors.spec,
  },
  thumb: {
    width: 38,
    height: 38,
  },
  headerCopy: {
    flex: 1,
    marginLeft: 10,
  },
  headerTitle: {
    fontFamily: fonts.sans,
    fontSize: 13,
    fontWeight: '700',
    color: colors.ink,
  },
  headerLocation: {
    fontFamily: fonts.sans,
    fontSize: 10,
    color: colors.muted2,
    marginTop: 2,
  },
  thread: {
    flex: 1,
  },
  threadContent: {
    padding: 16,
  },
  bubbleRow: {
    flexDirection: 'row',
    marginBottom: 10,
  },
  bubbleRowMine: {
    justifyContent: 'flex-end',
  },
  bubbleRowTheirs: {
    justifyContent: 'flex-start',
  },
  bubble: {
    maxWidth: '78%',
    paddingHorizontal: 14,
    paddingVertical: 10,
  },
  bubbleMine: {
    backgroundColor: colors.primary,
    borderTopLeftRadius: 14,
    borderTopRightRadius: 14,
    borderBottomLeftRadius: 14,
    borderBottomRightRadius: 3,
  },
  bubbleTheirs: {
    backgroundColor: '#FFFFFF',
    borderWidth: 1,
    borderColor: colors.borderCard,
    borderTopLeftRadius: 14,
    borderTopRightRadius: 14,
    borderBottomLeftRadius: 3,
    borderBottomRightRadius: 14,
  },
  bubbleText: {
    fontFamily: fonts.sans,
    fontSize: 12.5,
    lineHeight: 18,
    color: colors.ink,
  },
  bubbleTextMine: {
    color: '#FFFFFF',
  },
  composer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    borderTopWidth: 1,
    borderTopColor: colors.border,
    paddingHorizontal: 16,
    paddingVertical: 10,
  },
  input: {
    flex: 1,
    fontFamily: fonts.sans,
    fontSize: 13,
    color: colors.ink,
    backgroundColor: colors.shell,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.borderInput,
    paddingHorizontal: 14,
    paddingVertical: 10,
    marginRight: 10,
  },
  sendButton: {
    width: 48,
    height: 48,
    borderRadius: 12,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  sendDisabled: {
    backgroundColor: '#C3B79B',
  },
});
