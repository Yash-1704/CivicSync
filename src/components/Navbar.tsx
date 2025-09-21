import React from 'react';
import { Shield, Moon, Sun, ChevronDown } from 'lucide-react';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage, Language } from '../contexts/LanguageContext';
import { useAuth } from '../contexts/AuthContext';

interface NavbarProps {
  onLoginClick?: () => void;
  isLanding?: boolean;
}

const Navbar: React.FC<NavbarProps> = ({ onLoginClick, isLanding = true }) => {
  const { isDarkMode, toggleTheme } = useTheme();
  const { language, setLanguage, t } = useLanguage();
  const { user } = useAuth();

  const scrollToId = (id: string) => {
    const el = typeof document !== 'undefined' ? document.getElementById(id) : null;
    if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
  };

  const languages: { code: Language; name: string; flag: string }[] = [
    { code: 'en', name: 'English', flag: '🇺🇸' },
    { code: 'hi', name: 'हिन्दी', flag: '🇮🇳' }
  ];

  const currentLang = languages.find(l => l.code === language) || languages[0];

  return (
    <nav className="bg-slate-900/95 backdrop-blur-md border-b border-slate-800 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
  <div className="relative flex justify-between items-center h-16">
          {/* Logo */}
          <div className="flex items-center space-x-2">
            <Shield className="h-8 w-8 text-blue-500" />
            <span className="text-xl font-bold text-white">Civic Dashboard</span>
          </div>

          {/* Navigation Links (centered) */}
          {isLanding && (
            <div className="hidden md:flex space-x-8 absolute left-1/2 top-1/2 transform -translate-x-1/2 -translate-y-1/2">
              <a
                href="#home"
                onClick={(e) => { e.preventDefault(); scrollToId('home'); }}
                className="text-cyan-400 hover:text-cyan-300 transition-colors"
              >
                {t('nav.home') || 'Home'}
              </a>
              <a
                href="#features"
                onClick={(e) => { e.preventDefault(); scrollToId('features'); }}
                className="text-gray-300 hover:text-white transition-colors"
              >
                {t('nav.features') || 'Features'}
              </a>
              <a
                href="#how-it-works"
                onClick={(e) => { e.preventDefault(); scrollToId('how-it-works'); }}
                className="text-gray-300 hover:text-white transition-colors"
              >
                {t('nav.howItWorks') || 'How it works'}
              </a>
              <a
                href="#about"
                onClick={(e) => { e.preventDefault(); scrollToId('about'); }}
                className="text-gray-300 hover:text-white transition-colors"
              >
                {t('nav.about') || 'About'}
              </a>
              {/* Access Dashboard: call the login handler if provided, otherwise scroll to dashboard section */}
              <a
                href="#dashboard"
                onClick={(e) => {
                  e.preventDefault();
                  if (onLoginClick) return onLoginClick();
                  scrollToId('dashboard');
                }}
                className="text-white bg-blue-600 px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
              >
                {t('nav.dashboard') || 'Dashboard'}
              </a>
            </div>
          )}

          {/* Right Side */}
          <div className="flex items-center space-x-4">
            {/* Language Dropdown */}
            <div className="relative group">
              <button className="flex items-center space-x-2 px-3 py-2 rounded-lg bg-slate-800 text-gray-300 hover:bg-slate-700 transition-colors">
                <span className="text-sm">{currentLang.flag}</span>
                <span className="hidden sm:block">{currentLang.name}</span>
                <ChevronDown className="h-4 w-4" />
              </button>
              <div className="absolute right-0 mt-2 w-48 bg-slate-800 rounded-lg shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                {languages.map((lang) => (
                  <button
                    key={lang.code}
                    onClick={() => setLanguage(lang.code)}
                    className="w-full flex items-center space-x-3 px-4 py-2 text-left text-gray-300 hover:bg-slate-700 hover:text-white transition-colors first:rounded-t-lg last:rounded-b-lg"
                  >
                    <span>{lang.flag}</span>
                    <span>{lang.name}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Theme Toggle */}
            <button
              onClick={toggleTheme}
              className="p-2 rounded-lg bg-slate-800 text-gray-300 hover:bg-slate-700 hover:text-white transition-colors"
            >
              {isDarkMode ? <Sun className="h-5 w-5" /> : <Moon className="h-5 w-5" />}
            </button>

            {/* Staff Login/User Info */}
            {user ? (
              <div className="text-white font-medium">
                Welcome, {user.name}
              </div>
            ) : (
              <button
                onClick={onLoginClick}
                className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors"
              >
                {t('nav.staffLogin')}
              </button>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;