// Firebase service to handle authentication and database operations
import { 
  auth, 
  firestore,
  storage
} from '../firebase';
import { 
  signInWithEmailAndPassword, 
  createUserWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
  User,
  updateProfile,
  sendEmailVerification
} from 'firebase/auth';
import { 
  doc, 
  setDoc, 
  getDoc, 
  collection,
  serverTimestamp,
  SetOptions
} from 'firebase/firestore';

export interface UserProfile {
  uid: string;
  email: string;
  displayName?: string;
  role: string;
  createdAt: any;
}

export class FirebaseService {
  // Authentication methods
  static async signUp(email: string, password: string, role: string): Promise<User | null> {
    try {
      const userCredential = await createUserWithEmailAndPassword(auth, email, password);
      const user = userCredential.user;

      if (user) {
        // Update display name
        await updateProfile(user, {
          displayName: role
        });

        // Send email verification
        await sendEmailVerification(user);

        // Store user profile in Firestore
        try {
          await setDoc(doc(firestore, 'users', user.uid), {
            email: user.email,
            role: role,
            displayName: user.displayName || role,
            createdAt: serverTimestamp(),
          } as Omit<UserProfile, 'uid'>, { merge: true } as SetOptions);
        } catch (firestoreError) {
          console.error('Firestore write failed:', firestoreError);
          // Non-fatal error, continue
        }
      }

      return user;
    } catch (error: any) {
      throw new Error(error.message || error.code);
    }
  }

  static async signIn(email: string, password: string): Promise<User | null> {
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      return userCredential.user;
    } catch (error: any) {
      throw new Error(error.message || error.code);
    }
  }

  static async signOut(): Promise<void> {
    await signOut(auth);
  }

  static getCurrentUser(): User | null {
    return auth.currentUser;
  }

  static onAuthStateChanged(callback: (user: User | null) => void) {
    return onAuthStateChanged(auth, callback);
  }

  // User profile methods
  static async getUserProfile(uid: string): Promise<UserProfile | null> {
    try {
      const docRef = doc(firestore, 'users', uid);
      const docSnap = await getDoc(docRef);
      
      if (docSnap.exists()) {
        return { uid, ...docSnap.data() } as UserProfile;
      }
      return null;
    } catch (error) {
      console.error('Error fetching user profile:', error);
      return null;
    }
  }
}