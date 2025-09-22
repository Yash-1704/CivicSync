import React, { useState } from 'react';
import { Home, FileText, BarChart3, Settings, Menu, X, Trophy } from 'lucide-react';

// Assuming useLanguage is in a valid path
// import { useLanguage } from '../contexts/LanguageContext';

interface SidebarProps {
  currentPage: string;
  onPageChange: (page: string) => void;
}

// Mocking useLanguage for demonstration purposes
const useLanguage = () => ({
  t: (key: string) => key.split('.').pop() || '',
});

const Sidebar: React.FC<SidebarProps> = ({ currentPage, onPageChange }) => {
  const [isExpanded, setIsExpanded] = useState(false);
  const [isMobileOpen, setIsMobileOpen] = useState(false);
  const { t } = useLanguage();

  const menuItems = [
    { id: 'dashboard', label: t('nav.home'), icon: Home },
    { id: 'reports', label: t('nav.reports'), icon: FileText },
    { id: 'analytics', label: t('nav.analytics'), icon: BarChart3 },
    { id: 'credits', label: 'Credits', icon: Trophy },
    { id: 'settings', label: t('nav.settings'), icon: Settings },
  ];

  const sidebarClasses = `
    fixed left-0 top-16 h-[calc(100vh-4rem)] bg-sky-600/95 dark:bg-slate-900/95 backdrop-blur-md border-r border-sky-700/30 dark:border-slate-800
    transition-all duration-300 z-40
    ${isExpanded ? 'w-64' : 'w-20'}
    ${isMobileOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0'}
  `;

  return (
    <>
      {/* Mobile Menu Button */}
      <button
        onClick={() => setIsMobileOpen(!isMobileOpen)}
        className="fixed top-20 left-4 z-50 md:hidden bg-sky-700 dark:bg-slate-800 text-white p-2 rounded-lg"
      >
        {isMobileOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
      </button>

      {/* Mobile Overlay */}
      {isMobileOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-30 md:hidden"
          onClick={() => setIsMobileOpen(false)}
        />
      )}

      {/* Sidebar */}
      <div
        className={sidebarClasses}
        onMouseEnter={() => !isMobileOpen && setIsExpanded(true)}
        onMouseLeave={() => !isMobileOpen && setIsExpanded(false)}
      >
        <nav className="flex flex-col space-y-2 p-2 mt-4">
          {menuItems.map((item) => {
            const Icon = item.icon;
            const isActive = currentPage === item.id;
            
            return (
              <button
                key={item.id}
                onClick={() => {
                  onPageChange(item.id);
                  setIsMobileOpen(false);
                }}
                className={`
                  w-full py-2.5 rounded-lg transition-all duration-200
                  ${isExpanded ? 'flex items-center px-3 space-x-3' : 'block'} /* <--- KEY CHANGE HERE */
                  ${isActive ? 'text-white' : 'text-sky-100 dark:text-gray-400 hover:bg-sky-500/30 dark:hover:bg-slate-800 hover:text-white'}
                `}
              >
                {/* Icon Container */}
                <div 
                  className={`
                    w-12 h-12 flex items-center justify-center rounded-xl transition-all
                    ${!isExpanded ? 'mx-auto' : 'flex-shrink-0'} /* <--- KEY CHANGE HERE */
                    ${isActive ? 'bg-blue-600 shadow-lg' : ''}
                  `}
                >
                  <Icon className="h-6 w-6" />
                </div>

                {/* Label */}
                <span
                  className={`
                    font-medium whitespace-nowrap
                    transition-opacity duration-200 
                    ${isExpanded ? 'opacity-100' : 'opacity-0 hidden'} /* <--- ADDED 'hidden' */
                  `}
                >
                  {item.label}
                </span>
              </button>
            );
          })}
        </nav>
      </div>
    </>
  );
};

export default Sidebar;