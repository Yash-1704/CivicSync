import React, { useState, useRef, useEffect } from 'react';
import { Mail, Shield, ArrowLeft } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useLanguage } from '../contexts/LanguageContext';

interface AuthPageProps {
  onBack: () => void;
  onSuccess: () => void;
}

const AuthPage: React.FC<AuthPageProps> = ({ onBack, onSuccess }) => {
  const [step, setStep] = useState<'email' | 'otp'>('email');
  const [mode, setMode] = useState<'login' | 'signup'>('login');
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [otp, setOtp] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const { login } = useAuth();
  const { register } = useAuth();
  const { t } = useLanguage();

  // Tilt / float effect
  const cardRef = useRef<HTMLDivElement | null>(null);
  const [transformStyle, setTransformStyle] = useState('perspective(1000px) translateZ(0px)');
  const [cardOpacity, setCardOpacity] = useState(0.95);

  useEffect(() => {
    // Ensure initial transform is set
    setTransformStyle('perspective(1000px) translateZ(0px)');
    setCardOpacity(0.95);
  }, []);

  const handleMouseMove = (e: React.MouseEvent) => {
    const el = cardRef.current;
    if (!el) return;
    const rect = el.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    const cx = rect.width / 2;
    const cy = rect.height / 2;

    // normalize to [-1, 1]
    const nx = (x - cx) / cx;
    const ny = (y - cy) / cy;

    const maxTilt = 8; // degrees
    const rotY = nx * maxTilt; // rotateY based on x
    const rotX = -ny * maxTilt; // rotateX based on y (invert)

    const translateZ = 12; // slight pop
    setTransformStyle(`perspective(1000px) rotateX(${rotX}deg) rotateY(${rotY}deg) translateZ(${translateZ}px)`);
    // reduce opacity slightly while interacting
    setCardOpacity(0.9);
  };

  const handleMouseLeave = () => {
    // reset
    setTransformStyle('perspective(1000px) rotateX(0deg) rotateY(0deg) translateZ(0px)');
    setCardOpacity(0.95);
  };

  const handleSendOTP = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email) return;
    
    setIsLoading(true);
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1000));
    setIsLoading(false);
    setStep('otp');
    setError('');
  };

  const handleVerifyOTP = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!otp) return;

    setIsLoading(true);
    let success = false;
    if (mode === 'signup') {
      success = await register(name, email, otp);
    } else {
      success = await login(email, otp);
    }
    setIsLoading(false);

    if (success) {
      onSuccess();
    } else {
      setError(t('auth.invalidOTP'));
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-sky-50 to-cyan-50 dark:from-slate-900 dark:via-blue-900 dark:to-cyan-900 flex items-center justify-center p-4">
      {/* Background Animation */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-40 w-96 h-96 bg-blue-500/20 rounded-full blur-3xl animate-pulse"></div>
        <div className="absolute -bottom-40 -left-40 w-96 h-96 bg-cyan-500/20 rounded-full blur-3xl animate-pulse delay-1000"></div>
      </div>

      <div className="relative w-full max-w-md">
        <div
          ref={cardRef}
          onMouseMove={handleMouseMove}
          onMouseLeave={handleMouseLeave}
          style={{ transform: transformStyle, opacity: cardOpacity, transition: 'transform 180ms ease, opacity 300ms ease' }}
          className="bg-slate-800/80 backdrop-blur-xl rounded-2xl shadow-2xl p-8 border border-slate-700/50"
        >
          {/* Header */}
          <div className="text-center mb-8">
            <div className="flex items-center justify-center w-16 h-16 bg-blue-600/20 rounded-full mx-auto mb-4">
              <Shield className="h-8 w-8 text-blue-400" />
            </div>
            <h1 className="text-3xl font-bold text-white mb-2">
              {step === 'email' ? (mode === 'signup' ? t('auth.signup') : t('auth.welcome')) : t('auth.verify')}
            </h1>
            <p className="text-gray-400">
              {step === 'email'
                ? (mode === 'signup' ? 'Create an account to access the civic dashboard' : 'Access your civic dashboard')
                : t('auth.otpSent')
              }
            </p>
          </div>

          {/* Email / Signup Step */}
          {step === 'email' && (
            <form onSubmit={handleSendOTP} className="space-y-6">
              {mode === 'signup' && (
                <div>
                  <label htmlFor="name" className="block text-sm font-medium text-gray-300 mb-2">Name</label>
                  <input
                    id="name"
                    type="text"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    className="w-full px-4 py-3 bg-slate-700/50 border border-slate-600 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all"
                    placeholder="Your full name"
                    required={mode === 'signup'}
                  />
                </div>
              )}

              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-300 mb-2">
                  {t('auth.email')}
                </label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                  <input
                    id="email"
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full pl-10 pr-4 py-3 bg-slate-700/50 border border-slate-600 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all"
                    placeholder={t('auth.enterEmail')}
                    required
                  />
                </div>
              </div>

              <button
                type="submit"
                disabled={isLoading || !email || (mode === 'signup' && !name)}
                className="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-blue-600/50 text-white py-3 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2"
              >
                {isLoading ? (
                  <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <span>{mode === 'signup' ? 'Request Signup OTP' : t('auth.sendOTP')}</span>
                )}
              </button>

              <div className="text-center text-sm text-gray-400">
                {mode === 'signup' ? (
                  <button type="button" onClick={() => { setMode('login'); setError(''); }} className="underline">Already have an account? Login</button>
                ) : (
                  <button type="button" onClick={() => { setMode('signup'); setError(''); }} className="underline">Create an account</button>
                )}
              </div>
            </form>
          )}

          {/* OTP Step */}
          {step === 'otp' && (
            <form onSubmit={handleVerifyOTP} className="space-y-6">
              <div>
                <label htmlFor="otp" className="block text-sm font-medium text-gray-300 mb-2">
                  {t('auth.otp')}
                </label>
                <input
                  id="otp"
                  type="text"
                  value={otp}
                  onChange={(e) => setOtp(e.target.value.replace(/\D/g, '').slice(0, 6))}
                  className="w-full px-4 py-3 bg-slate-700/50 border border-slate-600 rounded-lg text-white text-center text-xl tracking-widest focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all"
                  placeholder="000000"
                  maxLength={6}
                  required
                />
                <p className="text-xs text-gray-400 mt-2 text-center">
                  Demo: Use "123456" as OTP
                </p>
              </div>

              {error && (
                <div className="bg-red-500/10 border border-red-500/20 text-red-400 px-4 py-3 rounded-lg text-sm">
                  {error}
                </div>
              )}

              <button
                type="submit"
                disabled={isLoading || otp.length !== 6}
                className="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-blue-600/50 text-white py-3 rounded-lg font-semibold transition-colors flex items-center justify-center space-x-2"
              >
                {isLoading ? (
                  <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <span>{t('auth.verify')}</span>
                )}
              </button>

              <button
                type="button"
                onClick={() => {
                  setStep('email');
                  setOtp('');
                  setError('');
                }}
                className="w-full text-gray-400 hover:text-white py-2 font-medium transition-colors flex items-center justify-center space-x-2"
              >
                <ArrowLeft className="h-4 w-4" />
                <span>{t('auth.backToEmail')}</span>
              </button>
            </form>
          )}

          <button
            onClick={onBack}
            className="absolute top-4 left-4 text-gray-400 hover:text-white transition-colors"
          >
            <ArrowLeft className="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
  );
};

export default AuthPage;