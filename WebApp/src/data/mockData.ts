export interface Report {
  id: string;
  location: string;
  urgency: 'low' | 'medium' | 'high';
  status: 'pending' | 'inProgress' | 'resolved';
  dateSubmitted: string;
  coordinates: { lat: number; lng: number };
  description: string;
}

export const mockReports: Report[] = [
  {
    id: 'RPT-001',
    location: 'Main Street & 1st Ave',
    urgency: 'high',
    status: 'pending',
    dateSubmitted: '2025-01-15',
    coordinates: { lat: 40.7128, lng: -74.0060 },
    description: 'Pothole causing traffic issues'
  },
  {
    id: 'RPT-002',
    location: 'Central Park',
    urgency: 'medium',
    status: 'inProgress',
    dateSubmitted: '2025-01-14',
    coordinates: { lat: 40.7829, lng: -73.9654 },
    description: 'Broken streetlight'
  },
  {
    id: 'RPT-003',
    location: 'City Hall Plaza',
    urgency: 'low',
    status: 'resolved',
    dateSubmitted: '2025-01-13',
    coordinates: { lat: 40.7589, lng: -73.9851 },
    description: 'Graffiti removal required'
  },
  {
    id: 'RPT-004',
    location: 'Broadway & 42nd St',
    urgency: 'high',
    status: 'pending',
    dateSubmitted: '2025-01-12',
    coordinates: { lat: 40.7580, lng: -73.9855 },
    description: 'Water pipe leak'
  },
  {
    id: 'RPT-005',
    location: 'Washington Square Park',
    urgency: 'medium',
    status: 'inProgress',
    dateSubmitted: '2025-01-11',
    coordinates: { lat: 40.7308, lng: -73.9973 },
    description: 'Damaged bench'
  }
];

export const analyticsData = {
  totalReports: 45,
  pendingReports: 12,
  resolvedReports: 28,
  inProgressReports: 5,
  urgencyDistribution: [
    { name: 'Low', value: 15, color: '#10B981' },
    { name: 'Medium', value: 20, color: '#F59E0B' },
    { name: 'High', value: 10, color: '#EF4444' }
  ],
  statusDistribution: [
    { name: 'Pending', value: 12, color: '#F59E0B' },
    { name: 'In Progress', value: 5, color: '#3B82F6' },
    { name: 'Resolved', value: 28, color: '#10B981' }
  ],
  monthlyData: [
    { month: 'Jan', reports: 35 },
    { month: 'Feb', reports: 42 },
    { month: 'Mar', reports: 38 },
    { month: 'Apr', reports: 45 },
    { month: 'May', reports: 52 },
    { month: 'Jun', value: 48 }
  ]
};