import React, {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useState,
} from 'react';
import {AuthRepository, DemoAuthRepository} from './data/auth_repository';
import {ChatRepository, DemoChatRepository} from './data/chat_repository';
import {
  DemoListingRepository,
  ListingRepository,
} from './data/listing_repository';
import {Listing, demoListings} from './models/listing';
import {
  FilterOptions,
  filterListings,
} from './controllers/search_controller';

export type {FilterOptions};

/**
 * État global de l'application : session, favoris, annonces publiées.
 * Miroir de `AppState` côté Flutter — exposé via un contexte React.
 */
export interface AppState {
  userName: string | null;
  userEmail: string | null;
  isSignedIn: boolean;
  favorites: string[];
  listings: Listing[];

  isFavorite(id: string): boolean;
  toggleFavorite(id: string): void;
  signIn(email: string, name?: string): void;
  signOut(): void;
  publish(listing: Listing): void;
  byId(id: string): Listing | null;
  filteredListings(options: FilterOptions): Listing[];
}

interface AppServices {
  listings: ListingRepository;
  auth: AuthRepository;
  chat: ChatRepository;
}

const AppContext = createContext<AppState | null>(null);
const ServicesContext = createContext<AppServices | null>(null);

/** Fournit la couche de données (repositories) — les écrans ne parlent jamais à Firebase. */
export function AppProvider({children}: {children: React.ReactNode}) {
  const services = useMemo<AppServices>(
    () => ({
      listings: new DemoListingRepository(),
      auth: new DemoAuthRepository(),
      chat: new DemoChatRepository(),
    }),
    [],
  );

  const [userName, setUserName] = useState<string | null>(null);
  const [userEmail, setUserEmail] = useState<string | null>(null);
  const [favorites, setFavorites] = useState<string[]>([]);
  const [listings, setListings] = useState<Listing[]>(demoListings);

  const isFavorite = useCallback(
    (id: string) => favorites.includes(id),
    [favorites],
  );

  const toggleFavorite = useCallback((id: string) => {
    setFavorites(current =>
      current.includes(id)
        ? current.filter(item => item !== id)
        : [...current, id],
    );
  }, []);

  const signIn = useCallback((email: string, name?: string) => {
    setUserEmail(email.trim());
    const trimmed = name?.trim();
    setUserName(trimmed ? trimmed : null);
  }, []);

  const signOut = useCallback(() => {
    setUserEmail(null);
    setUserName(null);
  }, []);

  const publish = useCallback((listing: Listing) => {
    services.listings.add(listing);
    setListings(services.listings.all());
  }, [services]);

  const byId = useCallback(
    (id: string) => services.listings.byId(id),
    [services],
  );

  const filteredListings = useCallback(
    (options: FilterOptions) => filterListings(listings, favorites, options),
    [favorites, listings],
  );

  const value = useMemo<AppState>(
    () => ({
      userName,
      userEmail,
      isSignedIn: userEmail !== null,
      favorites,
      listings,
      isFavorite,
      toggleFavorite,
      signIn,
      signOut,
      publish,
      byId,
      filteredListings,
    }),
    [
      userName,
      userEmail,
      favorites,
      listings,
      isFavorite,
      toggleFavorite,
      signIn,
      signOut,
      publish,
      byId,
      filteredListings,
    ],
  );

  return (
    <ServicesContext.Provider value={services}>
      <AppContext.Provider value={value}>{children}</AppContext.Provider>
    </ServicesContext.Provider>
  );
}

/** Accès à l'état de session/favoris. */
export function useApp(): AppState {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp doit être utilisé dans <AppProvider>');
  }
  return context;
}

/** Accès à la couche de données (chat, auth…). */
export function useServices(): AppServices {
  const context = useContext(ServicesContext);
  if (!context) {
    throw new Error('useServices doit être utilisé dans <AppProvider>');
  }
  return context;
}
