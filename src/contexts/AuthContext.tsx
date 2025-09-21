import { createContext, useContext, useState, useEffect, ReactNode } from 'react';

interface User {
  id: string;
  name: string;
  email: string;
}

interface AuthContextType {
  user: User | null;
  login: (email: string, otp: string) => Promise<boolean>;
  register: (name: string, email: string, otp: string) => Promise<boolean>;
  logout: () => void;
  isLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const savedUser = localStorage.getItem('user');
    if (savedUser) {
      setUser(JSON.parse(savedUser));
    }
    setIsLoading(false);
  }, []);

  const login = async (email: string, otp: string): Promise<boolean> => {
    // Mock OTP validation - accept 123456
    if (otp === '123456') {
      const mockUser: User = {
        id: '1',
        name: 'Staff Member',
        email: email
      };
      setUser(mockUser);
      localStorage.setItem('user', JSON.stringify(mockUser));
      return true;
    }
    return false;
  };

  const register = async (name: string, email: string, otp: string): Promise<boolean> => {
    // Mock OTP validation for signup - accept 123456
    if (otp === '123456') {
      const newUser: User = {
        id: Date.now().toString(),
        name: name || 'New User',
        email: email
      };
      setUser(newUser);
      try {
        localStorage.setItem('user', JSON.stringify(newUser));
      } catch (e) {
        // ignore
      }
      return true;
    }
    return false;
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem('user');
  };

  return (
    <AuthContext.Provider value={{ user, login, register, logout, isLoading }}>
      {children}
    </AuthContext.Provider>
  );
};