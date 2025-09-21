import React from 'react';
import { FileText, BarChart3, Users, ArrowRight, ChevronRight } from 'lucide-react';
import Navbar from '../components/Navbar';
import { useLanguage } from '../contexts/LanguageContext';
import useInView from '../hooks/useInView';

interface LandingPageProps {
  onLoginClick: () => void;
}

const LandingPage: React.FC<LandingPageProps> = ({ onLoginClick }) => {
  const { t } = useLanguage();

  // in-view hooks for scroll animations
  const { ref: heroRef, inView: heroInView } = useInView<HTMLDivElement>({ threshold: 0.2 });
  const { ref: statsRef, inView: statsInView } = useInView<HTMLElement>({ threshold: 0.2 });
  const { ref: featuresRef, inView: featuresInView } = useInView<HTMLElement>({ threshold: 0.15 });
  const { ref: howRef, inView: howInView } = useInView<HTMLElement>({ threshold: 0.15 });
  const { ref: ctaRef, inView: ctaInView } = useInView<HTMLElement>({ threshold: 0.2 });
  const { ref: aboutRef, inView: aboutInView } = useInView<HTMLElement>({ threshold: 0.2 });

  const features = [
    {
      icon: FileText,
      title: t('landing.features.reports.title') || "Detailed Reports",
      description: t('landing.features.reports.desc') || "Generate comprehensive civic reports instantly.",
    },
    {
      icon: BarChart3,
      title: t('landing.features.analytics.title') || "Smart Analytics",
      description: t('landing.features.analytics.desc') || "Gain insights with real-time civic data analysis.",
    },
    {
      icon: Users,
      title: t('landing.features.collaboration.title') || "Collaboration",
      description: t('landing.features.collaboration.desc') || "Work together across departments seamlessly.",
    },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-sky-50 to-cyan-50 dark:from-slate-900 dark:via-slate-800 dark:to-slate-900 dark:bg-gradient-to-br">
      <Navbar onLoginClick={onLoginClick} />
      
      {/* Hero Section */}
      <section
        id="home"
        ref={heroRef}
        className={`relative pt-20 pb-32 overflow-hidden transition-all duration-700 ${heroInView ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
      >
        {/* Background Elements */}
        <div className="absolute inset-0 bg-gradient-to-r from-blue-50/30 to-cyan-50/30 dark:from-blue-600/20 dark:to-cyan-600/20"></div>
        <div className="absolute top-20 left-20 w-72 h-72 bg-blue-100/40 dark:bg-blue-600/10 rounded-full blur-3xl"></div>
        <div className="absolute bottom-20 right-20 w-96 h-96 bg-cyan-100/40 dark:bg-cyan-600/10 rounded-full blur-3xl"></div>
        
        <div className="relative max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 dark:text-white mb-4 leading-tight">
            {t('landing.hero.title') || "Civic Dashboard"}
            <br />
            <span className="bg-gradient-to-r from-blue-400 to-cyan-400 bg-clip-text text-transparent">
              {t('landing.hero.subtitle') || "Empowering Local Governance"}
            </span>
          </h1>
          
          <p className="text-lg md:text-xl text-gray-700 dark:text-gray-300 mb-8 max-w-3xl mx-auto leading-relaxed">
            {t('landing.hero.description') || "A modern platform to streamline government operations and serve communities better."}
          </p>
          
          <div className="flex flex-col sm:flex-row gap-6 justify-center items-center">
            <button
              onClick={onLoginClick}
              className="group bg-blue-600 hover:bg-blue-700 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 transform hover:scale-105 hover:shadow-2xl flex items-center space-x-2"
            >
              <span>{t('landing.hero.accessDashboard') || "Access Dashboard"}</span>
              <ChevronRight className="h-5 w-5 group-hover:translate-x-1 transition-transform" />
            </button>
            
            <button
              onClick={(e) => {
                e.preventDefault();
                const el = document.getElementById('features');
                if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
              }}
              className="group border-2 border-gray-300 hover:border-blue-500 text-gray-700 hover:text-blue-600 dark:border-slate-600 dark:hover:border-cyan-400 dark:text-gray-300 dark:hover:text-cyan-400 px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 transform hover:scale-105"
            >
              {t('landing.hero.learnMore') || "Learn More"}
            </button>
          </div>
        </div>
      </section>
      
      {/* About Section */}
      <section
        id="about"
        ref={aboutRef}
        className={`py-24 bg-sky-50/60 dark:bg-slate-900/60 transition-all duration-700 ${aboutInView ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
      >
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white mb-4">{t('about.title') || 'About Civic Dashboard'}</h2>
          <p className="text-gray-700 dark:text-gray-300 mb-8 max-w-3xl mx-auto">
            {t('about.desc') || 'Civic Dashboard helps governments track, manage, and resolve issues reported by citizens — improving transparency, speed, and trust.'}
          </p>

          {/* CTA removed as requested */}
        </div>
      </section>
      
      

      {/* Hero Stats Row */}
      <section
        ref={statsRef}
        className={`bg-blue-50/50 dark:bg-slate-900/90 py-12 transition-all duration-700 ${statsInView ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
      >
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
            <div>
              <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-blue-100 dark:bg-blue-600/10 mb-3">
                <FileText className="w-6 h-6 text-blue-600 dark:text-blue-400" />
              </div>
              <div className="text-2xl font-bold text-gray-900 dark:text-white">10,000+</div>
              <div className="text-sm text-gray-600 dark:text-gray-400">Issues Resolved</div>
            </div>

            <div>
              <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-blue-100 dark:bg-blue-600/10 mb-3">
                <BarChart3 className="w-6 h-6 text-blue-600 dark:text-blue-400" />
              </div>
              <div className="text-2xl font-bold text-gray-900 dark:text-white">50+</div>
              <div className="text-sm text-gray-600 dark:text-gray-400">Cities Served</div>
            </div>

            <div>
              <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-blue-100 dark:bg-blue-600/10 mb-3">
                <ChevronRight className="w-6 h-6 text-blue-600 dark:text-blue-400" />
              </div>
              <div className="text-2xl font-bold text-gray-900 dark:text-white">2.3</div>
              <div className="text-sm text-gray-600 dark:text-gray-400">Avg. Resolution Days</div>
            </div>

            <div>
              <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-blue-100 dark:bg-blue-600/10 mb-3">
                <Users className="w-6 h-6 text-blue-600 dark:text-blue-400" />
              </div>
              <div className="text-2xl font-bold text-gray-900 dark:text-white">94%</div>
              <div className="text-sm text-gray-600 dark:text-gray-400">Satisfaction Rate</div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section
        id="features"
        ref={featuresRef}
        className={`py-24 bg-cyan-50/40 dark:bg-slate-900/50 transition-all duration-700 ${featuresInView ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-6">
              {t('landing.features.title') || "Platform Features"}
            </h2>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            {features.map((feature, index) => {
              const Icon = feature.icon;
              return (
                <div
                  key={index}
                  className="group bg-white/80 backdrop-blur-sm dark:bg-slate-800/50 dark:backdrop-blur-sm rounded-xl p-8 hover:bg-white dark:hover:bg-slate-800 transition-all duration-300 transform hover:scale-105 border border-blue-100 dark:border-slate-700 hover:border-blue-300 dark:hover:border-blue-500/50 shadow-lg hover:shadow-xl"
                >
                  <div className="bg-blue-50 dark:bg-blue-600/10 w-16 h-16 rounded-xl flex items-center justify-center mb-6 group-hover:bg-blue-100 dark:group-hover:bg-blue-600/20 transition-colors">
                    <Icon className="h-8 w-8 text-blue-600 dark:text-blue-400" />
                  </div>
                  
                  <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
                    {feature.title}
                  </h3>
                  
                  <p className="text-gray-700 dark:text-gray-400 group-hover:text-gray-800 dark:group-hover:text-gray-300 transition-colors">
                    {feature.description}
                  </p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* How It Works Section (dark-themed, 3 vertical cards with numbered circles) */}
      <section
        id="how-it-works"
        ref={howRef}
        className={`py-24 bg-blue-50/30 dark:bg-slate-900/40 transition-all duration-700 ${howInView ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white mb-3">
            {t('landing.how.title') || 'How It Works'}
          </h2>
          <p className="text-gray-700 dark:text-gray-300 mb-12 max-w-3xl mx-auto">
            {t('landing.how.desc') || 'A streamlined process from issue reporting to resolution.'}
          </p>

          <div className="relative">
            {/* connector line between cards (visible on md+) */}
            <div className="hidden md:block absolute left-0 right-0 top-40 mx-auto">
              <div className="w-full border-t border-blue-200/60 dark:border-slate-700/40" />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              {/* Step 1 */}
              <div className="relative bg-white/90 backdrop-blur-sm dark:bg-slate-800/60 rounded-2xl p-10 shadow-lg border border-blue-100 dark:border-transparent hover:shadow-xl transition-all duration-300">
                <div className="absolute -top-6 left-1/2 transform -translate-x-1/2">
                  <div className="w-14 h-14 rounded-full bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center text-white shadow-lg">
                    <span className="font-bold">1</span>
                  </div>
                </div>
                <div className="mt-6 flex flex-col items-center">
                  <FileText className="w-12 h-12 text-blue-600 dark:text-blue-300 mb-6" />
                  <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-3">{t('landing.how.step1') || 'Report Issues'}</h3>
                  <p className="text-gray-700 dark:text-gray-400 max-w-md">{t('landing.how.step1Desc') || 'Citizens report civic issues through our platform with location data and photos.'}</p>
                </div>
              </div>

              {/* Step 2 */}
              <div className="relative bg-white/90 backdrop-blur-sm dark:bg-slate-800/60 rounded-2xl p-10 shadow-lg border border-blue-100 dark:border-transparent hover:shadow-xl transition-all duration-300">
                <div className="absolute -top-6 left-1/2 transform -translate-x-1/2">
                  <div className="w-14 h-14 rounded-full bg-gradient-to-br from-blue-400 to-cyan-400 flex items-center justify-center text-white shadow-lg">
                    <span className="font-bold">2</span>
                  </div>
                </div>
                <div className="mt-6 flex flex-col items-center">
                  <BarChart3 className="w-12 h-12 text-blue-600 dark:text-blue-300 mb-6" />
                  <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-3">{t('landing.how.step2') || 'Track Progress'}</h3>
                  <p className="text-gray-700 dark:text-gray-400 max-w-md">{t('landing.how.step2Desc') || 'Staff receive, assign, and track the progress of each reported issue in real time.'}</p>
                </div>
              </div>

              {/* Step 3 */}
              <div className="relative bg-white/90 backdrop-blur-sm dark:bg-slate-800/60 rounded-2xl p-10 shadow-lg border border-blue-100 dark:border-transparent hover:shadow-xl transition-all duration-300">
                <div className="absolute -top-6 left-1/2 transform -translate-x-1/2">
                  <div className="w-14 h-14 rounded-full bg-gradient-to-br from-emerald-400 to-green-600 flex items-center justify-center text-white shadow-lg">
                    <span className="font-bold">3</span>
                  </div>
                </div>
                <div className="mt-6 flex flex-col items-center">
                  <Users className="w-12 h-12 text-blue-600 dark:text-blue-300 mb-6" />
                  <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-3">{t('landing.how.step3') || 'Resolve & Update'}</h3>
                  <p className="text-gray-700 dark:text-gray-400 max-w-md">{t('landing.how.step3Desc') || 'Issues are resolved efficiently with real-time updates sent to stakeholders.'}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Dashboard anchor (target for nav if login handler not provided) */}
      <div id="dashboard" aria-hidden className="h-0 w-0" />

      {/* CTA Section */}
      <section
        ref={ctaRef}
        className={`py-20 bg-gradient-to-r from-blue-600 to-cyan-600 transition-all duration-700 ${ctaInView ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
      >
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
            {t('landing.cta.title') || "Ready to Transform Your Civic Operations?"}
          </h2>
          <p className="text-xl text-blue-100 mb-8">
            {t('landing.cta.desc') || "Join thousands of government staff using our platform to serve their communities better."}
          </p>
          <button
            onClick={onLoginClick}
            className="bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg hover:bg-gray-100 transition-colors transform hover:scale-105 flex items-center space-x-2 mx-auto"
          >
            <span>{t('landing.cta.button') || "Get Started Today"}</span>
            <ArrowRight className="h-5 w-5" />
          </button>
        </div>
      </section>

      
    </div>
  );
};

export default LandingPage;
