import React, { useState } from 'react';
import { MapPin, Layers, Satellite } from 'lucide-react';
import { mockReports } from '../data/mockData';
import { useLanguage } from '../contexts/LanguageContext';

interface MapProps {
  className?: string;
}

const Map: React.FC<MapProps> = ({ className = '' }) => {
  const [viewMode, setViewMode] = useState<'normal' | 'heatmap' | 'satellite'>('normal');
  const { t } = useLanguage();

  const getUrgencyColor = (urgency: string) => {
    switch (urgency) {
      case 'high': return 'bg-red-500';
      case 'medium': return 'bg-yellow-500';
      case 'low': return 'bg-green-500';
      default: return 'bg-blue-500';
    }
  };

  const getUrgencyHeat = (urgency: string) => {
    switch (urgency) {
      case 'high': return 'bg-red-500/80';
      case 'medium': return 'bg-yellow-500/60';
      case 'low': return 'bg-green-500/40';
      default: return 'bg-blue-500/50';
    }
  };

  return (
    <div className={`relative bg-slate-800 rounded-xl overflow-hidden ${className}`}>
      {/* Map Controls */}
      <div className="absolute top-4 right-4 z-10 flex space-x-2">
        <button
          onClick={() => setViewMode('normal')}
          className={`p-2 rounded-lg transition-colors ${
            viewMode === 'normal' 
              ? 'bg-blue-600 text-white' 
              : 'bg-slate-700 text-gray-300 hover:bg-slate-600'
          }`}
          title="Normal View"
        >
          <MapPin className="h-4 w-4" />
        </button>
        <button
          onClick={() => setViewMode('heatmap')}
          className={`p-2 rounded-lg transition-colors ${
            viewMode === 'heatmap' 
              ? 'bg-blue-600 text-white' 
              : 'bg-slate-700 text-gray-300 hover:bg-slate-600'
          }`}
          title={t('dashboard.heatmapView')}
        >
          <Layers className="h-4 w-4" />
        </button>
        <button
          onClick={() => setViewMode('satellite')}
          className={`p-2 rounded-lg transition-colors ${
            viewMode === 'satellite' 
              ? 'bg-blue-600 text-white' 
              : 'bg-slate-700 text-gray-300 hover:bg-slate-600'
          }`}
          title={t('dashboard.satelliteView')}
        >
          <Satellite className="h-4 w-4" />
        </button>
      </div>

      {/* Mock Map Background */}
      <div className="w-full h-full bg-gradient-to-br from-slate-700 to-slate-900 relative">
        {/* Grid Pattern */}
        <div className="absolute inset-0 opacity-10">
          <div className="grid grid-cols-8 grid-rows-6 h-full w-full">
            {Array.from({ length: 48 }).map((_, i) => (
              <div key={i} className="border border-slate-600"></div>
            ))}
          </div>
        </div>

        {/* Street Pattern */}
        <div className="absolute inset-0">
          <div className="absolute top-1/4 left-0 right-0 h-1 bg-slate-600"></div>
          <div className="absolute top-2/4 left-0 right-0 h-1 bg-slate-600"></div>
          <div className="absolute top-3/4 left-0 right-0 h-1 bg-slate-600"></div>
          <div className="absolute left-1/4 top-0 bottom-0 w-1 bg-slate-600"></div>
          <div className="absolute left-2/4 top-0 bottom-0 w-1 bg-slate-600"></div>
          <div className="absolute left-3/4 top-0 bottom-0 w-1 bg-slate-600"></div>
        </div>

        {/* Report Markers */}
        {mockReports.map((report, index) => {
          const x = (index % 5) * 18 + 10;
          const y = Math.floor(index / 5) * 25 + 20;

          if (viewMode === 'heatmap') {
            return (
              <div
                key={report.id}
                className={`absolute w-16 h-16 rounded-full ${getUrgencyHeat(report.urgency)} blur-sm`}
                style={{ left: `${x}%`, top: `${y}%` }}
              />
            );
          }

          return (
            <div
              key={report.id}
              className="absolute transform -translate-x-1/2 -translate-y-1/2 group cursor-pointer"
              style={{ left: `${x}%`, top: `${y}%` }}
            >
              <div className={`w-4 h-4 rounded-full ${getUrgencyColor(report.urgency)} border-2 border-white shadow-lg animate-pulse`} />
              
              {/* Tooltip */}
              <div className="absolute bottom-6 left-1/2 transform -translate-x-1/2 bg-slate-900 text-white px-2 py-1 rounded text-xs opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-20">
                {report.location}
                <div className="text-xs text-gray-400">
                  {report.urgency.toUpperCase()} - {report.status}
                </div>
              </div>
            </div>
          );
        })}

        {/* Center Label */}
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="bg-slate-900/80 backdrop-blur-sm text-white px-4 py-2 rounded-lg">
            <div className="text-sm font-medium">Interactive Map View</div>
            <div className="text-xs text-gray-400 mt-1">
              {viewMode === 'heatmap' ? 'Heatmap Mode' : 
               viewMode === 'satellite' ? 'Satellite View' : 'Normal View'}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Map;