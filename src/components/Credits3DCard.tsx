import React, { useState, useRef } from 'react';
import { Trophy, Award, Star, Crown, Zap, Target, TrendingUp, Users } from 'lucide-react';

interface FloatingCredit {
  id: number;
  value: string;
  x: number;
  y: number;
  delay: number;
  color: string;
}

const Credits3DCard: React.FC = () => {
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  const [isHovered, setIsHovered] = useState(false);
  const cardRef = useRef<HTMLDivElement>(null);

  // Floating credit values and department icons
  const floatingCredits: FloatingCredit[] = [
    { id: 1, value: '+50', x: 15, y: 20, delay: 0, color: 'text-red-400' },
    { id: 2, value: '+30', x: 80, y: 25, delay: 0.5, color: 'text-yellow-400' },
    { id: 3, value: '+20', x: 20, y: 70, delay: 1, color: 'text-green-400' },
    { id: 4, value: '₹225', x: 75, y: 75, delay: 1.5, color: 'text-emerald-400' },
    { id: 5, value: '🏗️', x: 25, y: 45, delay: 2, color: 'text-blue-400' },
    { id: 6, value: '⚡', x: 70, y: 50, delay: 2.5, color: 'text-purple-400' },
    { id: 7, value: '💧', x: 50, y: 30, delay: 3, color: 'text-cyan-400' },
    { id: 8, value: '🏛️', x: 60, y: 80, delay: 3.5, color: 'text-pink-400' },
  ];

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!cardRef.current) return;
    
    const rect = cardRef.current.getBoundingClientRect();
    const x = e.clientX - rect.left - rect.width / 2;
    const y = e.clientY - rect.top - rect.height / 2;
    
    setMousePosition({ x, y });
  };

  const cardStyle = {
    transform: `perspective(1000px) rotateX(${mousePosition.y / 15}deg) rotateY(${-mousePosition.x / 15}deg) translateZ(${isHovered ? 50 : 0}px)`,
    transition: isHovered ? 'none' : 'transform 0.6s ease-out',
  };

  return (
    <div className="flex items-center justify-center py-16 px-8">
      <div className="relative">
        {/* Glowing background effect */}
        <div className="absolute inset-0 bg-gradient-to-r from-yellow-600/20 via-orange-600/20 to-red-600/20 rounded-3xl blur-3xl scale-125 animate-pulse"></div>
        
        {/* Main 3D Card */}
        <div
          ref={cardRef}
          className="relative w-80 h-80 cursor-pointer"
          style={cardStyle}
          onMouseMove={handleMouseMove}
          onMouseEnter={() => setIsHovered(true)}
          onMouseLeave={() => {
            setIsHovered(false);
            setMousePosition({ x: 0, y: 0 });
          }}
        >
          {/* Card Background with Glassmorphism */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/15 via-yellow-500/25 to-orange-600/30 backdrop-blur-xl rounded-3xl border border-white/30 shadow-2xl">
            {/* Inner glow */}
            <div className="absolute inset-1 bg-gradient-to-br from-transparent via-yellow-400/15 to-orange-500/15 rounded-3xl"></div>
          </div>

          {/* Floating Credit Elements */}
          {floatingCredits.map((credit) => (
            <div
              key={credit.id}
              className="absolute animate-bounce"
              style={{
                left: `${credit.x}%`,
                top: `${credit.y}%`,
                animationDelay: `${credit.delay}s`,
                animationDuration: `${3 + Math.random()}s`,
                transform: `scale(${0.8 + Math.random() * 0.4}) translateZ(${isHovered ? 40 : 0}px)`,
                transition: 'transform 0.4s ease-out',
              }}
            >
              <div className="p-2 bg-gradient-to-r from-white/20 to-white/10 rounded-full backdrop-blur-sm border border-white/30 shadow-lg">
                <span className={`text-sm font-bold ${credit.color}`}>
                  {credit.value}
                </span>
              </div>
            </div>
          ))}

          {/* Central Content */}
          <div className="absolute inset-0 flex flex-col items-center justify-center text-center p-6">
            {/* Main Trophy Icon */}
            <div 
              className="mb-4 transform transition-all duration-500"
              style={{
                transform: `translateZ(${isHovered ? 100 : 0}px) scale(${isHovered ? 1.2 : 1}) rotateY(${isHovered ? 360 : 0}deg)`,
              }}
            >
              <div className="relative">
                <div className="absolute inset-0 bg-yellow-500/40 rounded-full blur-2xl animate-pulse"></div>
                <div className="relative bg-gradient-to-r from-yellow-400 via-orange-500 to-red-500 p-4 rounded-full shadow-2xl">
                  <Crown className="h-10 w-10 text-white animate-pulse" />
                </div>
              </div>
            </div>

            {/* Title */}
            <h2 
              className="text-2xl font-bold text-white mb-2 transform transition-all duration-500"
              style={{
                transform: `translateZ(${isHovered ? 70 : 0}px)`,
                textShadow: '0 0 20px rgba(251, 191, 36, 0.6)',
              }}
            >
              Credits System
            </h2>

            {/* Stats */}
            <div 
              className="grid grid-cols-2 gap-3 mb-4 transform transition-all duration-500"
              style={{
                transform: `translateZ(${isHovered ? 50 : 0}px)`,
              }}
            >
              <div className="text-center">
                <div className="text-lg font-bold text-yellow-300">1,820</div>
                <div className="text-xs text-yellow-100">Total Credits</div>
              </div>
              <div className="text-center">
                <div className="text-lg font-bold text-green-300">₹910</div>
                <div className="text-xs text-green-100">Total Bonus</div>
              </div>
            </div>

            {/* Subtitle */}
            <p 
              className="text-sm text-orange-100 mb-4 transform transition-all duration-500"
              style={{
                transform: `translateZ(${isHovered ? 30 : 0}px)`,
              }}
            >
              Performance Recognition
            </p>
          </div>

          {/* Animated credit particles around border */}
          <div className="absolute inset-0 rounded-3xl overflow-hidden">
            {Array.from({ length: 12 }).map((_, i) => (
              <div
                key={i}
                className="absolute animate-ping"
                style={{
                  left: `${5 + (i * 8) % 90}%`,
                  top: `${(i % 2) === 0 ? '5%' : '95%'}`,
                  animationDelay: `${i * 0.3}s`,
                  animationDuration: '2s',
                }}
              >
                <Trophy className="h-3 w-3 text-yellow-400/60" />
              </div>
            ))}
          </div>

          {/* Corner rank indicators */}
          <div className="absolute top-3 left-3">
            <div className="bg-gradient-to-r from-yellow-400 to-orange-500 text-white rounded-full p-2 shadow-lg animate-bounce">
              <span className="text-xs font-bold">#1</span>
            </div>
          </div>
          <div className="absolute top-3 right-3">
            <div className="bg-gradient-to-r from-gray-400 to-slate-500 text-white rounded-full p-2 shadow-lg animate-pulse">
              <span className="text-xs font-bold">#2</span>
            </div>
          </div>
          <div className="absolute bottom-3 left-3">
            <div className="bg-gradient-to-r from-orange-400 to-red-500 text-white rounded-full p-2 shadow-lg animate-ping">
              <span className="text-xs font-bold">#3</span>
            </div>
          </div>
          <div className="absolute bottom-3 right-3">
            <div className="bg-gradient-to-r from-blue-400 to-purple-500 text-white rounded-full p-1 shadow-lg">
              <TrendingUp className="h-3 w-3" />
            </div>
          </div>
        </div>

        {/* Floating department achievement badges */}
        <div className="absolute -top-6 -left-12 transform rotate-12 hover:rotate-0 hover:scale-110 transition-all duration-500">
          <div className="bg-gradient-to-r from-blue-500/30 to-cyan-600/30 backdrop-blur-lg rounded-xl p-3 border border-white/20 shadow-xl">
            <div className="flex items-center space-x-2">
              <Award className="h-4 w-4 text-blue-400" />
              <span className="text-blue-100 text-xs font-semibold">PWD Leader</span>
            </div>
          </div>
        </div>

        <div className="absolute -top-6 -right-12 transform -rotate-12 hover:rotate-0 hover:scale-110 transition-all duration-500">
          <div className="bg-gradient-to-r from-green-500/30 to-emerald-600/30 backdrop-blur-lg rounded-xl p-3 border border-white/20 shadow-xl">
            <div className="flex items-center space-x-2">
              <Star className="h-4 w-4 text-green-400" />
              <span className="text-green-100 text-xs font-semibold">High Priority</span>
            </div>
          </div>
        </div>

        <div className="absolute -bottom-6 -left-12 transform -rotate-12 hover:rotate-0 hover:scale-110 transition-all duration-500">
          <div className="bg-gradient-to-r from-purple-500/30 to-pink-600/30 backdrop-blur-lg rounded-xl p-3 border border-white/20 shadow-xl">
            <div className="flex items-center space-x-2">
              <Users className="h-4 w-4 text-purple-400" />
              <span className="text-purple-100 text-xs font-semibold">Team Work</span>
            </div>
          </div>
        </div>

        <div className="absolute -bottom-6 -right-12 transform rotate-12 hover:rotate-0 hover:scale-110 transition-all duration-500">
          <div className="bg-gradient-to-r from-orange-500/30 to-red-600/30 backdrop-blur-lg rounded-xl p-3 border border-white/20 shadow-xl">
            <div className="flex items-center space-x-2">
              <Target className="h-4 w-4 text-orange-400" />
              <span className="text-orange-100 text-xs font-semibold">Goal Achieved</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Credits3DCard;