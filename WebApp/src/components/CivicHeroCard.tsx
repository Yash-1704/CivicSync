import React, { useState, useEffect, useRef } from 'react';
import { Shield, MapPin, Users, TrendingUp, Bell, Calendar, FileText, Award } from 'lucide-react';

interface FloatingElement {
  id: number;
  icon: React.ElementType;
  x: number;
  y: number;
  delay: number;
  duration: number;
  scale: number;
}

const CivicHeroCard: React.FC = () => {
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  const [isHovered, setIsHovered] = useState(false);
  const cardRef = useRef<HTMLDivElement>(null);

  // Floating civic-themed elements
  const floatingElements: FloatingElement[] = [
    { id: 1, icon: Shield, x: 10, y: 15, delay: 0, duration: 4, scale: 0.8 },
    { id: 2, icon: MapPin, x: 85, y: 20, delay: 0.5, duration: 3.5, scale: 0.6 },
    { id: 3, icon: Users, x: 15, y: 75, delay: 1, duration: 4.5, scale: 0.7 },
    { id: 4, icon: TrendingUp, x: 80, y: 70, delay: 1.5, duration: 3.8, scale: 0.5 },
    { id: 5, icon: Bell, x: 20, y: 45, delay: 2, duration: 4.2, scale: 0.6 },
    { id: 6, icon: Calendar, x: 75, y: 45, delay: 2.5, duration: 3.9, scale: 0.7 },
    { id: 7, icon: FileText, x: 50, y: 25, delay: 3, duration: 4.1, scale: 0.5 },
    { id: 8, icon: Award, x: 60, y: 80, delay: 3.5, duration: 3.7, scale: 0.8 },
  ];

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!cardRef.current) return;
    
    const rect = cardRef.current.getBoundingClientRect();
    const x = e.clientX - rect.left - rect.width / 2;
    const y = e.clientY - rect.top - rect.height / 2;
    
    setMousePosition({ x, y });
  };

  const cardStyle = {
    transform: `perspective(1000px) rotateX(${mousePosition.y / 10}deg) rotateY(${-mousePosition.x / 10}deg) translateZ(${isHovered ? 50 : 0}px)`,
    transition: isHovered ? 'none' : 'transform 0.5s ease-out',
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gradient-to-br from-slate-900 via-blue-900 to-indigo-900 p-8">
      <div className="relative">
        {/* Glowing background effect */}
        <div className="absolute inset-0 bg-gradient-to-r from-blue-600/20 via-purple-600/20 to-pink-600/20 rounded-3xl blur-3xl scale-110 animate-pulse"></div>
        
        {/* Main 3D Card */}
        <div
          ref={cardRef}
          className="relative w-96 h-96 cursor-pointer"
          style={cardStyle}
          onMouseMove={handleMouseMove}
          onMouseEnter={() => setIsHovered(true)}
          onMouseLeave={() => {
            setIsHovered(false);
            setMousePosition({ x: 0, y: 0 });
          }}
        >
          {/* Card Background with Glassmorphism */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/10 via-blue-500/20 to-purple-600/30 backdrop-blur-xl rounded-3xl border border-white/20 shadow-2xl">
            {/* Inner glow */}
            <div className="absolute inset-1 bg-gradient-to-br from-transparent via-blue-400/10 to-purple-500/10 rounded-3xl"></div>
          </div>

          {/* Floating Civic Elements */}
          {floatingElements.map((element) => {
            const Icon = element.icon;
            return (
              <div
                key={element.id}
                className="absolute animate-bounce"
                style={{
                  left: `${element.x}%`,
                  top: `${element.y}%`,
                  animationDelay: `${element.delay}s`,
                  animationDuration: `${element.duration}s`,
                  transform: `scale(${element.scale}) translateZ(${isHovered ? 30 : 0}px)`,
                  transition: 'transform 0.3s ease-out',
                }}
              >
                <div className="p-2 bg-gradient-to-r from-blue-500/30 to-purple-600/30 rounded-full backdrop-blur-sm border border-white/20">
                  <Icon className="h-4 w-4 text-white/80" />
                </div>
              </div>
            );
          })}

          {/* Central Content */}
          <div className="absolute inset-0 flex flex-col items-center justify-center text-center p-8">
            {/* Main Logo/Icon */}
            <div 
              className="mb-6 transform transition-all duration-500"
              style={{
                transform: `translateZ(${isHovered ? 80 : 0}px) scale(${isHovered ? 1.1 : 1})`,
              }}
            >
              <div className="relative">
                <div className="absolute inset-0 bg-blue-500/30 rounded-full blur-xl animate-pulse"></div>
                <div className="relative bg-gradient-to-r from-blue-500 to-purple-600 p-6 rounded-full shadow-2xl">
                  <Shield className="h-12 w-12 text-white" />
                </div>
              </div>
            </div>

            {/* Title */}
            <h1 
              className="text-4xl font-bold text-white mb-4 transform transition-all duration-500"
              style={{
                transform: `translateZ(${isHovered ? 60 : 0}px)`,
                textShadow: '0 0 20px rgba(59, 130, 246, 0.5)',
              }}
            >
              CivicSync
            </h1>

            {/* Subtitle */}
            <p 
              className="text-lg text-blue-100 mb-6 transform transition-all duration-500"
              style={{
                transform: `translateZ(${isHovered ? 40 : 0}px)`,
              }}
            >
              Smart Civic Management
            </p>

            {/* Action Button */}
            <button 
              className="px-8 py-3 bg-gradient-to-r from-blue-500 to-purple-600 text-white font-semibold rounded-full shadow-lg hover:shadow-2xl transform transition-all duration-300 hover:scale-105"
              style={{
                transform: `translateZ(${isHovered ? 60 : 0}px)`,
                boxShadow: isHovered ? '0 20px 40px rgba(59, 130, 246, 0.4)' : '0 10px 20px rgba(0, 0, 0, 0.2)',
              }}
            >
              Explore Dashboard
            </button>
          </div>

          {/* Animated border particles */}
          <div className="absolute inset-0 rounded-3xl overflow-hidden">
            {Array.from({ length: 20 }).map((_, i) => (
              <div
                key={i}
                className="absolute w-1 h-1 bg-white/60 rounded-full animate-ping"
                style={{
                  left: `${Math.random() * 100}%`,
                  top: `${Math.random() * 100}%`,
                  animationDelay: `${Math.random() * 4}s`,
                  animationDuration: `${2 + Math.random() * 2}s`,
                }}
              />
            ))}
          </div>

          {/* Corner decorative elements */}
          <div className="absolute top-4 left-4 w-8 h-8 border-t-2 border-l-2 border-white/30 rounded-tl-lg"></div>
          <div className="absolute top-4 right-4 w-8 h-8 border-t-2 border-r-2 border-white/30 rounded-tr-lg"></div>
          <div className="absolute bottom-4 left-4 w-8 h-8 border-b-2 border-l-2 border-white/30 rounded-bl-lg"></div>
          <div className="absolute bottom-4 right-4 w-8 h-8 border-b-2 border-r-2 border-white/30 rounded-br-lg"></div>
        </div>

        {/* Floating statistics cards around main card */}
        <div className="absolute -top-8 -left-8 transform rotate-12 hover:rotate-0 transition-transform duration-500">
          <div className="bg-gradient-to-r from-green-500/20 to-emerald-600/20 backdrop-blur-lg rounded-lg p-4 border border-white/20">
            <div className="flex items-center space-x-2">
              <TrendingUp className="h-4 w-4 text-green-400" />
              <span className="text-green-100 text-sm font-semibold">95% Efficiency</span>
            </div>
          </div>
        </div>

        <div className="absolute -top-8 -right-8 transform -rotate-12 hover:rotate-0 transition-transform duration-500">
          <div className="bg-gradient-to-r from-blue-500/20 to-cyan-600/20 backdrop-blur-lg rounded-lg p-4 border border-white/20">
            <div className="flex items-center space-x-2">
              <Users className="h-4 w-4 text-blue-400" />
              <span className="text-blue-100 text-sm font-semibold">1.2K Reports</span>
            </div>
          </div>
        </div>

        <div className="absolute -bottom-8 -left-8 transform -rotate-12 hover:rotate-0 transition-transform duration-500">
          <div className="bg-gradient-to-r from-purple-500/20 to-pink-600/20 backdrop-blur-lg rounded-lg p-4 border border-white/20">
            <div className="flex items-center space-x-2">
              <Award className="h-4 w-4 text-purple-400" />
              <span className="text-purple-100 text-sm font-semibold">Top Rated</span>
            </div>
          </div>
        </div>

        <div className="absolute -bottom-8 -right-8 transform rotate-12 hover:rotate-0 transition-transform duration-500">
          <div className="bg-gradient-to-r from-orange-500/20 to-red-600/20 backdrop-blur-lg rounded-lg p-4 border border-white/20">
            <div className="flex items-center space-x-2">
              <Bell className="h-4 w-4 text-orange-400" />
              <span className="text-orange-100 text-sm font-semibold">Live Updates</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CivicHeroCard;