// src/contexts/LanguageContext.tsx
import React, { createContext, useContext, useState, ReactNode } from 'react';

export type Language = 'en' | 'hi';

interface LanguageContextType {
  language: Language;
  setLanguage: (lang: Language) => void;
  t: (key: string) => string;
}

const translations: Record<Language, Record<string, string>> = {
  en: {
    // Navigation
    'nav.home': 'Home',
    'nav.features': 'Features',
    'nav.howItWorks': 'How It Works',
    'nav.about': 'About',
    'nav.dashboard': 'Dashboard',
    'nav.staffLogin': 'Staff Login',
    'nav.reports': 'Reports',
    'nav.analytics': 'Analytics',
    'nav.settings': 'Settings',

    // Landing Page
    'landing.hero.title': 'Government Staff',
    'landing.hero.subtitle': 'Management Portal',
    'landing.hero.description':
      'Streamline civic operations with our comprehensive dashboard. Manage reports, analyze data, and serve your community more effectively.',
    'landing.hero.accessDashboard': 'Access Dashboard',
    'landing.hero.learnMore': 'Learn More',
    'landing.features.title': 'Powerful Features for Government Staff',
    'landing.features.reports.title': 'Report Management',
    'landing.features.reports.desc': 'Track and manage citizen reports efficiently',
    'landing.features.analytics.title': 'Data Analytics',
    'landing.features.analytics.desc': 'Gain insights with comprehensive analytics',
    'landing.features.collaboration.title': 'Team Collaboration',
    'landing.features.collaboration.desc': 'Work together seamlessly across departments',

    // How It Works Section
    'landing.howItWorks.title': 'How It Works',
    'landing.howItWorks.subtitle': 'A streamlined process from issue reporting to resolution',
    'landing.howItWorks.step1.title': 'Report Issues',
    'landing.howItWorks.step1.desc':
      'Citizens report civic issues through our platform with photos and location data.',
    'landing.howItWorks.step2.title': 'Track Progress',
    'landing.howItWorks.step2.desc':
      'Staff members receive, assign, and track the progress of each reported issue with real-time analytics.',
    'landing.howItWorks.step3.title': 'Resolve & Update',
    'landing.howItWorks.step3.desc':
      'Issues are resolved efficiently with real-time updates sent to all stakeholders and automatic notifications.',

    // Aliases matching LandingPage keys (keeps backwards compatibility)
    'landing.how.title': 'How It Works',
    'landing.how.desc': 'A streamlined process from issue reporting to resolution',
    'landing.how.step1': 'Report Issues',
    'landing.how.step1Desc': 'Citizens report civic issues through our platform with photos and location data.',
    'landing.how.step2': 'Track Progress',
    'landing.how.step2Desc': 'Staff members receive, assign, and track the progress of each reported issue with real-time analytics.',
    'landing.how.step3': 'Resolve & Update',
    'landing.how.step3Desc': 'Issues are resolved efficiently with real-time updates sent to all stakeholders and automatic notifications.',

    // CTA (ADDED)
    'landing.cta.title': 'Ready to Transform Your Civic Operations?',
    'landing.cta.subtitle':
      'Join thousands of government staff using our platform to serve their communities better.',
    'landing.cta.button': 'Get Started Today',

    // About
    'about.title': 'About Civic Dashboard',
    'about.desc': 'Civic Dashboard helps governments track, manage, and resolve issues reported by citizens — improving transparency, speed, and trust.',
    'about.cta': 'Access Dashboard',

    // Auth
    'auth.login': 'Login',
    'auth.signup': 'Sign Up',
    'auth.email': 'Email Address',
    'auth.enterEmail': 'Enter your email address',
    'auth.sendOTP': 'Send OTP',
    'auth.otp': 'OTP Code',
    'auth.enterOTP': 'Enter 6-digit OTP',
    'auth.verify': 'Verify & Login',
    'auth.backToEmail': 'Back to Email',
    'auth.otpSent': 'OTP sent to your email',
    'auth.invalidOTP': 'Invalid OTP. Use 123456 for demo.',
    'auth.welcome': 'Welcome Back',

    // Dashboard
    'dashboard.welcome': 'Welcome Back',
    'dashboard.totalReports': 'Total Reports',
    'dashboard.pendingReports': 'Pending',
    'dashboard.resolvedReports': 'Resolved',
    'dashboard.heatmapView': 'Heatmap View',
    'dashboard.satelliteView': 'Satellite View',

    // Reports
    'reports.title': 'Reports Management',
    'reports.search': 'Search reports...',
    'reports.filter.all': 'All Status',
    'reports.filter.pending': 'Pending',
    'reports.filter.inProgress': 'In Progress',
    'reports.filter.resolved': 'Resolved',
    'reports.urgency.low': 'Low',
    'reports.urgency.medium': 'Medium',
    'reports.urgency.high': 'High',
    'reports.id': 'Report ID',
    'reports.location': 'Location',
    'reports.urgency': 'Urgency',
    'reports.status': 'Status',
    'reports.date': 'Date Submitted',

    // Analytics
    'analytics.title': 'Analytics Dashboard',
    'analytics.overview': 'Overview',
    'analytics.urgencyDistribution': 'Urgency Distribution',
    'analytics.statusDistribution': 'Status Distribution',
    'analytics.monthlyTrends': 'Monthly Trends',

    // Settings
    'settings.title': 'Settings',
    'settings.profile': 'Profile Information',
    'settings.name': 'Full Name',
    'settings.email': 'Email Address',
    'settings.preferences': 'Preferences',
    'settings.language': 'Language',
    'settings.theme': 'Theme',
    'settings.light': 'Light',
    'settings.dark': 'Dark',
    'settings.notifications': 'Notifications',
    'settings.logout': 'Logout',
    'settings.save': 'Save Changes',
  },

  hi: {
    // Navigation
    'nav.home': 'होम',
    'nav.features': 'विशेषताएं',
    'nav.howItWorks': 'कैसे काम करता है',
    'nav.about': 'के बारे में',
    'nav.dashboard': 'डैशबोर्ड',
    'nav.staffLogin': 'स्टाफ लॉगिन',
    'nav.reports': 'रिपोर्ट्स',
    'nav.analytics': 'एनालिटिक्स',
    'nav.settings': 'सेटिंग्स',

    // Landing Page
    'landing.hero.title': 'सरकारी कर्मचारी',
    'landing.hero.subtitle': 'प्रबंधन पोर्टल',
    'landing.hero.description':
      'हमारे व्यापक डैशबोर्ड के साथ नागरिक संचालन को सुव्यवस्थित करें। रिपोर्ट प्रबंधित करें, डेटा का विश्लेषण करें, और अपने समुदाय की अधिक प्रभावी रूप से सेवा करें।',
    'landing.hero.accessDashboard': 'डैशबोर्ड एक्सेस करें',
    'landing.hero.learnMore': 'और जानें',
    'landing.features.title': 'सरकारी कर्मचारियों के लिए शक्तिशाली सुविधाएं',
    'landing.features.reports.title': 'रिपोर्ट प्रबंधन',
    'landing.features.reports.desc': 'नागरिक रिपोर्ट्स को कुशलता से ट्रैक और प्रबंधित करें',
    'landing.features.analytics.title': 'डेटा एनालिटिक्स',
    'landing.features.analytics.desc': 'व्यापक एनालिटिक्स के साथ अंतर्दृष्टि प्राप्त करें',
    'landing.features.collaboration.title': 'टीम सहयोग',
    'landing.features.collaboration.desc': 'विभागों में निर्बाध रूप से मिलकर काम करें',

    // How It Works Section
    'landing.howItWorks.title': 'यह कैसे काम करता है',
    'landing.howItWorks.subtitle': 'मुद्दे की रिपोर्टिंग से लेकर समाधान तक एक सुव्यवस्थित प्रक्रिया',
    'landing.howItWorks.step1.title': 'समस्याओं की रिपोर्ट करें',
    'landing.howItWorks.step1.desc':
      'नागरिक हमारे प्लेटफॉर्म के माध्यम से फोटो और स्थान डेटा के साथ नागरिक मुद्दों की रिपोर्ट करते हैं।',
    'landing.howItWorks.step2.title': 'प्रगति को ट्रैक करें',
    'landing.howItWorks.step2.desc':
      'कर्मचारी सदस्य वास्तविक समय के एनालिटिक्स के साथ प्रत्येक रिपोर्ट किए गए मुद्दे की प्रगति प्राप्त करते हैं, सौंपते हैं और ट्रैक करते हैं।',
    'landing.howItWorks.step3.title': 'समाधान और अपडेट',
    'landing.howItWorks.step3.desc':
      'सभी हितधारकों को भेजे गए वास्तविक समय के अपडेट और स्वचालित सूचनाओं के साथ मुद्दों को कुशलतापूर्वक हल किया जाता है।',

    // Aliases matching LandingPage keys (keeps backwards compatibility)
    'landing.how.title': 'यह कैसे काम करता है',
    'landing.how.desc': 'मुद्दे की रिपोर्टिंग से लेकर समाधान तक एक सुव्यवस्थित प्रक्रिया',
    'landing.how.step1': 'समस्याओं की रिपोर्ट करें',
    'landing.how.step1Desc': 'नागरिक हमारे प्लेटफॉर्म के माध्यम से फोटो और स्थान डेटा के साथ नागरिक मुद्दों की रिपोर्ट करते हैं।',
    'landing.how.step2': 'प्रगति को ट्रैक करें',
    'landing.how.step2Desc': 'कर्मचारी सदस्य वास्तविक समय के एनालिटिक्स के साथ प्रत्येक रिपोर्ट किए गए मुद्दे की प्रगति प्राप्त करते हैं, सौंपते हैं और ट्रैक करते हैं।',
    'landing.how.step3': 'समाधान और अपडेट',
    'landing.how.step3Desc': 'सभी हितधारकों को भेजे गए वास्तविक समय के अपडेट और स्वचालित सूचनाओं के साथ मुद्दों को कुशलतापूर्वक हल किया जाता है।',

    // CTA (ADDED)
    'landing.cta.title': 'क्या आप अपनी नागरिक संचालन प्रणाली को बदलने के लिए तैयार हैं?',
    'landing.cta.subtitle': 'हजारों सरकारी कर्मचारी पहले से ही हमारे प्लेटफॉर्म का उपयोग कर रहे हैं।',
    'landing.cta.button': 'आज ही शुरू करें',

  // About
  'about.title': 'Civic Dashboard के बारे में',
  'about.desc': 'Civic Dashboard सरकारों को नागरिकों द्वारा रिपोर्ट किए गए मुद्दों को ट्रैक, प्रबंधित और हल करने में मदद करता है — पारदर्शिता, गति और भरोसा बढ़ाता है।',
  'about.cta': 'डैशबोर्ड एक्सेस करें',

    // Auth
    'auth.login': 'लॉग इन',
    'auth.signup': 'साइन अप',
    'auth.email': 'ईमेल पता',
    'auth.enterEmail': 'अपना ईमेल पता दर्ज करें',
    'auth.sendOTP': 'OTP भेजें',
    'auth.otp': 'OTP कोड',
    'auth.enterOTP': '6-अंकीय OTP दर्ज करें',
    'auth.verify': 'सत्यापित करें और लॉगिन करें',
    'auth.backToEmail': 'ईमेल पर वापस जाएं',
    'auth.otpSent': 'आपके ईमेल पर OTP भेजा गया',
    'auth.invalidOTP': 'अमान्य OTP। डेमो के लिए 123456 का उपयोग करें।',
    'auth.welcome': 'वापस स्वागत है',

    // Dashboard
    'dashboard.welcome': 'वापस स्वागत है',
    'dashboard.totalReports': 'कुल रिपोर्ट्स',
    'dashboard.pendingReports': 'लंबित',
    'dashboard.resolvedReports': 'हल किए गए',
    'dashboard.heatmapView': 'हीटमैप व्यू',
    'dashboard.satelliteView': 'सैटेलाइट व्यू',

    // Reports
    'reports.title': 'रिपोर्ट्स प्रबंधन',
    'reports.search': 'रिपोर्ट्स खोजें...',
    'reports.filter.all': 'सभी स्थिति',
    'reports.filter.pending': 'लंबित',
    'reports.filter.inProgress': 'प्रगति में',
    'reports.filter.resolved': 'हल किया गया',
    'reports.urgency.low': 'कम',
    'reports.urgency.medium': 'मध्यम',
    'reports.urgency.high': 'उच्च',
    'reports.id': 'रिपोर्ट ID',
    'reports.location': 'स्थान',
    'reports.urgency': 'तात्कालिकता',
    'reports.status': 'स्थिति',
    'reports.date': 'सबमिट दिनांक',

    // Analytics
    'analytics.title': 'एनालिटिक्स डैशबोर्ड',
    'analytics.overview': 'अवलोकन',
    'analytics.urgencyDistribution': 'तात्कालिकता वितरण',
    'analytics.statusDistribution': 'स्थिति वितरण',
    'analytics.monthlyTrends': 'मासिक रुझान',

    // Settings
    'settings.title': 'सेटिंग्स',
    'settings.profile': 'प्रोफ़ाइल जानकारी',
    'settings.name': 'पूरा नाम',
    'settings.email': 'ईमेल पता',
    'settings.preferences': 'प्राथमिकताएं',
    'settings.language': 'भाषा',
    'settings.theme': 'थीम',
    'settings.light': 'लाइट',
    'settings.dark': 'डार्क',
    'settings.notifications': 'नोटिफिकेशन',
    'settings.logout': 'लॉग आउट',
    'settings.save': 'परिवर्तन सहेजें',
  },
};

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export const useLanguage = () => {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
};

export const LanguageProvider = ({ children }: { children: ReactNode }) => {
  const [language, setLanguage] = useState<Language>('en');

  const t = (key: string): string => {
    // safe lookup: return key if not found (so missing keys show as the key)
    return translations[language][key as keyof typeof translations[typeof language]] || key;
  };

  return (
    <LanguageContext.Provider value={{ language, setLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  );
};
