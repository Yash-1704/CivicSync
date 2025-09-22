import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';

interface ThemeContextType {
  isDarkMode: boolean;
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export const useTheme = () => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
};

export const ThemeProvider = ({ children }: { children: ReactNode }) => {
  // Determine initial theme safely: read saved preference or fall back to system preference
  const getInitialTheme = (): boolean => {
    try {
      if (typeof window === 'undefined') return false;
      const saved = localStorage.getItem('theme');
      if (saved) return saved === 'dark';
      // No saved preference -> use system preference if available
      if (window.matchMedia) {
        return window.matchMedia('(prefers-color-scheme: dark)').matches;
      }
      return false; // default to light if nothing else
    } catch (e) {
      return false;
    }
  };

  const [isDarkMode, setIsDarkMode] = useState<boolean>(getInitialTheme);

  // Ensure the document has the correct class on mount and whenever theme changes
  useEffect(() => {
    try {
      localStorage.setItem('theme', isDarkMode ? 'dark' : 'light');
    } catch (e) {
      // ignore
    }

    if (isDarkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [isDarkMode]);

  const toggleTheme = (force?: 'light' | 'dark') => {
    setIsDarkMode(prev => {
      const next = typeof force === 'string' ? force === 'dark' : !prev;
      try {
        localStorage.setItem('theme', next ? 'dark' : 'light');
      } catch (e) {
        // ignore
      }
      // apply immediately for zero-delay responsiveness
      if (next) {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
      return next;
    });
  };

  return (
    <ThemeContext.Provider value={{ isDarkMode, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};