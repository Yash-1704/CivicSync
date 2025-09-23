import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/../services/theme_service.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? _mapController;
  bool _isMapExpanded = false;
  bool _useGoogleMaps = true; // Start with Google Maps by default
  
  // Your Google Maps API key
  static const String _googleMapsApiKey = "AIzaSyAaZAMrfpUUlJ2FHx0wfmMAL7ssrJUFrYY";
  
  // Sample issue data with coordinates
  final List<Map<String, dynamic>> _issues = [
    {
      "id": "1",
      "title": "Pothole near Block 5",
      "description": "Large pothole causing traffic issues. Reported 2 days ago by multiple residents.",
      "status": "Pending",
      "distance": "0.8 km",
      "location": LatLng(37.7749, -122.4194), // San Francisco coordinates
      "severity": "High",
      "reportedBy": "John Doe"
    },
    {
      "id": "2",
      "title": "Broken Streetlight",
      "description": "Streetlight not working since last week. Creating safety concerns for pedestrians.",
      "status": "In Progress",
      "distance": "1.2 km",
      "location": LatLng(37.7849, -122.4094),
      "severity": "Medium",
      "reportedBy": "Jane Smith"
    },
    {
      "id": "3",
      "title": "Graffiti Cleaned",
      "description": "Graffiti was successfully removed from the community center wall.",
      "status": "Resolved",
      "distance": "2.5 km",
      "location": LatLng(37.7949, -122.3994),
      "severity": "Low",
      "reportedBy": "City Cleanup Crew"
    },
    {
      "id": "4",
      "title": "Blocked Drain",
      "description": "Storm drain blocked with debris. Water accumulating during rain.",
      "status": "Pending",
      "distance": "1.8 km",
      "location": LatLng(37.7649, -122.4294),
      "severity": "High",
      "reportedBy": "Municipal Worker"
    },
  ];
  
  Set<Marker> _markers = {};
  
  @override
  void initState() {
    super.initState();
    _createMarkers();
  }
  
  void _createMarkers() {
    _markers = _issues.map((issue) {
      return Marker(
        markerId: MarkerId(issue["id"]),
        position: issue["location"],
        icon: _getMarkerIcon(issue["status"]),
        onTap: () => _showIssueDetails(issue),
        infoWindow: InfoWindow(
          title: issue["title"],
          snippet: issue["status"],
        ),
      );
    }).toSet();
  }
  
  BitmapDescriptor _getMarkerIcon(String status) {
    switch (status) {
      case "Pending":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case "In Progress":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case "Resolved":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }
  
  void _showIssueDetails(Map<String, dynamic> issue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeService.getPrimaryBackgroundColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          issue["title"],
                          style: TextStyle(
                            color: themeService.getPrimaryTextColor(context),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: themeService.getSecondaryTextColor(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Status and severity
                  Row(
                    children: [
                      _buildStatusChip(issue["status"], themeService),
                      const SizedBox(width: 12),
                      _buildSeverityChip(issue["severity"], themeService),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    "Description:",
                    style: TextStyle(
                      color: themeService.getPrimaryTextColor(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    issue["description"],
                    style: TextStyle(
                      color: themeService.getSecondaryTextColor(context),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Additional info
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: themeService.getSecondaryTextColor(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Reported by: ${issue["reportedBy"]}",
                        style: TextStyle(
                          color: themeService.getSecondaryTextColor(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: themeService.getSecondaryTextColor(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Distance: ${issue["distance"]}",
                        style: TextStyle(
                          color: themeService.getSecondaryTextColor(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Add navigation or additional actions here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeService.getPrimaryAccentColor(context),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStatusChip(String status, ThemeService themeService) {
    Color chipColor;
    switch (status) {
      case "Pending":
        chipColor = Colors.orange;
        break;
      case "In Progress":
        chipColor = Colors.blue;
        break;
      case "Resolved":
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildSeverityChip(String severity, ThemeService themeService) {
    Color chipColor;
    switch (severity) {
      case "High":
        chipColor = Colors.red;
        break;
      case "Medium":
        chipColor = Colors.orange;
        break;
      case "Low":
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Text(
        "$severity Priority",
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.getPrimaryBackgroundColor(context),
          appBar: AppBar(
            title: const Text("City Map"),
            backgroundColor: themeService.getSecondaryBackgroundColor(context),
            foregroundColor: themeService.getPrimaryTextColor(context),
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  _isMapExpanded ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: themeService.getPrimaryTextColor(context),
                ),
                onPressed: () {
                  setState(() {
                    _isMapExpanded = !_isMapExpanded;
                  });
                },
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: themeService.getBackgroundGradient(context),
            ),
            child: Column(
              children: [
                // Real Google Maps Integration
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isMapExpanded ? MediaQuery.of(context).size.height * 0.7 : 250,
                  margin: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _useGoogleMaps ? _buildGoogleMap() : _buildFallbackMap(themeService),
                  ),
                ),
                
                // Map controls
                if (!_isMapExpanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMapControlButton(
                          "Zoom to Issues",
                          Icons.center_focus_strong,
                          () => _zoomToFitMarkers(),
                          themeService,
                        ),
                        _buildMapControlButton(
                          "My Location",
                          Icons.my_location,
                          () => _goToMyLocation(),
                          themeService,
                        ),
                        _buildMapControlButton(
                          "Toggle View",
                          Icons.layers,
                          () => _toggleMapType(),
                          themeService,
                        ),
                      ],
                    ),
                  ),
                if (!_isMapExpanded)
                  const SizedBox(height: 16),

                // Section header
                if (!_isMapExpanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nearby Issues",
                          style: TextStyle(
                            color: themeService.getPrimaryTextColor(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${_issues.length} issues",
                          style: TextStyle(
                            color: themeService.getSecondaryTextColor(context),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Issues list
                if (!_isMapExpanded)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _issues.length,
                      itemBuilder: (context, index) {
                        final issue = _issues[index];
                        return Card(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(issue["status"]).withOpacity(0.7),
                              child: const Icon(Icons.location_on, color: Colors.white),
                            ),
                            title: Text(
                              issue["title"],
                              style: TextStyle(
                                color: themeService.getPrimaryTextColor(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "${issue["status"]} • ${issue["distance"]} • ${issue["severity"]} Priority",
                              style: TextStyle(
                                color: themeService.getSecondaryTextColor(context),
                                fontSize: 12,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: themeService.getSecondaryTextColor(context),
                            ),
                            onTap: () {
                              _showIssueDetails(issue);
                              _moveToLocation(issue["location"]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMapControlButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    ThemeService themeService,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: themeService.getPrimaryAccentColor(context).withOpacity(0.1),
            foregroundColor: themeService.getPrimaryAccentColor(context),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: themeService.getPrimaryAccentColor(context).withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      case "Resolved":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  void _zoomToFitMarkers() {
    if (_mapController != null && _markers.isNotEmpty) {
      final bounds = _calculateBounds(_markers.map((m) => m.position).toList());
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Zooming to fit all issues..."),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  
  LatLngBounds _calculateBounds(List<LatLng> positions) {
    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;
    
    for (LatLng position in positions) {
      minLat = minLat < position.latitude ? minLat : position.latitude;
      maxLat = maxLat > position.latitude ? maxLat : position.latitude;
      minLng = minLng < position.longitude ? minLng : position.longitude;
      maxLng = maxLng > position.longitude ? maxLng : position.longitude;
    }
    
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
  
  void _goToMyLocation() {
    // Center on San Francisco for demo - replace with actual location services
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          const LatLng(37.7749, -122.4194),
          15.0,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Centering on your location..."),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  
  void _toggleMapType() {
    setState(() {
      _useGoogleMaps = !_useGoogleMaps;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _useGoogleMaps 
              ? "Switched to Google Maps"
              : "Switched to demo map view",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  void _moveToLocation(LatLng location) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(location, 16.0),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Moving to location: ${location.latitude}, ${location.longitude}"),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
  
  // Fallback map widget when Google Maps is not available
  Widget _buildFallbackMap(ThemeService themeService) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeService.getPrimaryAccentColor(context).withOpacity(0.1),
            themeService.getSecondaryAccentColor(context).withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: themeService.getSecondaryTextColor(context).withOpacity(0.3),
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: MapPatternPainter(themeService.getSecondaryTextColor(context).withOpacity(0.1)),
            ),
          ),
          // Issues overlay
          Positioned.fill(
            child: _buildIssueOverlay(themeService),
          ),
          // Map info overlay
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeService.getPrimaryBackgroundColor(context).withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.map,
                    color: themeService.getPrimaryAccentColor(context),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Interactive Map View",
                          style: TextStyle(
                            color: themeService.getPrimaryTextColor(context),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${_issues.length} issues in your area",
                          style: TextStyle(
                            color: themeService.getSecondaryTextColor(context),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _useGoogleMaps = !_useGoogleMaps;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _useGoogleMaps 
                                ? "Switched to Google Maps (requires API key setup)"
                                : "Switched to demo map view",
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: themeService.getPrimaryAccentColor(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: themeService.getPrimaryAccentColor(context),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIssueOverlay(ThemeService themeService) {
    return Stack(
      children: _issues.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> issue = entry.value;
        
        // Calculate position based on index for demo
        double left = 20.0 + (index % 3) * 80.0;
        double top = 60.0 + (index ~/ 3) * 60.0;
        
        return Positioned(
          left: left,
          top: top,
          child: GestureDetector(
            onTap: () => _showIssueDetails(issue),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor(issue["status"]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getStatusColor(issue["status"]).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  // Google Maps widget with your API key
  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      initialCameraPosition: const CameraPosition(
        target: LatLng(37.7749, -122.4194), // San Francisco
        zoom: 12.0,
      ),
      markers: _markers,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      compassEnabled: true,
      mapToolbarEnabled: true,
      onTap: (LatLng position) {
        print('Map tapped at: ${position.latitude}, ${position.longitude}');
      },
    );
  }
}

// Custom painter for map background pattern
class MapPatternPainter extends CustomPainter {
  final Color color;
  
  MapPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    // Draw grid pattern
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
    
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}