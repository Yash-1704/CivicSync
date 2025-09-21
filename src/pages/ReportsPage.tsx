import React, { useState } from 'react';
import { Search, Filter, Eye, Edit, ChevronDown, Download, Users, CheckCircle, Upload, X } from 'lucide-react';
import { mockReports, Report } from '../data/mockData';
import { useLanguage } from '../contexts/LanguageContext';

const ReportsPage: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState<'all' | 'pending' | 'inProgress' | 'resolved'>('all');
  const [priorityFilter, setPriorityFilter] = useState<'all' | 'High' | 'Medium' | 'Low'>('all');
  const [showFilters, setShowFilters] = useState(false);
  const [reportStatuses, setReportStatuses] = useState<{[key: string]: string}>({});
  const [reportDepartments, setReportDepartments] = useState<{[key: string]: string}>({});
  const [showDepartmentDropdown, setShowDepartmentDropdown] = useState<{[key: string]: boolean}>({});
  const [showResolvedModal, setShowResolvedModal] = useState<{[key: string]: boolean}>({});
  const [resolvedPhotos, setResolvedPhotos] = useState<{[key: string]: File | null}>({});
  const [animatingReports, setAnimatingReports] = useState<{[key: string]: boolean}>({});
  const { t } = useLanguage();

  // List of departments
  const departments = [
    { id: 'pwd', name: 'Public Works Department (PWD)', icon: '🏗️' },
    { id: 'electricity', name: 'Electricity Department', icon: '⚡' },
    { id: 'water', name: 'Water Department', icon: '💧' },
    { id: 'municipality', name: 'Municipality', icon: '🏛️' },
    { id: 'sanitation', name: 'Sanitation Department', icon: '🧹' },
    { id: 'transport', name: 'Transport Department', icon: '🚌' }
  ];

  // Mock reports data with more realistic content
  const reportsData = [
    {
      id: 'RPT-001',
      submittedBy: 'Rajesh Kumar',
      priority: 'High',
      description: 'Large pothole causing damage to vehicles. Urgent repair needed.',
      status: 'Pending'
    },
    {
      id: 'RPT-002', 
      submittedBy: 'Priya Sharma',
      priority: 'Medium',
      description: 'Broken streetlight leaving parking area completely dark.',
      status: 'Pending'
    },
    {
      id: 'RPT-003',
      submittedBy: 'Amit Patel', 
      priority: 'Low',
      description: 'Large tree branch fell and is completely blocking sidewalk.',
      status: 'Pending'
    },
    {
      id: 'RPT-004',
      submittedBy: 'Sneha Gupta',
      priority: 'High', 
      description: 'Water main leak causing street flooding and traffic issues.',
      status: 'Pending'
    },
    {
      id: 'RPT-005',
      submittedBy: 'Vikash Singh',
      priority: 'Medium',
      description: 'Traffic light malfunctioning at busy intersection during peak hours.',
      status: 'Pending'
    },
    {
      id: 'RPT-006',
      submittedBy: 'Meera Joshi',
      priority: 'Low',
      description: 'Garbage bins overflowing in residential area for past 3 days.',
      status: 'Pending'
    },
    {
      id: 'RPT-007',
      submittedBy: 'Arjun Reddy',
      priority: 'High',
      description: 'Sewer system backup causing health hazard in community center.',
      status: 'Pending'
    },
    {
      id: 'RPT-008',
      submittedBy: 'Kavya Nair',
      priority: 'Medium',
      description: 'Park playground equipment damaged and unsafe for children.',
      status: 'Pending'
    },
    {
      id: 'RPT-009',
      submittedBy: 'Rohit Agarwal',
      priority: 'Low',
      description: 'Bus stop shelter roof leaking during rain causing passenger discomfort.',
      status: 'Pending'
    },
    {
      id: 'RPT-010',
      submittedBy: 'Deepa Mehta',
      priority: 'High',
      description: 'Electric pole fallen after storm blocking main road access.',
      status: 'Pending'
    }
  ];

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

  const handleStatusChange = (reportId: string, newStatus: string) => {
    if (newStatus === 'resolved') {
      // Open the resolved modal instead of directly changing status
      setShowResolvedModal(prev => ({
        ...prev,
        [reportId]: true
      }));
    } else {
      setReportStatuses(prev => ({
        ...prev,
        [reportId]: newStatus
      }));
    }
  };

  const handleResolvedSubmit = (reportId: string) => {
    const photo = resolvedPhotos[reportId];
    if (photo) {
      // Start slide animation
      setAnimatingReports(prev => ({
        ...prev,
        [reportId]: true
      }));
      
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
      
      // Close modal and reset photo
      setShowResolvedModal(prev => ({
        ...prev,
        [reportId]: false
      }));
      setResolvedPhotos(prev => ({
        ...prev,
        [reportId]: null
      }));
    }
  };

  const handlePhotoUpload = (reportId: string, file: File) => {
    setResolvedPhotos(prev => ({
      ...prev,
      [reportId]: file
    }));
  };

  const closeResolvedModal = (reportId: string) => {
    setShowResolvedModal(prev => ({
      ...prev,
      [reportId]: false
    }));
    setResolvedPhotos(prev => ({
      ...prev,
      [reportId]: null
    }));
  };

  const handleDepartmentAssignment = (reportId: string, departmentId: string) => {
    // Assign department
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
  };

  const toggleDepartmentDropdown = (reportId: string) => {
    setShowDepartmentDropdown(prev => ({
      ...prev,
      [reportId]: !prev[reportId]
    }));
  };

  const filteredReports = reportsData.filter(report => {
    const matchesSearch = report.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         report.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         report.submittedBy.toLowerCase().includes(searchTerm.toLowerCase());
    
    // Get current status for the report
    const currentStatus = reportStatuses[report.id] || 'pending';
    
    // Filter by status
    const matchesStatus = statusFilter === 'all' || currentStatus === statusFilter;
    
    // Filter by priority
    const matchesPriority = priorityFilter === 'all' || report.priority === priorityFilter;
    
    return matchesSearch && matchesStatus && matchesPriority;
  })
  .sort((a, b) => {
    // Sort resolved reports to bottom
    const aStatus = reportStatuses[a.id] || 'pending';
    const bStatus = reportStatuses[b.id] || 'pending';
    
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
              onChange={(e) => setPriorityFilter(e.target.value as 'all' | 'High' | 'Medium' | 'Low')}
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
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">REPORT ID</span>
            </div>
            <div className="col-span-2">
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">SUBMITTED BY</span>
            </div>
            <div className="col-span-2">
              <span className="text-sm font-medium text-black dark:text-gray-300 uppercase tracking-wider">PRIORITY</span>
            </div>
            <div className="col-span-3">
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
            const isAnimating = animatingReports[report.id];
            const currentStatus = reportStatuses[report.id] || 'pending';
            
            return (
              <div 
                key={report.id} 
                className={`grid grid-cols-12 gap-4 px-6 py-4 hover:bg-gray-50 dark:hover:bg-slate-700/50 transition-all duration-500 ${
                  isAnimating 
                    ? 'transform translate-x-full opacity-0 bg-green-50 dark:bg-green-900/20' 
                    : 'transform translate-x-0 opacity-100'
                } ${
                  currentStatus === 'resolved' 
                    ? 'bg-green-50 dark:bg-green-900/10 border-l-4 border-green-500' 
                    : ''
                }`}
              >
              {/* Report ID */}
              <div className="col-span-2 flex items-center">
                <span className="text-sm font-mono font-medium text-black dark:text-white">{report.id}</span>
              </div>
              
              {/* Submitted By */}
              <div className="col-span-2 flex items-center">
                <span className="text-sm text-black dark:text-white">{report.submittedBy}</span>
              </div>
              
              {/* Priority */}
              <div className="col-span-2 flex items-center">
                {getPriorityIcon(report.priority)}
              </div>
              
              {/* Description */}
              <div className="col-span-3 flex items-center">
                <div className="flex flex-col space-y-1">
                  <span className="text-sm text-black dark:text-white line-clamp-1">{report.description}</span>
                  <button className="text-xs text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 text-left flex items-center space-x-1">
                    <span>View Details</span>
                  </button>
                </div>
              </div>
              
              {/* Actions */}
              <div className="col-span-1 flex items-center space-x-2">
                {/* Eye Button with Department Info Tooltip */}
                <div className="relative group">
                  <button className="p-1.5 text-gray-500 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-400/10 rounded-lg transition-colors">
                    <Eye className="h-4 w-4" />
                  </button>
                  
                  {/* Tooltip */}
                  <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2 bg-slate-900 dark:bg-slate-700 text-white px-3 py-2 rounded-lg text-xs opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-30 pointer-events-none">
                    {reportDepartments[report.id] ? (
                      <>
                        <div className="font-semibold">Assigned to:</div>
                        <div className="flex items-center space-x-2 mt-1">
                          <span>{departments.find(d => d.id === reportDepartments[report.id])?.icon}</span>
                          <span>{departments.find(d => d.id === reportDepartments[report.id])?.name}</span>
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
                    onClick={() => toggleDepartmentDropdown(report.id)}
                    className={`p-1.5 rounded-lg transition-colors ${
                      reportDepartments[report.id] 
                        ? 'text-green-600 dark:text-green-400 hover:text-green-800 dark:hover:text-green-300 hover:bg-green-50 dark:hover:bg-green-400/10' 
                        : 'text-gray-500 dark:text-gray-400 hover:text-purple-600 dark:hover:text-purple-400 hover:bg-purple-50 dark:hover:bg-purple-400/10'
                    }`}
                    title={reportDepartments[report.id] ? 'Assigned to department' : 'Assign to department'}
                  >
                    {reportDepartments[report.id] ? <CheckCircle className="h-4 w-4" /> : <Users className="h-4 w-4" />}
                  </button>
                  
                  {/* Department Dropdown */}
                  {showDepartmentDropdown[report.id] && (
                    <>
                      {/* Backdrop */}
                      <div 
                        className="fixed inset-0 z-10" 
                        onClick={() => setShowDepartmentDropdown(prev => ({ ...prev, [report.id]: false }))}
                      />
                      
                      {/* Dropdown Menu */}
                      <div className="absolute right-0 top-8 z-20 w-64 bg-white dark:bg-slate-800 rounded-lg shadow-xl border border-slate-200 dark:border-slate-700 py-2">
                        <div className="px-3 py-2 border-b border-slate-200 dark:border-slate-700">
                          <p className="text-xs font-medium text-black dark:text-gray-400 uppercase tracking-wider">
                            Assign to Department
                          </p>
                        </div>
                        {departments.map((dept) => (
                          <button
                            key={dept.id}
                            onClick={() => handleDepartmentAssignment(report.id, dept.id)}
                            className="w-full flex items-center space-x-3 px-3 py-2 text-left text-black dark:text-gray-300 hover:bg-slate-50 dark:hover:bg-slate-700 hover:text-black dark:hover:text-white transition-colors"
                          >
                            <span className="text-lg">{dept.icon}</span>
                            <span className="text-sm">{dept.name}</span>
                          </button>
                        ))}
                      </div>
                    </>
                  )}
                </div>
              </div>
              
              {/* Status */}
              <div className="col-span-2 flex items-center">
                <div className="relative">
                  <select 
                    value={reportStatuses[report.id] || 'pending'}
                    onChange={(e) => handleStatusChange(report.id, e.target.value)}
                    className={`appearance-none px-3 py-1.5 pr-8 rounded-full text-sm font-medium border cursor-pointer hover:opacity-80 transition-colors ${
                      getStatusColor(reportStatuses[report.id] || 'pending')
                    }`}
                  >
                    <option value="pending" style={{color: 'black'}}>Pending</option>
                    <option value="inProgress" style={{color: 'black'}}>In Progress</option>
                    <option value="resolved" style={{color: 'black'}}>Resolved</option>
                  </select>
                  <ChevronDown className={`absolute right-2 top-1/2 transform -translate-y-1/2 h-3 w-3 pointer-events-none ${
                    reportStatuses[report.id] === 'resolved' ? 'text-green-600 dark:text-green-400' :
                    reportStatuses[report.id] === 'inProgress' ? 'text-blue-600 dark:text-blue-400' :
                    'text-yellow-600 dark:text-yellow-400'
                  }`} />
                </div>
              </div>
            </div>
            );
          })}
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
                  <div className="border-2 border-dashed border-gray-300 dark:border-slate-600 rounded-lg p-6 text-center">
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
                      className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
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
    </div>
  );
};

export default ReportsPage;