import React, { useState, useRef, useEffect } from 'react';
import { Shield, FileText, BarChart3, Users, MapPin, Bell, Clock, CheckCircle, ArrowRight } from 'lucide-react';

interface FloatingElement {
  id: number;
  icon: React.ElementType;
  x: number;
  y: number;
  delay: number;
  duration: number;
  scale: number;
  color: string;
}

interface LandingHero3DProps {
  onLoginClick: () => void;
}

const LandingHero3D: React.FC<LandingHero3DProps> = ({ onLoginClick }) => {
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  const [isHovered, setIsHovered] = useState(false);
  const [hasRevolved, setHasRevolved] = useState(false);
  const cardRef = useRef<HTMLDivElement>(null);

  // Auto-revolve on component mount
  useEffect(() => {
    const timer = setTimeout(() => {
      setHasRevolved(true);
    }, 500);
    return () => clearTimeout(timer);
  }, []);

  // Simplified floating civic-themed elements (reduced from 8 to 4)
  const floatingElements: FloatingElement[] = [
    { id: 1, icon: FileText, x: 20, y: 25, delay: 0, duration: 4, scale: 0.7, color: 'text-blue-400' },
    { id: 2, icon: BarChart3, x: 80, y: 30, delay: 1, duration: 3.5, scale: 0.6, color: 'text-green-400' },
    { id: 3, icon: Users, x: 25, y: 70, delay: 2, duration: 4.2, scale: 0.6, color: 'text-purple-400' },
    { id: 4, icon: Bell, x: 75, y: 65, delay: 3, duration: 3.8, scale: 0.5, color: 'text-yellow-400' },
  ];

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!cardRef.current) return;
    
    const rect = cardRef.current.getBoundingClientRect();
    const x = e.clientX - rect.left - rect.width / 2;
    const y = e.clientY - rect.top - rect.height / 2;
    
    setMousePosition({ x, y });
  };

  // Initial auto-revolve animation, then mouse tracking
  const cardStyle = {
    transform: hasRevolved 
      ? `perspective(1000px) rotateX(${mousePosition.y / 20}deg) rotateY(${-mousePosition.x / 20}deg) translateZ(${isHovered ? 60 : 0}px)`
      : `perspective(1000px) rotateY(360deg)`,
    transition: hasRevolved 
      ? (isHovered ? 'none' : 'transform 0.6s ease-out')
      : 'transform 2s ease-out',
  };

  return (
    <div className="relative flex items-center justify-center py-20">
      {/* Background particles */}
      <div className="absolute inset-0 overflow-hidden">
        {Array.from({ length: 50 }).map((_, i) => (
          <div
            key={i}
            className="absolute w-1 h-1 bg-blue-400/30 rounded-full animate-pulse"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              animationDelay: `${Math.random() * 4}s`,
              animationDuration: `${2 + Math.random() * 3}s`,
            }}
          />
        ))}
      </div>

      <div className="relative max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-12 items-center px-6">
        {/* Left side - Text content */}
        <div className="space-y-8">
          <div className="space-y-6">
            <h1 className="text-5xl lg:text-6xl font-bold text-white leading-tight">
              <span className="block">Government Staff</span>
              <span className="block bg-gradient-to-r from-blue-400 via-purple-500 to-cyan-400 bg-clip-text text-transparent">
                Management Portal
              </span>
            </h1>
            <p className="text-xl text-sky-100 leading-relaxed max-w-xl">
              Streamline civic operations with our comprehensive dashboard. Manage reports, 
              analyze data, and serve your community more effectively.
            </p>
          </div>

          <div className="flex flex-col sm:flex-row gap-4">
            <button
              onClick={onLoginClick}
              className="group bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white px-8 py-4 rounded-xl font-semibold text-lg shadow-2xl hover:shadow-blue-500/25 transform hover:scale-105 transition-all duration-300 flex items-center justify-center"
            >
              Access Dashboard
              <ArrowRight className="ml-2 h-5 w-5 group-hover:translate-x-1 transition-transform" />
            </button>
            <button className="border-2 border-sky-300 hover:border-white text-sky-100 hover:text-white px-8 py-4 rounded-xl font-semibold text-lg hover:bg-white/10 transition-all duration-300">
              Learn More
            </button>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-3 gap-6">
            <div className="text-center">
              <div className="text-2xl font-bold text-white">1.2K+</div>
              <div className="text-sky-200 text-sm">Reports Managed</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-white">95%</div>
              <div className="text-sky-200 text-sm">Efficiency Rate</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-white">24/7</div>
              <div className="text-sky-200 text-sm">System Uptime</div>
            </div>
          </div>
        </div>

        {/* Right side - 3D Interactive Card */}
        <div className="flex items-center justify-center">
          <div className="relative">
            {/* Glowing background effect */}
            <div className="absolute inset-0 bg-gradient-to-r from-blue-600/30 via-purple-600/30 to-cyan-600/30 rounded-3xl blur-3xl scale-110 animate-pulse"></div>
            
            {/* Main 3D Card */}
            <div
              ref={cardRef}
              className="relative w-80 h-80 cursor-pointer"
              style={cardStyle}
              onMouseMove={hasRevolved ? handleMouseMove : undefined}
              onMouseEnter={hasRevolved ? () => setIsHovered(true) : undefined}
              onMouseLeave={hasRevolved ? () => {
                setIsHovered(false);
                setMousePosition({ x: 0, y: 0 });
              } : undefined}
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
                      transform: `scale(${element.scale}) translateZ(${isHovered ? 40 : 0}px)`,
                      transition: 'transform 0.4s ease-out',
                    }}
                  >
                    <div className="p-3 bg-gradient-to-r from-white/20 to-white/10 rounded-full backdrop-blur-sm border border-white/30 shadow-lg hover:scale-110 transition-transform duration-300">
                      <Icon className={`h-5 w-5 ${element.color}`} />
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
                    transform: `translateZ(${isHovered ? 100 : 0}px) scale(${isHovered ? 1.2 : 1}) rotateY(${isHovered ? 360 : 0}deg)`,
                  }}
                >
                  <div className="relative">
                    <div className="absolute inset-0 bg-blue-500/40 rounded-full blur-2xl animate-pulse"></div>
                    <div className="relative bg-gradient-to-r from-blue-500 via-purple-600 to-cyan-500 p-6 rounded-full shadow-2xl">
                      <Shield className="h-12 w-12 text-white" />
                    </div>
                  </div>
                </div>

                {/* Title */}
                <h2 
                  className="text-3xl font-bold text-white mb-3 transform transition-all duration-500"
                  style={{
                    transform: `translateZ(${isHovered ? 70 : 0}px)`,
                    textShadow: '0 0 20px rgba(59, 130, 246, 0.6)',
                  }}
                >
                  CivicSync
                </h2>

                {/* Subtitle */}
                <p 
                  className="text-lg text-blue-100 mb-6 transform transition-all duration-500"
                  style={{
                    transform: `translateZ(${isHovered ? 50 : 0}px)`,
                  }}
                >
                  Smart Civic Management
                </p>

                {/* Interactive Dashboard Preview */}
                <div 
                  className="grid grid-cols-2 gap-3 transform transition-all duration-500"
                  style={{
                    transform: `translateZ(${isHovered ? 30 : 0}px)`,
                  }}
                >
                  <div className="bg-white/10 rounded-lg p-2 backdrop-blur-sm">
                    <div className="text-xs text-white font-semibold">Reports</div>
                    <div className="text-lg text-blue-300 font-bold">342</div>
                  </div>
                  <div className="bg-white/10 rounded-lg p-2 backdrop-blur-sm">
                    <div className="text-xs text-white font-semibold">Resolved</div>
                    <div className="text-lg text-green-300 font-bold">289</div>
                  </div>
                </div>
              </div>

              {/* Simplified animated border particles (reduced from 16 to 8) */}
              <div className="absolute inset-0 rounded-3xl overflow-hidden">
                {Array.from({ length: 8 }).map((_, i) => (
                  <div
                    key={i}
                    className="absolute animate-ping"
                    style={{
                      left: `${(i * 12.5) % 100}%`,
                      top: `${i < 4 ? '5%' : '95%'}`,
                      animationDelay: `${i * 0.4}s`,
                      animationDuration: '3s',
                    }}
                  >
                    <div className="w-1.5 h-1.5 bg-blue-400/60 rounded-full"></div>
                  </div>
                ))}
              </div>

              {/* Corner decorative elements */}
              <div className="absolute top-4 left-4 w-12 h-12 border-t-2 border-l-2 border-white/40 rounded-tl-xl"></div>
              <div className="absolute top-4 right-4 w-12 h-12 border-t-2 border-r-2 border-white/40 rounded-tr-xl"></div>
              <div className="absolute bottom-4 left-4 w-12 h-12 border-b-2 border-l-2 border-white/40 rounded-bl-xl"></div>
              <div className="absolute bottom-4 right-4 w-12 h-12 border-b-2 border-r-2 border-white/40 rounded-br-xl"></div>
            </div>

            {/* Simplified floating feature cards (reduced from 4 to 2) */}
            <div className="absolute -top-6 -left-12 transform rotate-12 hover:rotate-0 hover:scale-110 transition-all duration-500">
              <div className="bg-gradient-to-r from-green-500/20 to-emerald-600/20 backdrop-blur-lg rounded-lg p-3 border border-white/20 shadow-xl">
                <div className="flex items-center space-x-2">
                  <CheckCircle className="h-4 w-4 text-green-400" />
                  <span className="text-green-100 text-xs font-semibold">Real-time</span>
                </div>
              </div>
            </div>

            <div className="absolute -bottom-6 -right-12 transform rotate-12 hover:rotate-0 hover:scale-110 transition-all duration-500">
              <div className="bg-gradient-to-r from-blue-500/20 to-cyan-600/20 backdrop-blur-lg rounded-lg p-3 border border-white/20 shadow-xl">
                <div className="flex items-center space-x-2">
                  <BarChart3 className="h-4 w-4 text-blue-400" />
                  <span className="text-blue-100 text-xs font-semibold">Analytics</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LandingHero3D;