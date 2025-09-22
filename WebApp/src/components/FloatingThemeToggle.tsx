import React from 'react';
import { Moon, Sun } from 'lucide-react';
import { useTheme } from '../contexts/ThemeContext';

const FloatingThemeToggle: React.FC = () => {
  const { isDarkMode, toggleTheme } = useTheme();

  return (
    <button
      onClick={() => toggleTheme()}
      className="fixed bottom-6 right-6 z-50 p-3 bg-white dark:bg-slate-800 text-gray-900 dark:text-white shadow-lg hover:shadow-xl rounded-full border border-gray-200 dark:border-slate-600 transition-all duration-200 hover:scale-110"
      title={isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode'}
    >
      {isDarkMode ? (
        <Sun className="h-5 w-5" />
      ) : (
        <Moon className="h-5 w-5" />
      )}
    </button>
  );
};

export default FloatingThemeToggle;