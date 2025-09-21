import React, { useState } from 'react';
import { Search, Filter, Eye, Edit, Trash2 } from 'lucide-react';
import { mockReports, Report } from '../data/mockData';
import { useLanguage } from '../contexts/LanguageContext';

const ReportsPage: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState<'all' | 'pending' | 'inProgress' | 'resolved'>('all');
  const [currentPage, setCurrentPage] = useState(1);
  const { t } = useLanguage();
  const itemsPerPage = 5;

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending': return 'bg-yellow-500/20 text-yellow-300 border-yellow-500/30';
      case 'inProgress': return 'bg-blue-500/20 text-blue-300 border-blue-500/30';
      case 'resolved': return 'bg-green-500/20 text-green-300 border-green-500/30';
      default: return 'bg-gray-500/20 text-gray-300 border-gray-500/30';
    }
  };

  const getUrgencyColor = (urgency: string) => {
    switch (urgency) {
      case 'high': return 'bg-red-500/20 text-red-300 border-red-500/30';
      case 'medium': return 'bg-yellow-500/20 text-yellow-300 border-yellow-500/30';
      case 'low': return 'bg-green-500/20 text-green-300 border-green-500/30';
      default: return 'bg-gray-500/20 text-gray-300 border-gray-500/30';
    }
  };

  const filteredReports = mockReports.filter(report => {
    const matchesSearch = report.location.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         report.id.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || report.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filteredReports.length / itemsPerPage);
  const paginatedReports = filteredReports.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage
  );

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl p-6 border border-blue-100 dark:border-slate-700 shadow-lg">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">{t('reports.title')}</h1>
        <p className="text-gray-600 dark:text-gray-400">
          Track and manage citizen reports efficiently across your jurisdiction.
        </p>
      </div>

      {/* Filters */}
      <div className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl p-6 border border-blue-100 dark:border-slate-700 shadow-lg">
        <div className="flex flex-col lg:flex-row gap-4">
          {/* Search */}
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-500 dark:text-gray-400" />
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder={t('reports.search')}
              className="w-full pl-10 pr-4 py-3 bg-blue-50 dark:bg-slate-700 border border-blue-200 dark:border-slate-600 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
            />
          </div>

          {/* Status Filter */}
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-500 dark:text-gray-400" />
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value as any)}
              className="pl-10 pr-8 py-3 bg-blue-50 dark:bg-slate-700 border border-blue-200 dark:border-slate-600 rounded-lg text-gray-900 dark:text-white focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 appearance-none cursor-pointer"
            >
              <option value="all">{t('reports.filter.all')}</option>
              <option value="pending">{t('reports.filter.pending')}</option>
              <option value="inProgress">{t('reports.filter.inProgress')}</option>
              <option value="resolved">{t('reports.filter.resolved')}</option>
            </select>
          </div>
        </div>
      </div>

      {/* Reports Table */}
      <div className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl border border-blue-100 dark:border-slate-700 overflow-hidden shadow-lg">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-blue-200 dark:border-slate-700 bg-blue-50/50 dark:bg-slate-900/50">
                <th className="px-6 py-4 text-left text-sm font-medium text-gray-600 dark:text-gray-300 uppercase tracking-wider">
                  {t('reports.id')}
                </th>
                <th className="px-6 py-4 text-left text-sm font-medium text-gray-600 dark:text-gray-300 uppercase tracking-wider">
                  {t('reports.location')}
                </th>
                <th className="px-6 py-4 text-left text-sm font-medium text-gray-600 dark:text-gray-300 uppercase tracking-wider">
                  {t('reports.urgency')}
                </th>
                <th className="px-6 py-4 text-left text-sm font-medium text-gray-600 dark:text-gray-300 uppercase tracking-wider">
                  {t('reports.status')}
                </th>
                <th className="px-6 py-4 text-left text-sm font-medium text-gray-600 dark:text-gray-300 uppercase tracking-wider">
                  {t('reports.date')}
                </th>
                <th className="px-6 py-4 text-right text-sm font-medium text-gray-300 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-blue-200 dark:divide-slate-700">
              {paginatedReports.map((report) => (
                <tr key={report.id} className="hover:bg-blue-50 dark:hover:bg-slate-700/50 transition-colors">
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-mono text-blue-600 dark:text-blue-400">
                    {report.id}
                  </td>
                  <td className="px-6 py-4 text-sm text-gray-900 dark:text-white">
                    {report.location}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`inline-flex px-3 py-1 rounded-full text-xs font-medium border ${getUrgencyColor(report.urgency)}`}>
                      {t(`reports.urgency.${report.urgency}`)}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`inline-flex px-3 py-1 rounded-full text-xs font-medium border ${getStatusColor(report.status)}`}>
                      {report.status === 'inProgress' ? 'In Progress' : t(`reports.filter.${report.status}`)}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700 dark:text-gray-300">
                    {new Date(report.dateSubmitted).toLocaleDateString()}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-right text-sm">
                    <div className="flex items-center justify-end space-x-2">
                      <button className="p-2 text-gray-500 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-400/10 rounded-lg transition-colors">
                        <Eye className="h-4 w-4" />
                      </button>
                      <button className="p-2 text-gray-500 dark:text-gray-400 hover:text-green-600 dark:hover:text-green-400 hover:bg-green-50 dark:hover:bg-green-400/10 rounded-lg transition-colors">
                        <Edit className="h-4 w-4" />
                      </button>
                      <button className="p-2 text-gray-500 dark:text-gray-400 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-400/10 rounded-lg transition-colors">
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        {totalPages > 1 && (
          <div className="px-6 py-4 border-t border-blue-200 dark:border-slate-700 flex items-center justify-between">
            <div className="text-sm text-gray-600 dark:text-gray-400">
              Showing {(currentPage - 1) * itemsPerPage + 1} to {Math.min(currentPage * itemsPerPage, filteredReports.length)} of {filteredReports.length} reports
            </div>
            <div className="flex items-center space-x-2">
              <button
                onClick={() => setCurrentPage(prev => Math.max(1, prev - 1))}
                disabled={currentPage === 1}
                className="px-3 py-2 text-sm bg-blue-50 dark:bg-slate-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-blue-100 dark:hover:bg-slate-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              >
                Previous
              </button>
              {Array.from({ length: totalPages }, (_, i) => i + 1).map(page => (
                <button
                  key={page}
                  onClick={() => setCurrentPage(page)}
                  className={`px-3 py-2 text-sm rounded-lg transition-colors ${
                    currentPage === page
                      ? 'bg-blue-600 text-white'
                      : 'bg-blue-50 dark:bg-slate-700 text-gray-700 dark:text-gray-300 hover:bg-blue-100 dark:hover:bg-slate-600'
                  }`}
                >
                  {page}
                </button>
              ))}
              <button
                onClick={() => setCurrentPage(prev => Math.min(totalPages, prev + 1))}
                disabled={currentPage === totalPages}
                className="px-3 py-2 text-sm bg-blue-50 dark:bg-slate-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-blue-100 dark:hover:bg-slate-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              >
                Next
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default ReportsPage;