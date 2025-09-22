import React, { useState, useEffect } from 'react';
import { ThemeProvider } from './contexts/ThemeContext';
import { LanguageProvider } from './contexts/LanguageContext';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import LandingPage from './pages/LandingPage';
import AuthPage from './pages/AuthPage';
import DashboardPage from './pages/DashboardPage';
import ReportsPage from './pages/ReportsPage';
import AnalyticsPage from './pages/AnalyticsPage';
import CreditsPage from './pages/CreditsPage';
import SettingsPage from './pages/SettingsPage';
import Sidebar from './components/Sidebar';
import Navbar from './components/Navbar';
import FloatingThemeToggle from './components/FloatingThemeToggle';

type AppPage = 'landing' | 'auth' | 'dashboard' | 'reports' | 'analytics' | 'credits' | 'settings';

const AppContent: React.FC = () => {
  const [currentPage, setCurrentPage] = useState<AppPage>('landing');
  const { user, isLoading } = useAuth();

  useEffect(() => {
    if (!isLoading) {
      if (user && currentPage === 'landing') {
        setCurrentPage('dashboard');
      } else if (!user && ['dashboard', 'reports', 'analytics', 'credits', 'settings'].includes(currentPage)) {
        setCurrentPage('landing');
      }
    }
  }, [user, isLoading, currentPage]);

  const handleLoginClick = () => setCurrentPage('auth');
  const handleAuthSuccess = () => setCurrentPage('dashboard');
  const handleLogout = () => setCurrentPage('landing');

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-sky-100 dark:bg-slate-900 flex items-center justify-center">
        <div className="w-8 h-8 border-2 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
      </div>
    );
  }

  // Show landing or auth pages
  if (currentPage === 'landing' || !user) {
    if (currentPage === 'auth') {
      return (
        <AuthPage
          onBack={() => setCurrentPage('landing')}
          onSuccess={handleAuthSuccess}
        />
      );
    }
    return <LandingPage onLoginClick={handleLoginClick} />;
  }

  // Show dashboard pages with sidebar
  const renderCurrentPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <DashboardPage onNavigate={(page: string) => setCurrentPage(page as AppPage)} />;
      case 'reports':
        return <ReportsPage />;
      case 'analytics':
        return <AnalyticsPage />;
      case 'credits':
        return <CreditsPage />;
      case 'settings':
        return <SettingsPage />;
      default:
        return <DashboardPage onNavigate={(page: string) => setCurrentPage(page as AppPage)} />;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-sky-100 dark:bg-gradient-to-br dark:from-slate-900 dark:via-slate-800 dark:to-slate-900">
      <Navbar isLanding={false} />
      <div className="flex">
        <Sidebar
          currentPage={currentPage}
          onPageChange={(page) => setCurrentPage(page as AppPage)}
        />
        <main className="flex-1 ml-0 md:ml-16 p-6 pt-15">
          <div className="max-w-7xl mx-auto">
            {renderCurrentPage()}
          </div>
        </main>
      </div>
      
      {/* Floating Theme Toggle */}
      <FloatingThemeToggle />
    </div>
  );
};

function App() {
  return (
    <ThemeProvider>
      <LanguageProvider>
        <AuthProvider>
          <AppContent />
        </AuthProvider>
      </LanguageProvider>
    </ThemeProvider>
  );
}

export default App;