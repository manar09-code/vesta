import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useRef,
  useState,
} from 'react';
import {Animated, StyleSheet, Text} from 'react-native';
import {colors, fonts} from '../core/theme';

interface ToastState {
  show(message: string): void;
}

const ToastContext = createContext<ToastState>({show: () => {}});

/** Toast façon maquette : bandeau vert foncé, centré au-dessus du menu. */
export function ToastProvider({children}: {children: React.ReactNode}) {
  const [message, setMessage] = useState<string | null>(null);
  const opacity = useRef(new Animated.Value(0)).current;
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const show = useCallback(
    (text: string) => {
      if (timer.current) {
        clearTimeout(timer.current);
      }
      setMessage(text);
      opacity.setValue(0);
      Animated.timing(opacity, {
        toValue: 1,
        duration: 180,
        useNativeDriver: true,
      }).start();
      timer.current = setTimeout(() => {
        Animated.timing(opacity, {
          toValue: 0,
          duration: 180,
          useNativeDriver: true,
        }).start(() => setMessage(null));
      }, 3500);
    },
    [opacity],
  );

  useEffect(() => {
    return () => {
      if (timer.current) {
        clearTimeout(timer.current);
      }
    };
  }, []);

  return (
    <ToastContext.Provider value={{show}}>
      {children}
      {message !== null && (
        <Animated.View pointerEvents="none" style={[styles.toast, {opacity}]}>
          <Text style={styles.message}>{message}</Text>
        </Animated.View>
      )}
    </ToastContext.Provider>
  );
}

const styles = StyleSheet.create({
  toast: {
    position: 'absolute',
    bottom: 98,
    left: 0,
    right: 0,
    alignItems: 'center',
  },
  message: {
    maxWidth: 365,
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: colors.primary,
    borderRadius: 12,
    color: '#FFFFFF',
    fontFamily: fonts.sans,
    fontSize: 12,
    lineHeight: 17,
    textAlign: 'center',
    overflow: 'hidden',
    elevation: 6,
    shadowColor: '#1B3760',
    shadowOpacity: 0.25,
    shadowRadius: 22,
    shadowOffset: {width: 0, height: 8},
  },
});

/** Affiche un toast façon maquette. */
export function useToast(): ToastState {
  return useContext(ToastContext);
}
