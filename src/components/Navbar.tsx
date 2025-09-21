import React, { useState } from 'react';
import { Shield, ChevronDown, Bell, LogOut, Clock, AlertTriangle, CheckCircle, User, Settings, HelpCircle } from 'lucide-react';
import { useLanguage, Language } from '../contexts/LanguageContext';
import { useAuth } from '../contexts/AuthContext';

interface NavbarProps {
  onLoginClick?: () => void;
  isLanding?: boolean;
}

const Navbar: React.FC<NavbarProps> = ({ onLoginClick, isLanding = true }) => {
  const { language, setLanguage, t } = useLanguage();
  const { user, logout } = useAuth();
  const [showNotifications, setShowNotifications] = useState(false);
  const [showUserMenu, setShowUserMenu] = useState(false);

  // Mock notifications data
  const notifications = [
    {
      id: 1,
      type: 'urgent',
      title: 'High Priority Report',
      message: 'Water pipe burst reported at Connaught Place',
      time: '2 min ago',
      read: false
    },
    {
      id: 2,
      type: 'resolved',
      title: 'Issue Resolved',
      message: 'Street light repair completed at India Gate',
      time: '1 hour ago',
      read: false
    },
    {
      id: 3,
      type: 'pending',
      title: 'New Report Assigned',
      message: 'Pothole repair request assigned to your team',
      time: '3 hours ago',
      read: true
    }
  ];

  const unreadCount = notifications.filter(n => !n.read).length;

  const getNotificationIcon = (type: string) => {
    switch (type) {
      case 'urgent':
        return <AlertTriangle className="h-4 w-4 text-red-500" />;
      case 'resolved':
        return <CheckCircle className="h-4 w-4 text-green-500" />;
      case 'pending':
        return <Clock className="h-4 w-4 text-yellow-500" />;
      default:
        return <Bell className="h-4 w-4 text-blue-500" />;
    }
  };

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
    <nav className="bg-sky-600/95 backdrop-blur-md dark:bg-slate-900/95 dark:backdrop-blur-md border-b border-sky-700/30 dark:border-slate-800 sticky top-0 z-50">
      <div className="px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo and Title - Left side */}
          <div className="flex items-center space-x-3">
            <Shield className="h-8 w-8 text-blue-400" />
            <span className="text-xl font-bold text-white dark:text-white">
              {!isLanding ? 'Government Staff Portal' : 'Civic Dashboard'}
            </span>
          </div>

          {/* Navigation Links (centered) */}
          {isLanding && (
            <div className="hidden md:flex items-center space-x-8 absolute left-1/2 top-0 bottom-0 transform -translate-x-1/2">
              <a
                href="#home"
                onClick={(e) => { e.preventDefault(); scrollToId('home'); }}
                className="text-cyan-200 hover:text-white dark:text-cyan-400 dark:hover:text-cyan-300 transition-colors"
              >
                {t('nav.home') || 'Home'}
              </a>
              <a
                href="#features"
                onClick={(e) => { e.preventDefault(); scrollToId('features'); }}
                className="text-sky-100 hover:text-white dark:text-gray-300 dark:hover:text-white transition-colors"
              >
                {t('nav.features') || 'Features'}
              </a>
              <a
                href="#how-it-works"
                onClick={(e) => { e.preventDefault(); scrollToId('how-it-works'); }}
                className="text-sky-100 hover:text-white dark:text-gray-300 dark:hover:text-white transition-colors"
              >
                {t('nav.howItWorks') || 'How it works'}
              </a>
              <a
                href="#about"
                onClick={(e) => { e.preventDefault(); scrollToId('about'); }}
                className="text-sky-100 hover:text-white dark:text-gray-300 dark:hover:text-white transition-colors"
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
                className="text-white dark:text-white bg-blue-600 px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
              >
                {t('nav.dashboard') || 'Dashboard'}
              </a>
            </div>
          )}

          {/* Right Side Controls */}
          <div className="flex items-center space-x-3">
            {/* Language Dropdown */}
            <div className="relative group">
              <button className="flex items-center space-x-2 px-3 py-1.5 rounded-md bg-slate-700/50 dark:bg-slate-800 text-white text-sm hover:bg-slate-700/70 dark:hover:bg-slate-700 transition-colors">
                <span className="text-sm">{currentLang.name}</span>
                <ChevronDown className="h-3 w-3" />
              </button>
              <div className="absolute right-0 mt-2 w-36 bg-white dark:bg-slate-800 rounded-lg shadow-lg border border-slate-200 dark:border-slate-700 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                {languages.map((lang) => (
                  <button
                    key={lang.code}
                    onClick={() => setLanguage(lang.code)}
                    className="w-full flex items-center space-x-2 px-3 py-2 text-left text-gray-700 dark:text-gray-300 hover:bg-slate-50 dark:hover:bg-slate-700 hover:text-gray-900 dark:hover:text-white transition-colors text-sm first:rounded-t-lg last:rounded-b-lg"
                  >
                    <span>{lang.flag}</span>
                    <span>{lang.name}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Notification Button */}
            {user && (
              <div className="relative">
                <button 
                  onClick={() => setShowNotifications(!showNotifications)}
                  className="relative p-2 rounded-md bg-slate-700/50 dark:bg-slate-800 text-white hover:bg-slate-700/70 dark:hover:bg-slate-700 transition-colors"
                >
                  <Bell className="h-4 w-4" />
                  {unreadCount > 0 && (
                    <span className="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-4 w-4 flex items-center justify-center font-medium text-[10px]">
                      {unreadCount}
                    </span>
                  )}
                </button>
                
                {/* Notifications Dropdown */}
                {showNotifications && (
                  <>
                    {/* Backdrop */}
                    <div 
                      className="fixed inset-0 z-10" 
                      onClick={() => setShowNotifications(false)}
                    />
                    
                    {/* Dropdown */}
                    <div className="absolute right-0 mt-2 w-80 bg-white dark:bg-slate-800 rounded-lg shadow-xl border border-slate-200 dark:border-slate-700 z-20 max-h-96 overflow-y-auto">
                      {/* Header */}
                      <div className="px-4 py-3 border-b border-slate-200 dark:border-slate-700">
                        <div className="flex items-center justify-between">
                          <h3 className="text-sm font-semibold text-gray-900 dark:text-white">
                            Notifications
                          </h3>
                          <span className="text-xs text-gray-500 dark:text-gray-400">
                            {unreadCount} unread
                          </span>
                        </div>
                      </div>
                      
                      {/* Notifications List */}
                      <div className="py-2">
                        {notifications.map((notification) => (
                          <div
                            key={notification.id}
                            className={`px-4 py-3 hover:bg-slate-50 dark:hover:bg-slate-700 cursor-pointer border-l-4 ${
                              notification.read 
                                ? 'border-transparent' 
                                : notification.type === 'urgent' 
                                  ? 'border-red-500' 
                                  : notification.type === 'resolved'
                                    ? 'border-green-500'
                                    : 'border-yellow-500'
                            }`}
                          >
                            <div className="flex items-start space-x-3">
                              <div className="flex-shrink-0 mt-1">
                                {getNotificationIcon(notification.type)}
                              </div>
                              <div className="flex-1 min-w-0">
                                <p className={`text-sm font-medium ${
                                  notification.read 
                                    ? 'text-gray-600 dark:text-gray-400' 
                                    : 'text-gray-900 dark:text-white'
                                }`}>
                                  {notification.title}
                                </p>
                                <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                                  {notification.message}
                                </p>
                                <p className="text-xs text-gray-400 dark:text-gray-500 mt-1">
                                  {notification.time}
                                </p>
                              </div>
                              {!notification.read && (
                                <div className="w-2 h-2 bg-blue-500 rounded-full flex-shrink-0 mt-2"></div>
                              )}
                            </div>
                          </div>
                        ))}
                      </div>
                      
                      {/* Footer */}
                      <div className="px-4 py-3 border-t border-slate-200 dark:border-slate-700">
                        <button className="text-xs text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 font-medium">
                          View all notifications
                        </button>
                      </div>
                    </div>
                  </>
                )}
              </div>
            )}

            {/* User Avatar/Profile */}
            {user && (
              <div className="relative">
                <button 
                  onClick={() => setShowUserMenu(!showUserMenu)}
                  className="p-1.5 rounded-md bg-slate-700/50 dark:bg-slate-800 text-white hover:bg-slate-700/70 dark:hover:bg-slate-700 transition-colors"
                >
                  <div className="w-6 h-6 bg-blue-500 rounded-full flex items-center justify-center text-white text-xs font-medium">
                    {user.name?.charAt(0)?.toUpperCase() || 'U'}
                  </div>
                </button>
                
                {/* User Menu Dropdown */}
                {showUserMenu && (
                  <>
                    {/* Backdrop */}
                    <div 
                      className="fixed inset-0 z-10" 
                      onClick={() => setShowUserMenu(false)}
                    />
                    
                    {/* Dropdown */}
                    <div className="absolute right-0 mt-2 w-64 bg-white dark:bg-slate-800 rounded-lg shadow-xl border border-slate-200 dark:border-slate-700 z-20">
                      {/* User Info Header */}
                      <div className="px-4 py-3 border-b border-slate-200 dark:border-slate-700">
                        <div className="flex items-center space-x-3">
                          <div className="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center text-white font-medium">
                            {user.name?.charAt(0)?.toUpperCase() || 'U'}
                          </div>
                          <div>
                            <p className="text-sm font-semibold text-gray-900 dark:text-white">
                              {user.name}
                            </p>
                            <p className="text-xs text-gray-500 dark:text-gray-400">
                              {user.email}
                            </p>
                          </div>
                        </div>
                      </div>
                      
                      {/* Menu Items */}
                      <div className="py-2">
                        <button className="w-full flex items-center space-x-3 px-4 py-2 text-left text-gray-700 dark:text-gray-300 hover:bg-slate-50 dark:hover:bg-slate-700 hover:text-gray-900 dark:hover:text-white transition-colors">
                          <User className="h-4 w-4" />
                          <span className="text-sm">My Profile</span>
                        </button>
                        
                        <button className="w-full flex items-center space-x-3 px-4 py-2 text-left text-gray-700 dark:text-gray-300 hover:bg-slate-50 dark:hover:bg-slate-700 hover:text-gray-900 dark:hover:text-white transition-colors">
                          <Settings className="h-4 w-4" />
                          <span className="text-sm">Account Settings</span>
                        </button>
                        
                        <button className="w-full flex items-center space-x-3 px-4 py-2 text-left text-gray-700 dark:text-gray-300 hover:bg-slate-50 dark:hover:bg-slate-700 hover:text-gray-900 dark:hover:text-white transition-colors">
                          <HelpCircle className="h-4 w-4" />
                          <span className="text-sm">Help & Support</span>
                        </button>
                        
                        <div className="border-t border-slate-200 dark:border-slate-700 mt-2 pt-2">
                          <button 
                            onClick={() => {
                              logout();
                              setShowUserMenu(false);
                            }}
                            className="w-full flex items-center space-x-3 px-4 py-2 text-left text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 hover:text-red-800 dark:hover:text-red-300 transition-colors"
                          >
                            <LogOut className="h-4 w-4" />
                            <span className="text-sm">Sign Out</span>
                          </button>
                        </div>
                      </div>
                    </div>
                  </>
                )}
              </div>
            )}

            {/* Logout Button */}
            {user && (
              <button 
                onClick={logout}
                className="p-2 rounded-md bg-slate-700/50 dark:bg-slate-800 text-white hover:bg-red-600 dark:hover:bg-red-700 transition-colors" 
                title="Logout"
              >
                <LogOut className="h-4 w-4" />
              </button>
            )}

            {/* Staff Login Button (when not logged in) */}
            {!user && (
              <button
                onClick={onLoginClick}
                className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md font-medium transition-colors text-sm"
              >
                {t('nav.staffLogin') || 'Staff Login'}
              </button>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;