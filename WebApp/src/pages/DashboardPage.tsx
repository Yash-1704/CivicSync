import React from 'react';
import { TrendingUp, Clock, CheckCircle, AlertTriangle, FileText, BarChart3, Download } from 'lucide-react';
import GoogleMap from '../components/GoogleMap';
import { analyticsData } from '../data/mockData';
import { useLanguage } from '../contexts/LanguageContext';
import { useAuth } from '../contexts/AuthContext';

interface DashboardPageProps {
  onNavigate?: (page: string) => void;
}

const DashboardPage: React.FC<DashboardPageProps> = ({ onNavigate }) => {
  const { t } = useLanguage();
  const { user } = useAuth();

  const stats = [
    {
      title: t('dashboard.totalReports'),
      value: analyticsData.totalReports,
      icon: TrendingUp,
      color: 'bg-blue-500',
      gradient: 'from-blue-500 to-blue-600'
    },
    {
      title: t('dashboard.pendingReports'),
      value: analyticsData.pendingReports,
      icon: Clock,
      color: 'bg-yellow-500',
      gradient: 'from-yellow-500 to-yellow-600'
    },
    {
      title: t('dashboard.resolvedReports'),
      value: analyticsData.resolvedReports,
      icon: CheckCircle,
      color: 'bg-green-500',
      gradient: 'from-green-500 to-green-600'
    },
    {
      title: 'High Priority',
      value: analyticsData.urgencyDistribution.find(item => item.name === 'High')?.value || 0,
      icon: AlertTriangle,
      color: 'bg-red-500',
      gradient: 'from-red-500 to-red-600'
    }
  ];

  return (
    <div className="space-y-6">
      {/* Welcome Header */}
      <div className="bg-gradient-to-r from-blue-600 to-cyan-600 rounded-xl p-6 text-white">
        <h1 className="text-3xl font-bold mb-2">
          {t('dashboard.welcome')}, {user?.name}!
        </h1>
        <p className="text-blue-100">
          Here's what's happening in your civic dashboard today.
        </p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <div
              key={index}
              className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl p-6 border border-blue-100 dark:border-slate-700 hover:border-blue-300 dark:hover:border-slate-600 transition-colors shadow-lg hover:shadow-xl"
            >
              <div className="flex items-center justify-between mb-4">
                <div className={`p-3 rounded-lg bg-gradient-to-r ${stat.gradient}`}>
                  <Icon className="h-6 w-6 text-white" />
                </div>
                <div className="text-right">
                  <p className="text-2xl font-bold text-gray-900 dark:text-white">{stat.value}</p>
                </div>
              </div>
              <h3 className="text-gray-700 dark:text-gray-300 font-medium">{stat.title}</h3>
              <div className="mt-2 flex items-center text-sm">
                <TrendingUp className="h-4 w-4 text-green-500 mr-1" />
                <span className="text-green-500">+5.2%</span>
                <span className="text-gray-600 dark:text-gray-400 ml-2">vs last month</span>
              </div>
            </div>
          );
        })}
      </div>

      {/* Map Section */}
      <div className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl p-6 border border-blue-100 dark:border-slate-700 shadow-lg">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white">Live Reports Map</h2>
          <div className="flex items-center space-x-4 text-sm text-gray-600 dark:text-gray-400">
            <div className="flex items-center space-x-2">
              <div className="w-3 h-3 bg-red-500 rounded-full"></div>
              <span>High Priority</span>
            </div>
            <div className="flex items-center space-x-2">
              <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
              <span>Medium Priority</span>
            </div>
            <div className="flex items-center space-x-2">
              <div className="w-3 h-3 bg-green-500 rounded-full"></div>
              <span>Low Priority</span>
            </div>
          </div>
        </div>
        <GoogleMap className="h-96" />
      </div>

      {/* Quick Actions Header */}
      <div className="mb-6">
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">Quick Actions</h2>
        <p className="text-gray-600 dark:text-gray-400">Access frequently used features and tools</p>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <button 
          onClick={() => onNavigate?.('reports')}
          className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl p-6 border border-blue-100 dark:border-slate-700 hover:border-blue-300 dark:hover:border-blue-500/50 transition-colors cursor-pointer group shadow-lg hover:shadow-xl text-left"
        >
          <div className="flex items-center space-x-4">
            <div className="p-3 bg-blue-50 dark:bg-blue-600/20 rounded-lg group-hover:bg-blue-100 dark:group-hover:bg-blue-600/30 transition-colors">
              <FileText className="h-6 w-6 text-blue-600 dark:text-blue-400" />
            </div>
            <div>
              <h3 className="text-gray-900 dark:text-white font-semibold">View All Reports</h3>
              <p className="text-gray-600 dark:text-gray-400 text-sm">Manage citizen submissions</p>
            </div>
          </div>
        </button>

        <button 
          onClick={() => onNavigate?.('analytics')}
          className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl p-6 border border-blue-100 dark:border-slate-700 hover:border-blue-300 dark:hover:border-purple-500/50 transition-colors cursor-pointer group shadow-lg hover:shadow-xl text-left"
        >
          <div className="flex items-center space-x-4">
            <div className="p-3 bg-purple-50 dark:bg-purple-600/20 rounded-lg group-hover:bg-purple-100 dark:group-hover:bg-purple-600/30 transition-colors">
              <BarChart3 className="h-6 w-6 text-purple-600 dark:text-purple-400" />
            </div>
            <div>
              <h3 className="text-gray-900 dark:text-white font-semibold">Analytics Dashboard</h3>
              <p className="text-gray-600 dark:text-gray-400 text-sm">View detailed analytics</p>
            </div>
          </div>
        </button>

        <button 
          onClick={() => {
            // Mock export functionality
            const exportData = {
              totalReports: analyticsData.totalReports,
              pendingReports: analyticsData.pendingReports,
              resolvedReports: analyticsData.resolvedReports,
              exportDate: new Date().toISOString(),
              generatedBy: user?.name || 'Staff Member'
            };
            
            const dataStr = JSON.stringify(exportData, null, 2);
            const dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
            
            const exportFileDefaultName = `civic-report-${new Date().toISOString().split('T')[0]}.json`;
            
            const linkElement = document.createElement('a');
            linkElement.setAttribute('href', dataUri);
            linkElement.setAttribute('download', exportFileDefaultName);
            linkElement.click();
          }}
          className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl p-6 border border-blue-100 dark:border-slate-700 hover:border-blue-300 dark:hover:border-green-500/50 transition-colors cursor-pointer group shadow-lg hover:shadow-xl text-left"
        >
          <div className="flex items-center space-x-4">
            <div className="p-3 bg-green-50 dark:bg-green-600/20 rounded-lg group-hover:bg-green-100 dark:group-hover:bg-green-600/30 transition-colors">
              <Download className="h-6 w-6 text-green-600 dark:text-green-400" />
            </div>
            <div>
              <h3 className="text-gray-900 dark:text-white font-semibold">Export Report</h3>
              <p className="text-gray-600 dark:text-gray-400 text-sm">Download analytics summary</p>
            </div>
          </div>
        </button>
      </div>
    </div>
  );
};

export default DashboardPage;