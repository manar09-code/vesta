/** Résultat d'une opération d'authentification. */
export interface AuthResult {
  error: string | null;
}

const ok: AuthResult = {error: null};
const failure = (error: string): AuthResult => ({error});

/**
 * Authentification. En démo, la validation reprend les messages de la
 * maquette ; une implémentation FirebaseAuth pourra être branchée ici.
 */
export interface AuthRepository {
  signIn(email: string, password: string): Promise<AuthResult>;
  signUp(
    name: string,
    email: string,
    password: string,
    confirm: string,
  ): Promise<AuthResult>;
}

const EMAIL_PATTERN = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;

/** Repository de démonstration : validation locale, aucun compte créé. */
export class DemoAuthRepository implements AuthRepository {
  /** Simule la latence d'un appel réseau. */
  private delay(): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, 450));
  }

  async signIn(email: string, password: string): Promise<AuthResult> {
    await this.delay();
    if (!EMAIL_PATTERN.test(email.trim())) {
      return failure('Entrez une adresse e-mail valide.');
    }
    if (password.length < 6) {
      return failure('Le mot de passe doit contenir au moins 6 caractères.');
    }
    return ok;
  }

  async signUp(
    name: string,
    email: string,
    password: string,
    confirm: string,
  ): Promise<AuthResult> {
    await this.delay();
    if (name.trim().length === 0) {
      return failure('Indiquez votre nom.');
    }
    if (!EMAIL_PATTERN.test(email.trim())) {
      return failure('Entrez une adresse e-mail valide.');
    }
    if (password.length < 6) {
      return failure('Le mot de passe doit contenir au moins 6 caractères.');
    }
    if (password !== confirm) {
      return failure('Les mots de passe ne correspondent pas.');
    }
    return ok;
  }
}
