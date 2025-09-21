import React, { useState } from 'react';
import { User, Globe, Palette, Bell, LogOut, Save } from 'lucide-react';
import { useLanguage, Language } from '../contexts/LanguageContext';
import { useTheme } from '../contexts/ThemeContext';
import { useAuth } from '../contexts/AuthContext';

const SettingsPage: React.FC = () => {
  const { language, setLanguage, t } = useLanguage();
  const { isDarkMode, toggleTheme } = useTheme();
  const { user, logout } = useAuth();
  const [name, setName] = useState(user?.name || '');
  const [email, setEmail] = useState(user?.email || '');
  const [notifications, setNotifications] = useState(true);

  const handleSave = () => {
    // In a real app, this would save to backend
    console.log('Saving settings:', { name, email, language, isDarkMode, notifications });
    // Show success message
    alert('Settings saved successfully!');
  };

  const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
      logout();
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
        <h1 className="text-3xl font-bold text-white mb-2">{t('settings.title')}</h1>
        <p className="text-gray-400">
          Manage your account settings and preferences.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Profile Settings */}
        <div className="lg:col-span-2 space-y-6">
          {/* Profile Information */}
          <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
            <div className="flex items-center space-x-3 mb-6">
              <div className="p-2 bg-blue-600/20 rounded-lg">
                <User className="h-5 w-5 text-blue-400" />
              </div>
              <h2 className="text-xl font-semibold text-white">{t('settings.profile')}</h2>
            </div>

            <div className="space-y-4">
              <div>
                <label htmlFor="name" className="block text-sm font-medium text-gray-300 mb-2">
                  {t('settings.name')}
                </label>
                <input
                  id="name"
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="w-full px-4 py-3 bg-slate-700 border border-slate-600 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
                  placeholder="Enter your full name"
                />
              </div>

              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-300 mb-2">
                  {t('settings.email')}
                </label>
                <input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full px-4 py-3 bg-slate-700 border border-slate-600 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
                  placeholder="Enter your email address"
                />
              </div>
            </div>
          </div>

          {/* Preferences */}
          <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
            <div className="flex items-center space-x-3 mb-6">
              <div className="p-2 bg-purple-600/20 rounded-lg">
                <Palette className="h-5 w-5 text-purple-400" />
              </div>
              <h2 className="text-xl font-semibold text-white">{t('settings.preferences')}</h2>
            </div>

            <div className="space-y-6">
              {/* Language Setting */}
              <div>
                <label htmlFor="language" className="block text-sm font-medium text-gray-300 mb-2">
                  {t('settings.language')}
                </label>
                <select
                  id="language"
                  value={language}
                  onChange={(e) => setLanguage(e.target.value as Language)}
                  className="w-full px-4 py-3 bg-slate-700 border border-slate-600 rounded-lg text-white focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
                >
                  <option value="en">English 🇺🇸</option>
                  <option value="hi">हिन्दी 🇮🇳</option>
                </select>
              </div>

              {/* Theme Setting */}
              <div>
                <label className="block text-sm font-medium text-gray-300 mb-3">
                  {t('settings.theme')}
                </label>
                <div className="flex space-x-4">
                  <button
                    onClick={() => !isDarkMode && toggleTheme()}
                    className={`flex items-center space-x-3 px-4 py-3 rounded-lg border transition-colors ${
                      !isDarkMode
                        ? 'bg-blue-600/20 border-blue-500 text-blue-400'
                        : 'bg-slate-700 border-slate-600 text-gray-300 hover:border-slate-500'
                    }`}
                  >
                    <div className="w-4 h-4 bg-white rounded-full"></div>
                    <span>{t('settings.light')}</span>
                  </button>
                  <button
                    onClick={() => isDarkMode && toggleTheme()}
                    className={`flex items-center space-x-3 px-4 py-3 rounded-lg border transition-colors ${
                      isDarkMode
                        ? 'bg-blue-600/20 border-blue-500 text-blue-400'
                        : 'bg-slate-700 border-slate-600 text-gray-300 hover:border-slate-500'
                    }`}
                  >
                    <div className="w-4 h-4 bg-slate-800 rounded-full"></div>
                    <span>{t('settings.dark')}</span>
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Notifications */}
          <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
            <div className="flex items-center space-x-3 mb-6">
              <div className="p-2 bg-green-600/20 rounded-lg">
                <Bell className="h-5 w-5 text-green-400" />
              </div>
              <h2 className="text-xl font-semibold text-white">{t('settings.notifications')}</h2>
            </div>

            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-white font-medium">Email Notifications</h3>
                  <p className="text-gray-400 text-sm">Receive updates via email</p>
                </div>
                <button
                  onClick={() => setNotifications(!notifications)}
                  className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
                    notifications ? 'bg-blue-600' : 'bg-slate-600'
                  }`}
                >
                  <span
                    className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
                      notifications ? 'translate-x-6' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Sidebar Actions */}
        <div className="space-y-6">
          {/* Quick Actions */}
          <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
            <h2 className="text-lg font-semibold text-white mb-4">Quick Actions</h2>
            <div className="space-y-3">
              <button
                onClick={handleSave}
                className="w-full flex items-center space-x-3 px-4 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors"
              >
                <Save className="h-4 w-4" />
                <span>{t('settings.save')}</span>
              </button>

              <button
                onClick={handleLogout}
                className="w-full flex items-center space-x-3 px-4 py-3 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors"
              >
                <LogOut className="h-4 w-4" />
                <span>{t('settings.logout')}</span>
              </button>
            </div>
          </div>

          {/* Account Info */}
          <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
            <h2 className="text-lg font-semibold text-white mb-4">Account Info</h2>
            <div className="space-y-3 text-sm">
              <div className="flex justify-between">
                <span className="text-gray-400">User ID:</span>
                <span className="text-white">{user?.id}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-400">Role:</span>
                <span className="text-white">Staff Member</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-400">Last Login:</span>
                <span className="text-white">Today</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SettingsPage;