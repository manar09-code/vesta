import {useCallback, useState} from 'react';

export interface ChatMessage {
  id: string;
  text: string;
  fromMe: boolean;
}

const GREETING: ChatMessage = {
  id: 'm-0',
  text: 'Bonjour ! Merci pour votre intérêt, n’hésitez pas si vous avez des questions sur le bien.',
  fromMe: false,
};

/**
 * Contrôleur de la messagerie : historique, saisie et envoi.
 * Les réponses proviennent du repository (démo : réponses automatiques).
 * Miroir de `ChatController` côté Flutter.
 */
export function useChatController(replyTo: (message: string) => Promise<string>) {
  const [messages, setMessages] = useState<ChatMessage[]>([GREETING]);
  const [input, setInput] = useState('');
  const [sending, setSending] = useState(false);

  const canSend = input.trim().length > 0 && !sending;

  const send = useCallback(async () => {
    const text = input.trim();
    if (text.length === 0 || sending) {
      return;
    }
    setSending(true);
    setInput('');
    setMessages(current => [
      ...current,
      {id: `m-${current.length}-me`, text, fromMe: true},
    ]);
    const reply = await replyTo(text);
    setMessages(current => [
      ...current,
      {id: `m-${current.length}-them`, text: reply, fromMe: false},
    ]);
    setSending(false);
  }, [input, replyTo, sending]);

  return {messages, input, setInput, canSend, sending, send};
}
