import React, { useState, useEffect } from 'react';
import { Trophy, Award, Star, TrendingUp, Zap, Target, Crown } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';
import '../styles/credits-animations.css';

const CreditsPage: React.FC = () => {
  const { t } = useLanguage();
  const [isVisible, setIsVisible] = useState(false);
  const [animateCounters, setAnimateCounters] = useState(false);
  const [hoveredCard, setHoveredCard] = useState<string | null>(null);

  // Department Credits Data
  const departmentCredits = [
    {
      id: 'pwd',
      name: 'Public Works Department (PWD)',
      icon: '🏗️',
      credits: 450,
      resolved: 15,
      bonus: 225,
      rank: 1
    },
    {
      id: 'electricity',
      name: 'Electricity Department',
      icon: '⚡',
      credits: 380,
      resolved: 12,
      bonus: 190,
      rank: 2
    },
    {
      id: 'water',
      name: 'Water Department',
      icon: '💧',
      credits: 320,
      resolved: 10,
      bonus: 160,
      rank: 3
    },
    {
      id: 'municipality',
      name: 'Municipality',
      icon: '🏛️',
      credits: 280,
      resolved: 8,
      bonus: 140,
      rank: 4
    },
    {
      id: 'sanitation',
      name: 'Sanitation Department',
      icon: '🧹',
      credits: 210,
      resolved: 6,
      bonus: 105,
      rank: 5
    },
    {
      id: 'transport',
      name: 'Transport Department',
      icon: '🚌',
      credits: 180,
      resolved: 5,
      bonus: 90,
      rank: 6
    }
  ];

  useEffect(() => {
    setIsVisible(true);
    const timer = setTimeout(() => setAnimateCounters(true), 800);
    return () => clearTimeout(timer);
  }, []);

  // Animated counter hook
  const useAnimatedCounter = (end: number, duration: number = 2000) => {
    const [count, setCount] = useState(0);
    
    useEffect(() => {
      if (!animateCounters) return;
      
      let startTime: number;
      const animate = (currentTime: number) => {
        if (!startTime) startTime = currentTime;
        const progress = Math.min((currentTime - startTime) / duration, 1);
        
        setCount(Math.floor(progress * end));
        
        if (progress < 1) {
          requestAnimationFrame(animate);
        }
      };
      
      requestAnimationFrame(animate);
    }, [animateCounters, end, duration]);
    
    return count;
  };

  // Floating particles animation
  const FloatingParticles = () => {
    const particles = Array.from({ length: 15 }, (_, i) => ({
      id: i,
      delay: Math.random() * 4,
      duration: 3 + Math.random() * 2,
      x: Math.random() * 100,
      y: Math.random() * 100,
    }));

    return (
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {particles.map((particle) => (
          <div
            key={particle.id}
            className="absolute w-2 h-2 bg-gradient-to-r from-blue-400 to-purple-500 rounded-full opacity-60 animate-bounce"
            style={{
              left: `${particle.x}%`,
              top: `${particle.y}%`,
              animationDelay: `${particle.delay}s`,
              animationDuration: `${particle.duration}s`,
            }}
          />
        ))}
      </div>
    );
  };

  // Animated totals
  const totalCredits = departmentCredits.reduce((sum, dept) => sum + dept.credits, 0);
  const totalResolved = departmentCredits.reduce((sum, dept) => sum + dept.resolved, 0);
  const totalBonus = departmentCredits.reduce((sum, dept) => sum + dept.bonus, 0);
  
  const animatedTotalCredits = useAnimatedCounter(totalCredits);
  const animatedTotalResolved = useAnimatedCounter(totalResolved);
  const animatedTotalBonus = useAnimatedCounter(totalBonus);

  return (
    <div className="space-y-8 relative overflow-hidden">
      {/* Floating Particles Background */}
      <FloatingParticles />
      
      {/* Header with dramatic entrance */}
      <div className={`relative bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 rounded-2xl p-8 border border-purple-200 dark:border-purple-700 shadow-2xl transform transition-all duration-1000 ${
        isVisible ? 'translate-y-0 opacity-100 scale-100' : 'translate-y-10 opacity-0 scale-95'
      }`}>
        <div className="absolute inset-0 bg-gradient-to-r from-blue-600/20 to-purple-600/20 rounded-2xl blur-xl"></div>
        <div className="relative z-10">
          <div className="flex items-center justify-between">
            <div>
              <h1 className={`text-4xl font-bold text-white mb-3 transform transition-all duration-1000 delay-300 ${
                isVisible ? 'translate-x-0 opacity-100' : '-translate-x-10 opacity-0'
              }`}>
                <Crown className="inline-block mr-3 h-10 w-10 text-yellow-300 animate-pulse" />
                Department Credits & Performance
              </h1>
              <p className={`text-purple-100 text-lg transform transition-all duration-1000 delay-500 ${
                isVisible ? 'translate-x-0 opacity-100' : '-translate-x-10 opacity-0'
              }`}>
                Track department performance and monthly bonus distribution based on resolved issues.
              </p>
            </div>
            <div className={`transform transition-all duration-1000 delay-700 ${
              isVisible ? 'rotate-0 scale-100' : 'rotate-180 scale-0'
            }`}>
              <Zap className="h-16 w-16 text-yellow-300 animate-pulse" />
            </div>
          </div>
        </div>
      </div>

      {/* Credits Overview Stats with staggered animations */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {[
          { 
            icon: Trophy, 
            value: animatedTotalCredits, 
            label: 'Total Credits', 
            color: 'from-yellow-400 to-orange-500',
            bgColor: 'bg-yellow-500/20',
            delay: 'delay-200'
          },
          { 
            icon: TrendingUp, 
            value: animatedTotalResolved, 
            label: 'Issues Resolved', 
            color: 'from-green-400 to-emerald-500',
            bgColor: 'bg-green-500/20',
            delay: 'delay-400'
          },
          { 
            icon: Award, 
            value: `₹${animatedTotalBonus}`, 
            label: 'Total Bonus', 
            color: 'from-emerald-400 to-teal-500',
            bgColor: 'bg-emerald-500/20',
            delay: 'delay-600'
          },
          { 
            icon: Star, 
            value: 6, 
            label: 'Active Departments', 
            color: 'from-blue-400 to-purple-500',
            bgColor: 'bg-blue-500/20',
            delay: 'delay-800'
          }
        ].map((stat, index) => {
          const Icon = stat.icon;
          return (
            <div
              key={index}
              className={`group bg-white/90 backdrop-blur-xl dark:bg-slate-800/90 rounded-2xl p-6 border border-purple-100 dark:border-slate-700 shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-105 hover:-translate-y-2 ${
                isVisible ? `translate-y-0 opacity-100 ${stat.delay}` : 'translate-y-10 opacity-0'
              }`}
            >
              <div className="flex items-center justify-between mb-4">
                <div className={`p-4 rounded-xl ${stat.bgColor} group-hover:scale-110 transition-transform duration-300`}>
                  <Icon className={`h-8 w-8 bg-gradient-to-r ${stat.color} bg-clip-text text-transparent animate-pulse`} />
                </div>
                <div className="text-right">
                  <div className="text-3xl font-bold text-gray-900 dark:text-white group-hover:scale-110 transition-transform duration-300">
                    {stat.value}
                  </div>
                  <div className="text-sm text-green-400 animate-pulse">+{10 + index * 2}%</div>
                </div>
              </div>
              <h3 className="text-gray-700 dark:text-gray-300 font-medium group-hover:text-purple-600 dark:group-hover:text-purple-400 transition-colors duration-300">
                {stat.label}
              </h3>
            </div>
          );
        })}
      </div>

      {/* Department Leaderboard with dramatic animations */}
      <div className={`bg-white/90 backdrop-blur-xl dark:bg-slate-800/90 rounded-2xl p-8 border border-purple-100 dark:border-slate-700 shadow-2xl transform transition-all duration-1000 delay-1000 ${
        isVisible ? 'translate-y-0 opacity-100' : 'translate-y-10 opacity-0'
      }`}>
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-3xl font-bold text-gray-900 dark:text-white mb-2 bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
              Department Leaderboard
            </h2>
            <p className="text-gray-600 dark:text-gray-400">Credits earned for resolving issues - converted to monthly bonus</p>
          </div>
          <div className="text-right animate-pulse">
            <div className="bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-6 py-3 rounded-xl shadow-lg">
              <div className="text-sm font-medium">Credits This Month</div>
              <div className="text-3xl font-bold">{animatedTotalCredits}</div>
            </div>
          </div>
        </div>

        {/* Credits Leaderboard Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
          {departmentCredits.map((dept, index) => (
            <div
              key={dept.id}
              className={`credit-card relative p-6 rounded-2xl border-2 transition-all duration-700 transform hover:scale-105 hover:rotate-1 cursor-pointer animate-slideInUp ${
                dept.rank === 1
                  ? 'bg-gradient-to-br from-yellow-50 via-orange-50 to-red-50 dark:from-yellow-900/30 dark:via-orange-900/30 dark:to-red-900/30 border-yellow-400 dark:border-yellow-500 shadow-yellow-200 dark:shadow-yellow-800/50'
                  : dept.rank === 2
                  ? 'bg-gradient-to-br from-gray-50 via-slate-50 to-blue-50 dark:from-gray-900/30 dark:via-slate-900/30 dark:to-blue-900/30 border-gray-400 dark:border-gray-500 shadow-gray-200 dark:shadow-gray-800/50'
                  : dept.rank === 3
                  ? 'bg-gradient-to-br from-orange-50 via-red-50 to-pink-50 dark:from-orange-900/30 dark:via-red-900/30 dark:to-pink-900/30 border-orange-400 dark:border-orange-500 shadow-orange-200 dark:shadow-orange-800/50'
                  : 'bg-white dark:bg-slate-700 border-slate-200 dark:border-slate-600'
              } shadow-xl hover:shadow-2xl`}
              style={{
                animationDelay: `${index * 200}ms`
              }}
              onMouseEnter={() => setHoveredCard(dept.id)}
              onMouseLeave={() => setHoveredCard(null)}
            >
              {/* Rank Badge with crown effect */}
              <div className="absolute -top-3 -right-3 z-10">
                {dept.rank === 1 && (
                  <div className="bg-gradient-to-r from-yellow-400 to-yellow-600 text-white rounded-full p-3 shadow-lg animate-bounce">
                    <Crown className="h-5 w-5" />
                  </div>
                )}
                {dept.rank === 2 && (
                  <div className="bg-gradient-to-r from-gray-400 to-gray-600 text-white rounded-full p-3 shadow-lg animate-pulse">
                    <Award className="h-5 w-5" />
                  </div>
                )}
                {dept.rank === 3 && (
                  <div className="bg-gradient-to-r from-orange-400 to-orange-600 text-white rounded-full p-3 shadow-lg animate-ping">
                    <Star className="h-5 w-5" />
                  </div>
                )}
                {dept.rank > 3 && (
                  <div className="bg-gradient-to-r from-slate-400 to-slate-600 text-white rounded-full w-10 h-10 flex items-center justify-center text-sm font-bold shadow-lg">
                    {dept.rank}
                  </div>
                )}
              </div>

              {/* Department Info with hover effects */}
              <div className="flex items-start space-x-4">
                <div className={`text-4xl transform transition-all duration-300 ${
                  hoveredCard === dept.id ? 'scale-125 rotate-12' : 'scale-100'
                }`}>
                  {dept.icon}
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900 dark:text-white text-sm mb-3">
                    {dept.name}
                  </h3>
                  <div className="space-y-3">
                    <div className="flex justify-between items-center">
                      <span className="text-xs text-gray-600 dark:text-gray-400">Credits Earned</span>
                      <span className={`font-bold text-blue-600 dark:text-blue-400 transition-all duration-300 ${
                        hoveredCard === dept.id ? 'scale-110 text-purple-600 dark:text-purple-400' : ''
                      }`}>
                        {dept.credits}
                      </span>
                    </div>
                    <div className="flex justify-between items-center">
                      <span className="text-xs text-gray-600 dark:text-gray-400">Issues Resolved</span>
                      <span className={`font-semibold text-green-600 dark:text-green-400 transition-all duration-300 ${
                        hoveredCard === dept.id ? 'scale-110' : ''
                      }`}>
                        {dept.resolved}
                      </span>
                    </div>
                    <div className="flex justify-between items-center pt-2 border-t border-gray-200 dark:border-slate-600">
                      <span className="text-xs text-gray-600 dark:text-gray-400">Monthly Bonus</span>
                      <span className={`font-bold text-emerald-600 dark:text-emerald-400 transition-all duration-300 ${
                        hoveredCard === dept.id ? 'scale-110 animate-pulse' : ''
                      }`}>
                        ₹{dept.bonus}
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              {/* Enhanced Progress Bar */}
              <div className="mt-6">
                <div className="flex justify-between text-xs text-gray-600 dark:text-gray-400 mb-2">
                  <span>Progress to Next Tier</span>
                  <span>{Math.min(100, (dept.credits / 500) * 100).toFixed(0)}%</span>
                </div>
                <div className="w-full bg-gray-200 dark:bg-slate-600 rounded-full h-3 overflow-hidden">
                  <div
                    className={`h-3 rounded-full transition-all duration-1000 ${
                      dept.rank === 1 ? 'bg-gradient-to-r from-yellow-400 via-orange-500 to-red-500' :
                      dept.rank === 2 ? 'bg-gradient-to-r from-gray-400 via-slate-500 to-blue-500' :
                      dept.rank === 3 ? 'bg-gradient-to-r from-orange-400 via-red-500 to-pink-500' :
                      'bg-gradient-to-r from-blue-500 to-purple-600'
                    } ${hoveredCard === dept.id ? 'animate-pulse shadow-lg' : ''}`}
                    style={{ 
                      width: `${Math.min(100, (dept.credits / 500) * 100)}%`,
                      animationDelay: `${index * 100}ms`
                    }}
                  ></div>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Credit System Info with gradient background */}
        <div className="mt-8 p-6 bg-gradient-to-r from-blue-50 via-purple-50 to-pink-50 dark:from-blue-900/20 dark:via-purple-900/20 dark:to-pink-900/20 rounded-xl border border-blue-200 dark:border-blue-700">
          <h4 className="font-semibold text-blue-900 dark:text-blue-300 mb-4 text-lg">
            <Target className="inline-block mr-2 h-5 w-5" />
            Credit System Information
          </h4>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 text-sm">
            <div className="p-3 bg-white/50 dark:bg-slate-800/50 rounded-lg">
              <span className="font-medium text-red-800 dark:text-red-300">High Priority:</span>
              <span className="text-red-700 dark:text-red-400 ml-2 font-bold">50 credits per resolution</span>
            </div>
            <div className="p-3 bg-white/50 dark:bg-slate-800/50 rounded-lg">
              <span className="font-medium text-yellow-800 dark:text-yellow-300">Medium Priority:</span>
              <span className="text-yellow-700 dark:text-yellow-400 ml-2 font-bold">30 credits per resolution</span>
            </div>
            <div className="p-3 bg-white/50 dark:bg-slate-800/50 rounded-lg">
              <span className="font-medium text-green-800 dark:text-green-300">Low Priority:</span>
              <span className="text-green-700 dark:text-green-400 ml-2 font-bold">20 credits per resolution</span>
            </div>
          </div>
          <p className="text-blue-700 dark:text-blue-400 mt-4 text-sm bg-white/30 dark:bg-slate-800/30 p-3 rounded-lg">
            💰 Credits are converted to bonus at 0.5₹ per credit  •  📅 Bonus is distributed at month end  •  🏆 Top 3 departments receive additional recognition rewards
          </p>
        </div>
      </div>

      {/* Monthly Progress & Insights with stunning effects */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className={`relative overflow-hidden bg-gradient-to-br from-purple-600 via-blue-600 to-cyan-600 rounded-2xl p-8 border border-purple-500/30 shadow-2xl transform transition-all duration-1000 delay-1200 ${
          isVisible ? 'translate-x-0 opacity-100' : '-translate-x-10 opacity-0'
        }`}>
          <div className="absolute inset-0 bg-gradient-to-r from-purple-600/20 to-blue-600/20 blur-xl"></div>
          <div className="relative z-10">
            <div className="flex items-center space-x-3 mb-4">
              <Crown className="h-10 w-10 text-yellow-300 animate-spin" />
              <h3 className="text-xl font-bold text-white">Top Performer</h3>
            </div>
            <p className="text-purple-100 text-sm leading-relaxed">
              🏗️ Public Works Department leads this month with <span className="font-bold text-yellow-300">450 credits</span> and <span className="font-bold text-green-300">₹225 bonus</span> earned.
            </p>
          </div>
        </div>

        <div className={`relative overflow-hidden bg-gradient-to-br from-emerald-600 via-teal-600 to-cyan-600 rounded-2xl p-8 border border-emerald-500/30 shadow-2xl transform transition-all duration-1000 delay-1400 ${
          isVisible ? 'translate-x-0 opacity-100' : 'translate-x-10 opacity-0'
        }`}>
          <div className="absolute inset-0 bg-gradient-to-r from-emerald-600/20 to-teal-600/20 blur-xl"></div>
          <div className="relative z-10">
            <div className="flex items-center space-x-3 mb-4">
              <TrendingUp className="h-10 w-10 text-green-300 animate-bounce" />
              <h3 className="text-xl font-bold text-white">Performance Growth</h3>
            </div>
            <p className="text-emerald-100 text-sm leading-relaxed">
              Overall department performance has improved by <span className="font-bold text-yellow-300">25%</span> compared to last month with enhanced efficiency.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CreditsPage;