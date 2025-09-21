import React, { useState, useCallback, useRef } from 'react';
import { GoogleMap, LoadScript, Marker, InfoWindow, Polygon } from '@react-google-maps/api';
import { MapPin, Layers, Satellite, RotateCcw } from 'lucide-react';
import { mockReports } from '../data/mockData';

interface GoogleMapProps {
  className?: string;
}

// Google Maps Libraries
const libraries: ("geometry" | "places" | "drawing")[] = ["geometry"];

// Default center (New Delhi, India)
const defaultCenter = {
  lat: 28.6139,
  lng: 77.2090
};

// Map container style
const containerStyle = {
  width: '100%',
  height: '100%'
};

// Generate highlighted areas based on frequency zones
const generateHighlightedAreas = () => {
  return {
    // High frequency areas (Central Delhi) - RED
    highFrequency: [
      {
        id: 'connaught-place',
        name: 'Connaught Place Area',
        paths: [
          { lat: 28.6350, lng: 77.2000 },
          { lat: 28.6350, lng: 77.2180 },
          { lat: 28.6210, lng: 77.2180 },
          { lat: 28.6210, lng: 77.2000 }
        ],
        color: '#ef4444',
        opacity: 0.3
      },
      {
        id: 'red-fort',
        name: 'Red Fort & Old Delhi',
        paths: [
          { lat: 28.6620, lng: 77.2350 },
          { lat: 28.6620, lng: 77.2470 },
          { lat: 28.6500, lng: 77.2470 },
          { lat: 28.6500, lng: 77.2350 }
        ],
        color: '#ef4444',
        opacity: 0.3
      },
      {
        id: 'india-gate',
        name: 'India Gate Area',
        paths: [
          { lat: 28.6200, lng: 77.2050 },
          { lat: 28.6200, lng: 77.2230 },
          { lat: 28.6080, lng: 77.2230 },
          { lat: 28.6080, lng: 77.2050 }
        ],
        color: '#ef4444',
        opacity: 0.3
      }
    ],
    
    // Medium frequency areas (Mid Delhi) - YELLOW
    mediumFrequency: [
      {
        id: 'noida',
        name: 'Noida Sector 18',
        paths: [
          { lat: 28.5450, lng: 77.3800 },
          { lat: 28.5450, lng: 77.4020 },
          { lat: 28.5260, lng: 77.4020 },
          { lat: 28.5260, lng: 77.3800 }
        ],
        color: '#f59e0b',
        opacity: 0.3
      },
      {
        id: 'gurgaon-cyber',
        name: 'Gurgaon Cyber City',
        paths: [
          { lat: 28.4690, lng: 77.0150 },
          { lat: 28.4690, lng: 77.0380 },
          { lat: 28.4500, lng: 77.0380 },
          { lat: 28.4500, lng: 77.0150 }
        ],
        color: '#f59e0b',
        opacity: 0.3
      },
      {
        id: 'north-delhi',
        name: 'North Delhi Campus',
        paths: [
          { lat: 28.7140, lng: 77.0920 },
          { lat: 28.7140, lng: 77.1130 },
          { lat: 28.6940, lng: 77.1130 },
          { lat: 28.6940, lng: 77.0920 }
        ],
        color: '#f59e0b',
        opacity: 0.3
      }
    ],
    
    // Low frequency areas (Outer Delhi) - GREEN
    lowFrequency: [
      {
        id: 'rohini',
        name: 'Rohini Sector 7',
        paths: [
          { lat: 28.9050, lng: 77.0530 },
          { lat: 28.9050, lng: 77.0740 },
          { lat: 28.8860, lng: 77.0740 },
          { lat: 28.8860, lng: 77.0530 }
        ],
        color: '#10b981',
        opacity: 0.3
      },
      {
        id: 'faridabad',
        name: 'Faridabad Sector 16',
        paths: [
          { lat: 28.4050, lng: 77.2960 },
          { lat: 28.4050, lng: 77.3180 },
          { lat: 28.3850, lng: 77.3180 },
          { lat: 28.3850, lng: 77.2960 }
        ],
        color: '#10b981',
        opacity: 0.3
      },
      {
        id: 'ghaziabad',
        name: 'Ghaziabad Crossing',
        paths: [
          { lat: 28.7290, lng: 77.4410 },
          { lat: 28.7290, lng: 77.4620 },
          { lat: 28.7100, lng: 77.4620 },
          { lat: 28.7100, lng: 77.4410 }
        ],
        color: '#10b981',
        opacity: 0.3
      }
    ]
  };
};

