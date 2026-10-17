import React, { createContext, useContext, ReactNode } from 'react';

type AuthContextValue = { isSignedIn: boolean };
const AuthContext = createContext<AuthContextValue>({ isSignedIn: false });

export function AuthProvider({ children }: { children: ReactNode }): React.JSX.Element {
  // Authentication is intentionally a placeholder until its feature is implemented.
  return <AuthContext.Provider value={{ isSignedIn: true }}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  return useContext(AuthContext);
}
