// Report service to handle report CRUD operations with Firestore
import { 
  collection,
  addDoc,
  getDocs,
  doc,
  updateDoc,
  deleteDoc,
  query,
  orderBy,
  where,
  limit,
  serverTimestamp,
  DocumentReference,
  QuerySnapshot,
  DocumentData,
  onSnapshot,
  Unsubscribe
} from 'firebase/firestore';
import { firestore } from '../firebase';
import { FirebaseService } from './FirebaseService';

export interface Report {
  id?: string;
  userId: string;
  description: string;
  location: string;
  tags: string[];
  imageUrls: string[];
  audioUrl?: string;
  status: 'pending' | 'inProgress' | 'resolved';
  priority?: 'low' | 'medium' | 'high';
  submittedBy?: string;
  createdAt: any;
  updatedAt: any;
  coordinates?: { lat: number; lng: number };
  assignedDepartment?: string;
  resolvedImageUrl?: string;
}

export interface AnalyticsData {
  totalReports: number;
  pendingReports: number;
  resolvedReports: number;
  inProgressReports: number;
  urgencyDistribution: Array<{ name: string; value: number; color: string }>;
  statusDistribution: Array<{ name: string; value: number; color: string }>;
  monthlyData: Array<{ month: string; reports: number }>;
}

export class ReportService {
  private static readonly COLLECTION_NAME = 'reports';

  // Create a new report
  static async addReport(reportData: Omit<Report, 'id' | 'createdAt' | 'updatedAt'>): Promise<DocumentReference> {
    const user = FirebaseService.getCurrentUser();
    if (!user) {
      throw new Error('Not authenticated. Please sign in.');
    }

    const docData = {
      ...reportData,
      userId: user.uid,
      status: reportData.status || 'pending',
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    };

    return await addDoc(collection(firestore, this.COLLECTION_NAME), docData);
  }

  // Get all reports with optional filtering
  static async getReports(filters?: {
    status?: string;
    priority?: string;
    userId?: string;
    limit?: number;
  }): Promise<Report[]> {
    try {
      let q = query(
        collection(firestore, this.COLLECTION_NAME),
        orderBy('createdAt', 'desc')
      );

      // Apply filters
      if (filters?.status && filters.status !== 'all') {
        q = query(q, where('status', '==', filters.status));
      }
      if (filters?.priority && filters.priority !== 'all') {
        q = query(q, where('priority', '==', filters.priority));
      }
      if (filters?.userId) {
        q = query(q, where('userId', '==', filters.userId));
      }
      if (filters?.limit) {
        q = query(q, limit(filters.limit));
      }

      const querySnapshot: QuerySnapshot<DocumentData> = await getDocs(q);
      const reports: Report[] = [];
      
      querySnapshot.forEach((doc: any) => {
        reports.push({ 
          id: doc.id, 
          ...doc.data() 
        } as Report);
      });

      return reports;
    } catch (error) {
      console.error('Error fetching reports:', error);
      throw error;
    }
  }

  // Get reports with real-time updates
  static onReportsChange(
    callback: (reports: Report[]) => void,
    filters?: {
      status?: string;
      priority?: string;
      userId?: string;
      limit?: number;
    }
  ): Unsubscribe {
    let q = query(
      collection(firestore, this.COLLECTION_NAME),
      orderBy('createdAt', 'desc')
    );

    // Apply filters
    if (filters?.status && filters.status !== 'all') {
      q = query(q, where('status', '==', filters.status));
    }
    if (filters?.priority && filters.priority !== 'all') {
      q = query(q, where('priority', '==', filters.priority));
    }
    if (filters?.userId) {
      q = query(q, where('userId', '==', filters.userId));
    }
    if (filters?.limit) {
      q = query(q, limit(filters.limit));
    }

    return onSnapshot(q, (querySnapshot: any) => {
      const reports: Report[] = [];
      querySnapshot.forEach((doc: any) => {
        reports.push({ 
          id: doc.id, 
          ...doc.data() 
        } as Report);
      });
      callback(reports);
    });
  }