// Generate marker data from mock reports
const generateMarkerData = () => {
  return mockReports.map((report, index) => ({
    id: report.id,
    position: {
      lat: 28.6139 + (Math.random() - 0.5) * 0.1,
      lng: 77.2090 + (Math.random() - 0.5) * 0.1
    },
    urgency: report.urgency,
    title: report.location,
    description: report.description,
    status: report.status
  }));
};

const GoogleMapComponent: React.FC<GoogleMapProps> = ({ className = '' }) => {
  const [viewMode, setViewMode] = useState<'normal' | 'areas' | 'satellite'>('areas');
  const [selectedMarker, setSelectedMarker] = useState<any>(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const mapRef = useRef<google.maps.Map>();
  
  const highlightedAreas = generateHighlightedAreas();
  const markerData = generateMarkerData();

  const onLoad = useCallback((map: google.maps.Map) => {
    mapRef.current = map;
    setIsLoaded(true);
  }, []);

  const onUnmount = useCallback(() => {
    mapRef.current = undefined;
    setIsLoaded(false);
  }, []);

  const getMarkerIcon = (urgency: string) => {
    if (!window.google) return undefined;
    
    const colors = {
      high: '#ef4444',
      medium: '#f59e0b', 
      low: '#10b981'
    };
    
    return {
      path: window.google.maps.SymbolPath.CIRCLE,
      scale: 8,
      fillColor: colors[urgency as keyof typeof colors] || '#3b82f6',
      fillOpacity: 0.8,
      strokeColor: '#ffffff',
      strokeWeight: 2
    };
  };

  const resetView = () => {
    if (mapRef.current) {
      mapRef.current.setCenter(defaultCenter);
      mapRef.current.setZoom(11);
    }
  };

  return (
    <div className={`relative bg-slate-200 dark:bg-slate-800 rounded-xl overflow-hidden ${className}`}>
      {/* Map Controls */}
      <div className="absolute top-4 right-4 z-10 flex space-x-2">
        <button
          onClick={() => setViewMode('normal')}
          className={`p-2 rounded-lg transition-colors ${
            viewMode === 'normal' 
              ? 'bg-blue-600 text-white' 
              : 'bg-white/90 dark:bg-slate-700 text-gray-700 dark:text-gray-300 hover:bg-white dark:hover:bg-slate-600'
          }`}
          title="Normal View"
        >
          <MapPin className="h-4 w-4" />
        </button>
        <button
          onClick={() => setViewMode('areas')}
          className={`p-2 rounded-lg transition-colors ${
            viewMode === 'areas' 
              ? 'bg-blue-600 text-white' 
              : 'bg-white/90 dark:bg-slate-700 text-gray-700 dark:text-gray-300 hover:bg-white dark:hover:bg-slate-600'
          }`}
          title="Highlighted Areas"
        >
          <Layers className="h-4 w-4" />
        </button>
        <button
          onClick={() => setViewMode('satellite')}
          className={`p-2 rounded-lg transition-colors ${
            viewMode === 'satellite' 
              ? 'bg-blue-600 text-white' 
              : 'bg-white/90 dark:bg-slate-700 text-gray-700 dark:text-gray-300 hover:bg-white dark:hover:bg-slate-600'
          }`}
          title="Satellite View"
        >
          <Satellite className="h-4 w-4" />
        </button>
        <button
          onClick={resetView}
          className="p-2 rounded-lg bg-white/90 dark:bg-slate-700 text-gray-700 dark:text-gray-300 hover:bg-white dark:hover:bg-slate-600 transition-colors"
          title="Reset View"
        >
          <RotateCcw className="h-4 w-4" />
        </button>
      </div>

      {/* Frequency Legend */}
      <div className="absolute top-4 left-4 z-10 bg-white/95 dark:bg-slate-800/95 backdrop-blur-sm rounded-lg p-3 text-sm">
        <h3 className="font-semibold text-gray-900 dark:text-white mb-2">Report Frequency</h3>
        <div className="space-y-1">
          <div className="flex items-center space-x-2">
            <div className="w-3 h-3 bg-red-500 rounded-full"></div>
            <span className="text-gray-700 dark:text-gray-300">High Frequency</span>
          </div>
          <div className="flex items-center space-x-2">
            <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
            <span className="text-gray-700 dark:text-gray-300">Medium Frequency</span>
          </div>
          <div className="flex items-center space-x-2">
            <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
            <span className="text-gray-700 dark:text-gray-300">Low Frequency</span>
          </div>
        </div>
      </div>

      <LoadScript
        googleMapsApiKey="AIzaSyAaZAMrfpUUlJ2FHx0wfmMAL7ssrJUFrYY"
        libraries={libraries}
      >
        <GoogleMap
          mapContainerStyle={containerStyle}
          center={defaultCenter}
          zoom={11}
          onLoad={onLoad}
          onUnmount={onUnmount}
          mapTypeId={viewMode === 'satellite' ? 'satellite' : 'roadmap'}
          options={{
            disableDefaultUI: false,
            zoomControl: true,
            mapTypeControl: false,
            scaleControl: true,
            streetViewControl: false,
            rotateControl: false,
            fullscreenControl: true,
            styles: viewMode === 'normal' ? [
              {
                featureType: 'all',
                stylers: [{ saturation: -20 }]
              }
            ] : undefined
          }}
        >
          {/* Highlighted Areas */}
          {viewMode === 'areas' && isLoaded && (
            <>
              {/* High Frequency Areas - Red */}
              {highlightedAreas.highFrequency.map((area) => (
                <Polygon
                  key={area.id}
                  paths={area.paths}
                  options={{
                    fillColor: area.color,
                    fillOpacity: area.opacity,
                    strokeColor: area.color,
                    strokeOpacity: 0.8,
                    strokeWeight: 2
                  }}
                />
              ))}
              
              {/* Medium Frequency Areas - Yellow */}
              {highlightedAreas.mediumFrequency.map((area) => (
                <Polygon
                  key={area.id}
                  paths={area.paths}
                  options={{
                    fillColor: area.color,
                    fillOpacity: area.opacity,
                    strokeColor: area.color,
                    strokeOpacity: 0.8,
                    strokeWeight: 2
                  }}
                />
              ))}
              
              {/* Low Frequency Areas - Green */}
              {highlightedAreas.lowFrequency.map((area) => (
                <Polygon
                  key={area.id}
                  paths={area.paths}
                  options={{
                    fillColor: area.color,
                    fillOpacity: area.opacity,
                    strokeColor: area.color,
                    strokeOpacity: 0.8,
                    strokeWeight: 2
                  }}
                />
              ))}
            </>
          )}

          {/* Markers for normal view */}
          {(viewMode === 'normal' || viewMode === 'areas') && isLoaded && markerData.map((marker) => (
            <Marker
              key={marker.id}
              position={marker.position}
              icon={getMarkerIcon(marker.urgency)}
              onClick={() => setSelectedMarker(marker)}
            />
          ))}

          {/* Info Window */}
          {selectedMarker && (
            <InfoWindow
              position={selectedMarker.position}
              onCloseClick={() => setSelectedMarker(null)}
            >
              <div className="p-2 max-w-xs">
                <h3 className="font-semibold text-gray-900 mb-1">{selectedMarker.title}</h3>
                <p className="text-sm text-gray-600 mb-2">{selectedMarker.description}</p>
                <div className="flex items-center justify-between text-xs">
                  <span className={`px-2 py-1 rounded-full font-medium ${
                    selectedMarker.urgency === 'high' ? 'bg-red-100 text-red-800' :
                    selectedMarker.urgency === 'medium' ? 'bg-yellow-100 text-yellow-800' :
                    'bg-green-100 text-green-800'
                  }`}>
                    {selectedMarker.urgency.toUpperCase()}
                  </span>
                  <span className="text-gray-500">{selectedMarker.status}</span>
                </div>
              </div>
            </InfoWindow>
          )}
        </GoogleMap>
      </LoadScript>
    </div>
  );
};

export default GoogleMapComponent;