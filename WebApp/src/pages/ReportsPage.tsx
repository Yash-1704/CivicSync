import React, { useState, useEffect } from 'react';
import { Search, Filter, Eye, Edit, ChevronDown, Download, Users, CheckCircle, Upload, X, Image as ImageIcon, Play, Pause, Calendar, MapPin, Tag } from 'lucide-react';
import { ReportService, Report } from '../services/ReportService';
import { CloudinaryService } from '../services/CloudinaryService';
import { useLanguage } from '../contexts/LanguageContext';
import { useAuth } from '../contexts/AuthContext';

const ReportsPage: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState<'all' | 'pending' | 'inProgress' | 'resolved'>('all');
  const [priorityFilter, setPriorityFilter] = useState<'all' | 'high' | 'medium' | 'low'>('all');
  const [showFilters, setShowFilters] = useState(false);
  const [reportStatuses, setReportStatuses] = useState<{[key: string]: string}>({});
  const [reportDepartments, setReportDepartments] = useState<{[key: string]: string}>({});
  const [showDepartmentDropdown, setShowDepartmentDropdown] = useState<{[key: string]: boolean}>({});
  const [dropdownPosition, setDropdownPosition] = useState<{[key: string]: {top: number, left: number}}>({});
  const [showResolvedModal, setShowResolvedModal] = useState<{[key: string]: boolean}>({});
  const [resolvedPhotos, setResolvedPhotos] = useState<{[key: string]: File | null}>({});
  const [animatingReports, setAnimatingReports] = useState<{[key: string]: boolean}>({});
  const [reports, setReports] = useState<Report[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedReport, setSelectedReport] = useState<Report | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isPlayingAudio, setIsPlayingAudio] = useState(false);
  const { t } = useLanguage();
  const { user } = useAuth();

  // Load reports from Firebase
  useEffect(() => {
    const loadReports = async () => {
      try {
        setLoading(true);
        const fetchedReports = await ReportService.getReports();
        setReports(fetchedReports);
      } catch (error) {
        console.error('Error loading reports:', error);
        setError('Failed to load reports');
      } finally {
        setLoading(false);
      }
    };

    loadReports();
  }, []);

  // Real-time updates for reports
  useEffect(() => {
    const unsubscribe = ReportService.onReportsChange((updatedReports) => {
      setReports(updatedReports);
    });

    return () => unsubscribe();
  }, []);

  // List of departments
  const departments = [
    { id: 'pwd', name: 'Public Works Department (PWD)', icon: '🏗️' },
    { id: 'electricity', name: 'Electricity Department', icon: '⚡' },
    { id: 'water', name: 'Water Department', icon: '💧' },
    { id: 'municipality', name: 'Municipality', icon: '🏛️' },
    { id: 'sanitation', name: 'Sanitation Department', icon: '🧹' },
    { id: 'transport', name: 'Transport Department', icon: '🚌' }
  ];

  // Mock reports data with more realistic content - REMOVED - now using real Firebase data
  const reportsData = reports; // Use real reports from Firebase

  const getPriorityIcon = (priority: string) => {
    const color = priority === 'High' ? 'text-red-500' : priority === 'Medium' ? 'text-yellow-500' : 'text-green-500';
    return (
      <div className={`flex items-center space-x-1 ${color}`}>
        <div className="w-0 h-0 border-l-[4px] border-r-[4px] border-b-[6px] border-l-transparent border-r-transparent border-b-current"></div>
        <span className="text-sm font-medium">{priority}</span>
      </div>
    );
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'resolved':
        return 'bg-green-100 dark:bg-green-900/30 text-black dark:text-green-300 border-green-200 dark:border-green-700';
      case 'inProgress':
        return 'bg-blue-100 dark:bg-blue-900/30 text-black dark:text-blue-300 border-blue-200 dark:border-blue-700';
      case 'pending':
      default:
        return 'bg-yellow-100 dark:bg-yellow-900/30 text-black dark:text-yellow-300 border-yellow-200 dark:border-yellow-700';
    }
  };

  const handleStatusChange = async (reportId: string, newStatus: string) => {
    if (newStatus === 'resolved') {
      // Open the resolved modal instead of directly changing status
      setShowResolvedModal(prev => ({
        ...prev,
        [reportId]: true
      }));
    } else {
      try {
        // Update in Firebase
        await ReportService.updateReportStatus(reportId, newStatus);
        // Update local state for immediate UI feedback
        setReportStatuses(prev => ({
          ...prev,
          [reportId]: newStatus
        }));
      } catch (error) {
        console.error('Error updating report status:', error);
        // TODO: Show error message to user
      }
    }
  };

  const closeResolvedModal = (reportId: string) => {
    // Reset the status dropdown to its previous value when cancelling
    setShowResolvedModal(prev => ({
      ...prev,
      [reportId]: false
    }));
    setResolvedPhotos(prev => ({
      ...prev,
      [reportId]: null
    }));
  };

  const openReportModal = (report: Report) => {
    setSelectedReport(report);
    setIsModalOpen(true);
  };

  const closeReportModal = () => {
    setSelectedReport(null);
    setIsModalOpen(false);
    setIsPlayingAudio(false);
  };

  const toggleAudioPlayback = () => {
    const audio = document.getElementById('report-audio') as HTMLAudioElement;
    if (audio) {
      if (isPlayingAudio) {
        audio.pause();
        setIsPlayingAudio(false);
      } else {
        audio.play();
        setIsPlayingAudio(true);
      }
    }
  };

  const handleResolvedSubmit = async (reportId: string) => {
    const photo = resolvedPhotos[reportId];
    if (photo) {
      try {
        // Start slide animation
        setAnimatingReports(prev => ({
          ...prev,
          [reportId]: true
        }));
        
        // Upload photo to Cloudinary
        const resolvedImageUrl = await CloudinaryService.uploadImage(photo);
        
        if (resolvedImageUrl) {
          // Update in Firebase with resolved status and image
          await ReportService.resolveReport(reportId, resolvedImageUrl);
          
          // After animation delay, update status and move to bottom
          setTimeout(() => {
            setReportStatuses(prev => ({
              ...prev,
              [reportId]: 'resolved'
            }));
            
            // Reset animation state
            setAnimatingReports(prev => ({
              ...prev,
              [reportId]: false
            }));
          }, 500); // Animation duration
        }
        
        // Close modal and reset photo
        setShowResolvedModal(prev => ({
          ...prev,
          [reportId]: false
        }));
        setResolvedPhotos(prev => ({
          ...prev,
          [reportId]: null
        }));
      } catch (error) {
        console.error('Error resolving report:', error);
        // Reset animation on error
        setAnimatingReports(prev => ({
          ...prev,
          [reportId]: false
        }));
        // TODO: Show error message to user
      }
    }
  };

  const handlePhotoUpload = (reportId: string, file: File) => {
    setResolvedPhotos(prev => ({
      ...prev,
      [reportId]: file
    }));
  };

  const handleDepartmentAssignment = async (reportId: string, departmentId: string) => {
    try {
      // Assign department in Firebase
      await ReportService.assignDepartment(reportId, departmentId);
      
      // Update local state for immediate UI feedback
      setReportDepartments(prev => ({
        ...prev,
        [reportId]: departmentId
      }));
      
      // Automatically change status to "In Progress"
      setReportStatuses(prev => ({
        ...prev,
        [reportId]: 'inProgress'
      }));
      
      // Close dropdown
      setShowDepartmentDropdown(prev => ({
        ...prev,
        [reportId]: false
      }));
    } catch (error) {
      console.error('Error assigning department:', error);
      // TODO: Show error message to user
    }
  };

  const toggleDepartmentDropdown = (reportId: string, event?: React.MouseEvent) => {
    if (event) {
      const rect = event.currentTarget.getBoundingClientRect();
      setDropdownPosition(prev => ({
        ...prev,
        [reportId]: {
          top: rect.bottom + window.scrollY + 4,
          left: rect.right - 256 + window.scrollX // 256px is dropdown width
        }
      }));
    }
    
    setShowDepartmentDropdown(prev => ({
      ...prev,
      [reportId]: !prev[reportId]
    }));
  };

  const filteredReports = reportsData.filter(report => {
    if (!report.id) return false; // Skip reports without ID
    
    const matchesSearch = report.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         report.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         (report.submittedBy && report.submittedBy.toLowerCase().includes(searchTerm.toLowerCase()));
    
    // Get current status for the report
    const currentStatus = reportStatuses[report.id] || report.status || 'pending';
    
    // Filter by status
    const matchesStatus = statusFilter === 'all' || currentStatus === statusFilter;
    
    // Filter by priority
    const matchesPriority = priorityFilter === 'all' || report.priority === priorityFilter;
    
    return matchesSearch && matchesStatus && matchesPriority;
  })
  .sort((a, b) => {
    if (!a.id || !b.id) return 0; // Handle missing IDs
    
    // Sort resolved reports to bottom
    const aStatus = reportStatuses[a.id] || a.status || 'pending';
    const bStatus = reportStatuses[b.id] || b.status || 'pending';
    
    // Resolved items go to bottom
    if (aStatus === 'resolved' && bStatus !== 'resolved') return 1;
    if (bStatus === 'resolved' && aStatus !== 'resolved') return -1;
    
    // Within same status category, maintain original order
    return 0;
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Reports</h1>
          {loading && <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">Loading reports...</p>}
          {error && <p className="text-sm text-red-500 mt-1">{error}</p>}
        </div>
        <button className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center space-x-2">
          <Download className="h-4 w-4" />
          <span>Export Reports</span>
        </button>
      </div>

      {/* Search and Filters */}
      <div className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl p-6 border border-blue-100 dark:border-slate-700 shadow-lg">
        <div className="flex items-center space-x-4">
          {/* Search */}
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-500 dark:text-gray-400" />
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Search reports..."
              className="w-full pl-10 pr-4 py-3 bg-gray-50 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded-lg text-black dark:text-white placeholder-gray-500 dark:placeholder-gray-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
            />
          </div>

          {/* Status Filter Dropdown */}
          <div className="relative">
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value as 'all' | 'pending' | 'inProgress' | 'resolved')}
              className="px-4 py-3 bg-gray-50 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded-lg text-black dark:text-gray-300 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 min-w-[140px]"
            >
              <option value="all" style={{color: 'black'}}>All Status</option>
              <option value="pending" style={{color: 'black'}}>Pending</option>
              <option value="inProgress" style={{color: 'black'}}>In Progress</option>
              <option value="resolved" style={{color: 'black'}}>Resolved</option>
            </select>
          </div>

          {/* Priority Filter Dropdown */}
          <div className="relative">
            <select
              value={priorityFilter}
              onChange={(e) => setPriorityFilter(e.target.value as 'all' | 'high' | 'medium' | 'low')}
              className="px-4 py-3 bg-gray-50 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded-lg text-black dark:text-gray-300 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 min-w-[150px]"
            >
              <option value="all" style={{color: 'black'}}>All Priorities</option>
              <option value="High" style={{color: 'black'}}>High</option>
              <option value="Medium" style={{color: 'black'}}>Medium</option>
              <option value="Low" style={{color: 'black'}}>Low</option>
            </select>
          </div>

          {/* Clear Filters Button */}
          <button
            onClick={() => {
              setStatusFilter('all');
              setPriorityFilter('all');
            }}
            className="px-4 py-3 text-sm text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 hover:bg-blue-50 dark:hover:bg-blue-400/10 rounded-lg transition-colors whitespace-nowrap"
          >
            Clear All Filters
          </button>
        </div>
      </div>

      {/* Reports Table */}
      <div className="bg-white/80 backdrop-blur-sm dark:bg-slate-800 rounded-xl border border-blue-100 dark:border-slate-700 overflow-hidden shadow-lg">
        {/* Table Header */}
        <div className="bg-gray-50 dark:bg-slate-900/50 border-b border-gray-200 dark:border-slate-700">
          <div className="grid grid-cols-12 gap-4 px-6 py-4">
            <div className="col-span-2">
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">IMAGE</span>
            </div>
            <div className="col-span-2">
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">REPORT ID</span>
            </div>
            <div className="col-span-2">
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">SUBMITTED BY</span>
            </div>
            <div className="col-span-1">
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">PRIORITY</span>
            </div>
            <div className="col-span-2">
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">DESCRIPTION</span>
            </div>
            <div className="col-span-1">
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">ACTIONS</span>
            </div>
            <div className="col-span-2">
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">STATUS</span>
            </div>
          </div>
        </div>

        {/* Table Body */}
        <div className="divide-y divide-gray-200 dark:divide-slate-700">
          {filteredReports.map((report, index) => {
            if (!report.id) return null; // Skip reports without ID
            
            const isAnimating = animatingReports[report.id];
            const currentStatus = reportStatuses[report.id] || report.status || 'pending';
            
            return (
              <div 
                key={report.id} 
                className={`grid grid-cols-12 gap-4 px-6 py-4 hover:bg-gray-50 dark:hover:bg-slate-700/50 transition-all duration-500 cursor-pointer ${
                  isAnimating 
                    ? 'transform translate-x-full opacity-0 bg-green-50 dark:bg-green-900/20' 
                    : 'transform translate-x-0 opacity-100'
                } ${
                  currentStatus === 'resolved' 
                    ? 'bg-green-50 dark:bg-green-900/10 border-l-4 border-green-500' 
                    : ''
                }`}
                onClick={() => openReportModal(report)}
              >
              {/* Report Image */}
              <div className="col-span-2 flex items-center">
                {report.imageUrls && report.imageUrls.length > 0 ? (
                  <div className="relative">
                    <img 
                      src={report.imageUrls[0]} 
                      alt="Report" 
                      className="w-12 h-12 rounded-lg object-cover border border-gray-200 dark:border-slate-600"
                    />
                    {report.imageUrls.length > 1 && (
                      <span className="absolute -top-1 -right-1 bg-blue-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                        +{report.imageUrls.length - 1}
                      </span>
                    )}
                  </div>
                ) : (
                  <div className="w-12 h-12 rounded-lg bg-gray-200 dark:bg-slate-700 flex items-center justify-center">
                    <ImageIcon className="h-6 w-6 text-gray-400" />
                  </div>
                )}
              </div>
              
              {/* Report ID */}
              <div className="col-span-2 flex items-center">
                <span className="text-sm font-mono font-medium text-black dark:text-white">{report.id}</span>
              </div>
              
              {/* Submitted By */}
              <div className="col-span-2 flex items-center">
                <span className="text-sm text-black dark:text-white">{report.submittedBy || 'Unknown User'}</span>
              </div>
              
              {/* Priority */}
              <div className="col-span-1 flex items-center">
                {getPriorityIcon(report.priority || 'low')}
              </div>
              
              {/* Description */}
              <div className="col-span-2 flex items-center">
                <div className="flex flex-col space-y-1">
                  <span className="text-sm text-black dark:text-white line-clamp-1">{report.description}</span>
                  <div className="flex items-center space-x-2">
                    {report.audioUrl && (
                      <div className="flex items-center space-x-1 text-xs text-blue-600 dark:text-blue-400">
                        <Play className="h-3 w-3" />
                        <span>Audio</span>
                      </div>
                    )}
                    {report.imageUrls && report.imageUrls.length > 0 && (
                      <div className="flex items-center space-x-1 text-xs text-green-600 dark:text-green-400">
                        <ImageIcon className="h-3 w-3" />
                        <span>{report.imageUrls.length}</span>
                      </div>
                    )}
                  </div>
                </div>
              </div>
              
              {/* Actions */}
              <div className="col-span-1 flex items-center space-x-2" onClick={(e) => e.stopPropagation()}>
                {/* Eye Button with Department Info Tooltip */}
                <div className="relative group">
                  <button className="p-1.5 text-gray-500 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-400/10 rounded-lg transition-colors">
                    <Eye className="h-4 w-4" />
                  </button>
                  
                  {/* Tooltip */}
                  <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2 bg-slate-900 dark:bg-slate-700 text-white px-3 py-2 rounded-lg text-xs opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-30 pointer-events-none">
                    {report.id && reportDepartments[report.id] ? (
                      <>
                        <div className="font-semibold">Assigned to:</div>
                        <div className="flex items-center space-x-2 mt-1">
                          <span>{departments.find(d => d.id === reportDepartments[report.id!])?.icon}</span>
                          <span>{departments.find(d => d.id === reportDepartments[report.id!])?.name}</span>
                        </div>
                      </>
                    ) : (
                      <div>No department assigned</div>
                    )}
                    {/* Tooltip Arrow */}
                    <div className="absolute top-full left-1/2 transform -translate-x-1/2 w-0 h-0 border-l-4 border-r-4 border-t-4 border-l-transparent border-r-transparent border-t-slate-900 dark:border-t-slate-700"></div>
                  </div>
                </div>
                
                {/* Department Assignment Dropdown */}
                <div className="relative">
                  <button 
                    onClick={(e) => report.id && toggleDepartmentDropdown(report.id, e)}
                    className={`p-1.5 rounded-lg transition-colors ${
                      report.id && reportDepartments[report.id] 
                        ? 'text-green-600 dark:text-green-400 hover:text-green-800 dark:hover:text-green-300 hover:bg-green-50 dark:hover:bg-green-400/10' 
                        : 'text-gray-500 dark:text-gray-400 hover:text-purple-600 dark:hover:text-purple-400 hover:bg-purple-50 dark:hover:bg-purple-400/10'
                    }`}
                    title={report.id && reportDepartments[report.id] ? 'Assigned to department' : 'Assign to department'}
                  >
                    {report.id && reportDepartments[report.id] ? <CheckCircle className="h-4 w-4" /> : <Users className="h-4 w-4" />}
                  </button>
                </div>
              </div>
              
              {/* Status */}
              <div className="col-span-2 flex items-center" onClick={(e) => e.stopPropagation()}>
                <div className="relative">
                  <select 
                    value={reportStatuses[report.id!] || report.status || 'pending'}
                    onChange={(e) => report.id && handleStatusChange(report.id, e.target.value)}
                    className={`appearance-none px-3 py-1.5 pr-8 rounded-full text-sm font-medium border cursor-pointer hover:opacity-80 transition-colors ${
                      getStatusColor(reportStatuses[report.id!] || report.status || 'pending')
                    }`}
                  >
                    <option value="pending" style={{color: 'black'}}>Pending</option>
                    <option value="inProgress" style={{color: 'black'}}>In Progress</option>
                    <option value="resolved" style={{color: 'black'}}>Resolved</option>
                  </select>
                  <ChevronDown className={`absolute right-2 top-1/2 transform -translate-y-1/2 h-3 w-3 pointer-events-none ${
                    reportStatuses[report.id!] === 'resolved' || report.status === 'resolved' ? 'text-green-600 dark:text-green-400' :
                    reportStatuses[report.id!] === 'inProgress' || report.status === 'inProgress' ? 'text-blue-600 dark:text-blue-400' :
                    'text-yellow-600 dark:text-yellow-400'
                  }`} />
                </div>
              </div>
            </div>
            );
          }).filter(Boolean)}

        </div>
      </div>
      
      {/* Resolved Status Modal */}
      {Object.entries(showResolvedModal).map(([reportId, isOpen]) => {
        if (!isOpen) return null;
        
        const report = reportsData.find(r => r.id === reportId);
        if (!report) return null;
        
        return (
          <div key={reportId} className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div className="bg-white dark:bg-slate-800 rounded-xl p-6 max-w-md w-full mx-4 shadow-2xl">
              {/* Modal Header */}
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg font-semibold text-black dark:text-white">
                  Mark as Resolved - {reportId}
                </h3>
                <button
                  onClick={() => closeResolvedModal(reportId)}
                  className="p-1 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200"
                >
                  <X className="h-5 w-5" />
                </button>
              </div>
              
              {/* Report Info */}
              <div className="mb-4 p-3 bg-gray-50 dark:bg-slate-700 rounded-lg">
                <p className="text-sm text-black dark:text-gray-300 mb-1">
                  <span className="font-medium">Issue:</span> {report.description}
                </p>
                <p className="text-sm text-black dark:text-gray-300">
                  <span className="font-medium">Submitted by:</span> {report.submittedBy}
                </p>
              </div>
              
              {/* Photo Upload Section */}
              <div className="mb-6">
                <label className="block text-sm font-medium text-black dark:text-gray-300 mb-2">
                  Upload Photo of Resolved Issue *
                </label>
                
                {!resolvedPhotos[reportId] ? (
                  <div className="border-2 border-dashed border-gray-300 dark:border-slate-600 rounded-lg p-6 text-center relative">
                    <Upload className="h-8 w-8 text-gray-400 dark:text-gray-500 mx-auto mb-2" />
                    <p className="text-sm text-gray-600 dark:text-gray-400 mb-2">
                      Click to upload or drag and drop
                    </p>
                    <input
                      type="file"
                      accept="image/*"
                      onChange={(e) => {
                        const file = e.target.files?.[0];
                        if (file) handlePhotoUpload(reportId, file);
                      }}
                      className="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10"
                    />
                    <p className="text-xs text-gray-500 dark:text-gray-500">
                      PNG, JPG, JPEG up to 10MB
                    </p>
                  </div>
                ) : (
                  <div className="bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-700 rounded-lg p-4">
                    <div className="flex items-center space-x-3">
                      <CheckCircle className="h-5 w-5 text-green-600 dark:text-green-400" />
                      <div>
                        <p className="text-sm font-medium text-green-800 dark:text-green-300">
                          Photo uploaded successfully
                        </p>
                        <p className="text-xs text-green-600 dark:text-green-400">
                          {resolvedPhotos[reportId]?.name}
                        </p>
                      </div>
                      <button
                        onClick={() => setResolvedPhotos(prev => ({ ...prev, [reportId]: null }))}
                        className="text-green-600 dark:text-green-400 hover:text-green-800 dark:hover:text-green-200"
                      >
                        <X className="h-4 w-4" />
                      </button>
                    </div>
                  </div>
                )}
              </div>
              
              {/* Action Buttons */}
              <div className="flex space-x-3">
                <button
                  onClick={() => closeResolvedModal(reportId)}
                  className="flex-1 px-4 py-2 text-gray-700 dark:text-gray-300 bg-gray-100 dark:bg-slate-600 hover:bg-gray-200 dark:hover:bg-slate-500 rounded-lg transition-colors"
                >
                  Cancel
                </button>
                <button
                  onClick={() => handleResolvedSubmit(reportId)}
                  disabled={!resolvedPhotos[reportId]}
                  className={`flex-1 px-4 py-2 rounded-lg transition-colors ${
                    resolvedPhotos[reportId]
                      ? 'bg-green-600 hover:bg-green-700 text-white'
                      : 'bg-gray-300 dark:bg-slate-600 text-gray-500 dark:text-gray-400 cursor-not-allowed'
                  }`}
                >
                  Mark as Resolved
                </button>
              </div>
            </div>
          </div>
        );      
      })}
      
      {/* Report Detail Modal */}
      {isModalOpen && selectedReport && (
        <div className="fixed inset-0 bg-black bg-opacity-50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-white dark:bg-slate-800 rounded-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl">
            {/* Modal Header */}
            <div className="bg-blue-600 text-white p-6 rounded-t-xl">
              <div className="flex items-center justify-between">
                <div>
                  <h2 className="text-2xl font-bold">Report Details</h2>
                  <p className="text-blue-100 mt-1">Report ID: {selectedReport.id}</p>
                </div>
                <button
                  onClick={closeReportModal}
                  className="p-2 hover:bg-blue-700 rounded-lg transition-colors"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>
            </div>

            {/* Modal Content */}
            <div className="p-6 space-y-6">
              {/* Basic Info Grid */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-3">Report Information</h3>
                  <div className="space-y-3">
                    <div className="flex items-center space-x-2">
                      <Calendar className="h-4 w-4 text-gray-500" />
                      <span className="text-sm text-gray-600 dark:text-gray-400">Submitted:</span>
                      <span className="text-sm text-gray-900 dark:text-white">
                        {selectedReport.createdAt ? new Date(selectedReport.createdAt.seconds * 1000).toLocaleDateString() : 'Unknown'}
                      </span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <Users className="h-4 w-4 text-gray-500" />
                      <span className="text-sm text-gray-600 dark:text-gray-400">Submitted by:</span>
                      <span className="text-sm text-gray-900 dark:text-white">{selectedReport.submittedBy || 'Unknown'}</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <MapPin className="h-4 w-4 text-gray-500" />
                      <span className="text-sm text-gray-600 dark:text-gray-400">Location:</span>
                      <span className="text-sm text-gray-900 dark:text-white">{selectedReport.location}</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <span className="text-sm text-gray-600 dark:text-gray-400">Priority:</span>
                      {getPriorityIcon(selectedReport.priority || 'low')}
                    </div>
                    <div className="flex items-center space-x-2">
                      <span className="text-sm text-gray-600 dark:text-gray-400">Status:</span>
                      <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                        getStatusColor(selectedReport.status)
                      }`}>
                        {selectedReport.status.charAt(0).toUpperCase() + selectedReport.status.slice(1)}
                      </span>
                    </div>
                  </div>
                </div>

                <div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-3">Tags</h3>
                  <div className="flex flex-wrap gap-2">
                    {selectedReport.tags && selectedReport.tags.length > 0 ? (
                      selectedReport.tags.map((tag, index) => (
                        <span key={index} className="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-300">
                          <Tag className="h-3 w-3 mr-1" />
                          {tag}
                        </span>
                      ))
                    ) : (
                      <span className="text-sm text-gray-500 dark:text-gray-400">No tags</span>
                    )}
                  </div>
                </div>
              </div>

              {/* Description */}
              <div>
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-3">Description</h3>
                <p className="text-gray-700 dark:text-gray-300 leading-relaxed bg-gray-50 dark:bg-slate-700 p-4 rounded-lg">
                  {selectedReport.description}
                </p>
              </div>

              {/* Images */}
              {selectedReport.imageUrls && selectedReport.imageUrls.length > 0 && (
                <div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-3">Images ({selectedReport.imageUrls.length})</h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    {selectedReport.imageUrls.map((imageUrl, index) => (
                      <div key={index} className="relative group">
                        <img
                          src={imageUrl}
                          alt={`Report image ${index + 1}`}
                          className="w-full h-48 object-cover rounded-lg border border-gray-200 dark:border-slate-600 group-hover:opacity-90 transition-opacity cursor-pointer"
                          onClick={() => window.open(imageUrl, '_blank')}
                        />
                        <div className="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-20 rounded-lg transition-all flex items-center justify-center">
                          <Eye className="h-6 w-6 text-white opacity-0 group-hover:opacity-100 transition-opacity" />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Audio */}
              {selectedReport.audioUrl && (
                <div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-3">Audio Recording</h3>
                  <div className="bg-gray-50 dark:bg-slate-700 p-4 rounded-lg">
                    <div className="flex items-center space-x-4">
                      <button
                        onClick={toggleAudioPlayback}
                        className="bg-blue-600 hover:bg-blue-700 text-white p-3 rounded-full transition-colors"
                      >
                        {isPlayingAudio ? <Pause className="h-5 w-5" /> : <Play className="h-5 w-5" />}
                      </button>
                      <div className="flex-1">
                        <p className="text-sm text-gray-600 dark:text-gray-400 mb-2">
                          {isPlayingAudio ? 'Playing audio...' : 'Click to play audio recording'}
                        </p>
                        <audio
                          id="report-audio"
                          src={selectedReport.audioUrl}
                          onEnded={() => setIsPlayingAudio(false)}
                          className="w-full"
                          controls
                        />
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* Resolved Image */}
              {selectedReport.status === 'resolved' && selectedReport.resolvedImageUrl && (
                <div>
                  <h3 className="text-lg font-semibold text-green-600 dark:text-green-400 mb-3">Resolution Photo</h3>
                  <div className="bg-green-50 dark:bg-green-900/20 p-4 rounded-lg border border-green-200 dark:border-green-700">
                    <img
                      src={selectedReport.resolvedImageUrl}
                      alt="Resolution proof"
                      className="w-full max-w-md h-48 object-cover rounded-lg border border-green-300 dark:border-green-600 cursor-pointer"
                      onClick={() => window.open(selectedReport.resolvedImageUrl!, '_blank')}
                    />
                    <p className="text-sm text-green-700 dark:text-green-300 mt-2">✅ Issue has been resolved</p>
                  </div>
                </div>
              )}
            </div>

            {/* Modal Footer */}
            <div className="bg-gray-50 dark:bg-slate-700 p-6 rounded-b-xl flex justify-end space-x-3">
              <button
                onClick={closeReportModal}
                className="px-4 py-2 text-gray-700 dark:text-gray-300 bg-white dark:bg-slate-600 hover:bg-gray-50 dark:hover:bg-slate-500 rounded-lg transition-colors border border-gray-300 dark:border-slate-500"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Department Dropdown Portal - Positioned below action button */}
      {Object.entries(showDepartmentDropdown).map(([reportId, isOpen]) => {
        if (!isOpen) return null;
        
        const position = dropdownPosition[reportId];
        if (!position) return null;
        
        return (
          <div key={reportId}>
            {/* Backdrop */}
            <div 
              className="fixed inset-0 z-[100]" 
              onClick={() => setShowDepartmentDropdown(prev => ({ ...prev, [reportId]: false }))}
            />
            
            {/* Dropdown Menu - Positioned below button */}
            <div 
              className="fixed z-[101] w-64 bg-white dark:bg-slate-800 rounded-lg shadow-2xl border-2 border-slate-300 dark:border-slate-600 py-2 max-h-64 overflow-y-auto"
              style={{
                top: `${position.top}px`,
                left: `${position.left}px`
              }}
            >
              <div className="px-4 py-3 border-b border-slate-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-700">
                <p className="text-xs font-semibold text-gray-800 dark:text-gray-200 uppercase tracking-wider">
                  Assign to Department
                </p>
              </div>
              <div className="py-1">
                {departments.map((dept) => (
                  <button
                    key={dept.id}
                    onClick={() => handleDepartmentAssignment(reportId, dept.id)}
                    className="w-full flex items-center space-x-3 px-4 py-3 text-left text-gray-900 dark:text-gray-100 hover:bg-blue-50 dark:hover:bg-slate-700 hover:text-blue-900 dark:hover:text-white transition-colors border-0 bg-white dark:bg-slate-800"
                  >
                    <span className="text-lg flex-shrink-0">{dept.icon}</span>
                    <span className="text-sm font-medium truncate">{dept.name}</span>
                  </button>
                ))}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default ReportsPage;