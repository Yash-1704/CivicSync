import React from 'react';
import { PieChart, Pie, Cell, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, LineChart, Line } from 'recharts';
import { TrendingUp, AlertTriangle, CheckCircle, Clock } from 'lucide-react';
import { analyticsData } from '../data/mockData';
import { useLanguage } from '../contexts/LanguageContext';

const AnalyticsPage: React.FC = () => {
  const { t } = useLanguage();

  const CustomTooltip = ({ active, payload, label }: any) => {
    if (active && payload && payload.length) {
      return (
        <div className="bg-slate-800 border border-slate-600 rounded-lg p-3 shadow-lg">
          <p className="text-gray-300">{`${label}: ${payload[0].value}`}</p>
        </div>
      );
    }
    return null;
  };

  const stats = [
    {
      title: t('dashboard.totalReports'),
      value: analyticsData.totalReports,
      icon: TrendingUp,
      color: 'text-blue-400',
      bg: 'bg-blue-500/20',
      change: '+12%'
    },
    {
      title: t('dashboard.pendingReports'),
      value: analyticsData.pendingReports,
      icon: Clock,
      color: 'text-yellow-400',
      bg: 'bg-yellow-500/20',
      change: '-5%'
    },
    {
      title: t('dashboard.resolvedReports'),
      value: analyticsData.resolvedReports,
      icon: CheckCircle,
      color: 'text-green-400',
      bg: 'bg-green-500/20',
      change: '+18%'
    },
    {
      title: 'High Priority',
      value: analyticsData.urgencyDistribution.find(item => item.name === 'High')?.value || 0,
      icon: AlertTriangle,
      color: 'text-red-400',
      bg: 'bg-red-500/20',
      change: '+3%'
    }
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
        <h1 className="text-3xl font-bold text-white mb-2">{t('analytics.title')}</h1>
        <p className="text-gray-400">
          Comprehensive insights into civic operations and report management.
        </p>
      </div>

      {/* Overview Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <div key={index} className="bg-slate-800 rounded-xl p-6 border border-slate-700">
              <div className="flex items-center justify-between mb-4">
                <div className={`p-3 rounded-lg ${stat.bg}`}>
                  <Icon className={`h-6 w-6 ${stat.color}`} />
                </div>
                <div className="text-right">
                  <div className="text-2xl font-bold text-white">{stat.value}</div>
                  <div className={`text-sm ${stat.change.startsWith('+') ? 'text-green-400' : 'text-red-400'}`}>
                    {stat.change}
                  </div>
                </div>
              </div>
              <h3 className="text-gray-300 font-medium">{stat.title}</h3>
            </div>
          );
        })}
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Urgency Distribution */}
        <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
          <h2 className="text-xl font-bold text-white mb-4">{t('analytics.urgencyDistribution')}</h2>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={analyticsData.urgencyDistribution}
                  cx="50%"
                  cy="50%"
                  outerRadius={80}
                  fill="#8884d8"
                  dataKey="value"
                  label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                >
                  {analyticsData.urgencyDistribution.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
                <Tooltip content={<CustomTooltip />} />
              </PieChart>
            </ResponsiveContainer>
          </div>
          <div className="flex flex-wrap gap-4 mt-4">
            {analyticsData.urgencyDistribution.map((item, index) => (
              <div key={index} className="flex items-center space-x-2">
                <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }}></div>
                <span className="text-sm text-gray-300">{item.name}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Status Distribution */}
        <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
          <h2 className="text-xl font-bold text-white mb-4">{t('analytics.statusDistribution')}</h2>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={analyticsData.statusDistribution}>
                <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
                <XAxis dataKey="name" stroke="#9CA3AF" />
                <YAxis stroke="#9CA3AF" />
                <Tooltip content={<CustomTooltip />} />
                <Bar dataKey="value" fill="#3B82F6" radius={[4, 4, 0, 0]}>
                  {analyticsData.statusDistribution.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>

      {/* Monthly Trends */}
      <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
        <h2 className="text-xl font-bold text-white mb-4">{t('analytics.monthlyTrends')}</h2>
        <div className="h-80">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={analyticsData.monthlyData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
              <XAxis dataKey="month" stroke="#9CA3AF" />
              <YAxis stroke="#9CA3AF" />
              <Tooltip content={<CustomTooltip />} />
              <Line
                type="monotone"
                dataKey="reports"
                stroke="#3B82F6"
                strokeWidth={3}
                dot={{ fill: '#3B82F6', strokeWidth: 2, r: 4 }}
                activeDot={{ r: 6, stroke: '#3B82F6', strokeWidth: 2 }}
              />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Insights Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div className="bg-gradient-to-r from-blue-600/20 to-blue-800/20 rounded-xl p-6 border border-blue-500/30">
          <div className="flex items-center space-x-3 mb-3">
            <TrendingUp className="h-8 w-8 text-blue-400" />
            <h3 className="text-lg font-semibold text-white">Performance Insight</h3>
          </div>
          <p className="text-blue-100 text-sm">
            Report resolution time has improved by 25% this month compared to last month.
          </p>
        </div>

        <div className="bg-gradient-to-r from-green-600/20 to-green-800/20 rounded-xl p-6 border border-green-500/30">
          <div className="flex items-center space-x-3 mb-3">
            <CheckCircle className="h-8 w-8 text-green-400" />
            <h3 className="text-lg font-semibold text-white">Success Rate</h3>
          </div>
          <p className="text-green-100 text-sm">
            62% of all reports have been successfully resolved this month.
          </p>
        </div>

        <div className="bg-gradient-to-r from-yellow-600/20 to-yellow-800/20 rounded-xl p-6 border border-yellow-500/30">
          <div className="flex items-center space-x-3 mb-3">
            <AlertTriangle className="h-8 w-8 text-yellow-400" />
            <h3 className="text-lg font-semibold text-white">Priority Alert</h3>
          </div>
          <p className="text-yellow-100 text-sm">
            10 high-priority reports require immediate attention from your team.
          </p>
        </div>
      </div>
    </div>
  );
};

export default AnalyticsPage;