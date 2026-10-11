import React, {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useState,
} from 'react';

/**
 * Mini-navigateur (pile de routes) — même modèle que Navigator côté Flutter,
 * sans dépendance externe pour rester aligné avec le reste du projet.
 */
export type Route =
  | {name: 'details'; listingId: string}
  | {name: 'chat'; listingId: string}
  | {name: 'notifications'};

interface Navigator {
  stack: Route[];
  push(route: Route): void;
  pop(): void;
}

const NavigatorContext = createContext<Navigator | null>(null);

export function NavigatorProvider({children}: {children: React.ReactNode}) {
  const [stack, setStack] = useState<Route[]>([]);

  const push = useCallback((route: Route) => {
    setStack(current => [...current, route]);
  }, []);

  const pop = useCallback(() => {
    setStack(current => current.slice(0, -1));
  }, []);

  const value = useMemo(() => ({stack, push, pop}), [stack, push, pop]);

  return (
    <NavigatorContext.Provider value={value}>
      {children}
    </NavigatorContext.Provider>
  );
}

export function useNavigator(): Navigator {
  const context = useContext(NavigatorContext);
  if (!context) {
    throw new Error('useNavigator doit être utilisé dans <NavigatorProvider>');
  }
  return context;
}
