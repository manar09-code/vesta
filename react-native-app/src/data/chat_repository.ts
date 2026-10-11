/**
 * Messagerie avec le propriétaire d'un bien. Démo : réponses
 * automatiques, aucune donnée envoyée.
 */
export interface ChatRepository {
  replyTo(message: string): Promise<string>;
}

const REPLIES = [
  'Bonjour ! Merci pour votre intérêt, le bien est toujours disponible.',
  'Bien sûr, des visites sont possibles en semaine comme le samedi.',
  'Je vous envoie les détails complets très vite, n’hésitez pas à me recontacter.',
];

export class DemoChatRepository implements ChatRepository {
  private turn = 0;

  async replyTo(_message: string): Promise<string> {
    await new Promise<void>(resolve => {
      setTimeout(resolve, 700);
    });
    const reply = REPLIES[this.turn % REPLIES.length];
    this.turn += 1;
    return reply;
  }
}