  // Update report status
  static async updateReportStatus(reportId: string, status: string, additionalData?: Partial<Report>): Promise<void> {
    const reportRef = doc(firestore, this.COLLECTION_NAME, reportId);
    await updateDoc(reportRef, {
      status,
      updatedAt: serverTimestamp(),
      ...additionalData
    });
  }

  // Assign department to report
  static async assignDepartment(reportId: string, departmentId: string): Promise<void> {
    const reportRef = doc(firestore, this.COLLECTION_NAME, reportId);
    await updateDoc(reportRef, {
      assignedDepartment: departmentId,
      status: 'inProgress', // Automatically set to in progress when assigned
      updatedAt: serverTimestamp()
    });
  }

  // Mark report as resolved with photo
  static async resolveReport(reportId: string, resolvedImageUrl: string): Promise<void> {
    const reportRef = doc(firestore, this.COLLECTION_NAME, reportId);
    await updateDoc(reportRef, {
      status: 'resolved',
      resolvedImageUrl,
      updatedAt: serverTimestamp()
    });
  }

  // Delete a report
  static async deleteReport(reportId: string): Promise<void> {
    const user = FirebaseService.getCurrentUser();
    if (!user) {
      throw new Error('Not authenticated. Please sign in.');
    }

    await deleteDoc(doc(firestore, this.COLLECTION_NAME, reportId));
  }

  // Get analytics data
  static async getAnalyticsData(): Promise<AnalyticsData> {
    try {
      const reports = await this.getReports();
      
      const totalReports = reports.length;
      const pendingReports = reports.filter(r => r.status === 'pending').length;
      const inProgressReports = reports.filter(r => r.status === 'inProgress').length;
      const resolvedReports = reports.filter(r => r.status === 'resolved').length;

      // Priority distribution
      const highPriority = reports.filter(r => r.priority === 'high').length;
      const mediumPriority = reports.filter(r => r.priority === 'medium').length;
      const lowPriority = reports.filter(r => r.priority === 'low').length;

      // Monthly data (last 6 months)
      const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      const now = new Date();
      const monthlyData = [];
      
      for (let i = 5; i >= 0; i--) {
        const date = new Date(now.getFullYear(), now.getMonth() - i, 1);
        const monthName = monthNames[date.getMonth()];
        const monthReports = reports.filter(report => {
          if (report.createdAt && report.createdAt.seconds) {
            const reportDate = new Date(report.createdAt.seconds * 1000);
            return reportDate.getMonth() === date.getMonth() && 
                   reportDate.getFullYear() === date.getFullYear();
          }
          return false;
        }).length;
        
        monthlyData.push({ month: monthName, reports: monthReports });
      }

      return {
        totalReports,
        pendingReports,
        resolvedReports,
        inProgressReports,
        urgencyDistribution: [
          { name: 'Low', value: lowPriority, color: '#10B981' },
          { name: 'Medium', value: mediumPriority, color: '#F59E0B' },
          { name: 'High', value: highPriority, color: '#EF4444' }
        ],
        statusDistribution: [
          { name: 'Pending', value: pendingReports, color: '#F59E0B' },
          { name: 'In Progress', value: inProgressReports, color: '#3B82F6' },
          { name: 'Resolved', value: resolvedReports, color: '#10B981' }
        ],
        monthlyData
      };
    } catch (error) {
      console.error('Error fetching analytics data:', error);
      throw error;
    }
  }

  // Get user's reports
  static async getUserReports(userId?: string): Promise<Report[]> {
    const user = FirebaseService.getCurrentUser();
    if (!user && !userId) {
      throw new Error('Not authenticated. Please sign in.');
    }

    return this.getReports({ userId: userId || user!.uid });
  }
}