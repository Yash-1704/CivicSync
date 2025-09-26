// lib/screens/home/home_user.dart
import 'dart:async';
import 'dart:math';
import 'package:civicsync/screens/home/maps_page.dart';
import 'package:civicsync/screens/home/my_reports_page.dart';
import 'package:civicsync/screens/home/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'add_report_page.dart';
import 'profile_page.dart';
import 'menu_drawer.dart';
import 'search_page.dart';
import '../../services/theme_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart'; // audio player

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  final List<String> sorts = ['Trending', 'Latest', 'Nearby', 'High'];
  int _selectedSortIndex = 0;

  // Fetched posts from Firestore
  List<Map<String, dynamic>> _posts = [];

  // Track report IDs liked by current user (realtime via collectionGroup)
  final Set<String> _likedReportIds = {};

  final List<String> statuses = ['Pending', 'In Progress', 'Resolved'];
  final Map<String, Color> statusColors = {
    'Pending': const Color(0xFFF7D154),
    'In Progress': const Color(0xFF4DA1FF),
    'Resolved': const Color(0xFF3AC47D),
  };

  int _selectedIndex = 0;

  final ScrollController _scrollController = ScrollController();
  bool _headerVisible = true;
  double _lastOffset = 0.0;
  final double _scrollThreshold = 20.0;

  final double _toolbarHeight = 72.0;
  final double _chipsHeight = 64.0;

  DateTime _lastToggleTime = DateTime.fromMillisecondsSinceEpoch(0);
  final Duration _toggleDebounce = const Duration(milliseconds: 200);

  // scaffold key for drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _likesSub;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _startLikesListener();
  }

  @override
  void dispose() {
    _likesSub?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _startLikesListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Not signed in — clear likes
      setState(() => _likedReportIds.clear());
      return;
    }

    // Listen to all likes made by this user across reports
    // Each like doc is expected to contain a 'reportId' field
    _likesSub = FirebaseFirestore.instance
        .collectionGroup('likes')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snap) {
      final newSet = <String>{};
      for (final doc in snap.docs) {
        final data = doc.data();
        final reportId = data['reportId'] as String? ?? (doc.reference.parent.parent?.id);
        if (reportId != null) newSet.add(reportId);
      }
      setState(() => _likedReportIds
        ..clear()
        ..addAll(newSet));
    }, onError: (_) {
      // ignore listener errors silently — liked set will remain empty if error
    });
  }

  // Firestore stream for all reports (everybody)
  Stream<QuerySnapshot<Map<String, dynamic>>> get _reportsStream {
    return FirebaseFirestore.instance
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.position.pixels;
    final delta = offset - _lastOffset;
    final now = DateTime.now();

    if (now.difference(_lastToggleTime) < _toggleDebounce) {
      _lastOffset = offset.clamp(0.0, double.infinity);
      return;
    }

    if (delta > _scrollThreshold && _headerVisible) {
      _lastToggleTime = now;
      setState(() => _headerVisible = false);
    } else if (delta < -_scrollThreshold && !_headerVisible) {
      _lastToggleTime = now;
      setState(() => _headerVisible = true);
    }

    _lastOffset = offset.clamp(0.0, double.infinity);
  }

  void _applySortToList(List<Map<String, dynamic>> list) {
    switch (_selectedSortIndex) {
      case 0: // Trending -> by upvotes desc
        list.sort((a, b) => (b['upvotes'] ?? 0).compareTo(a['upvotes'] ?? 0));
        break;
      case 1: // Latest -> by createdAt desc
        list.sort((a, b) {
          final aTs = a['createdAt'] as Timestamp?;
          final bTs = b['createdAt'] as Timestamp?;
          if (aTs != null && bTs != null) return bTs.compareTo(aTs);
          return 0;
        });
        break;
      case 2: // Nearby -> by distanceKm asc (if missing, push to end)
        list.sort((a, b) => (a['distanceKm'] ?? double.infinity).compareTo(b['distanceKm'] ?? double.infinity));
        break;
      case 3: // High -> severity desc
        list.sort((a, b) => (b['severity'] ?? 0).compareTo(a['severity'] ?? 0));
        break;
    }
  }

  void _onSortSelected(int index) {
    if (_selectedSortIndex == index) return;
    setState(() => _selectedSortIndex = index);
  }

  Future<void> _toggleLike(String reportId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please sign in to like reports.')));
      return;
    }

    final uid = user.uid;
    final reportRef = FirebaseFirestore.instance.collection('reports').doc(reportId);
    final likeRef = reportRef.collection('likes').doc(uid);

    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final likeSnap = await tx.get(likeRef);
        // Ensure report exists (if it doesn't, abort)
        final reportSnap = await tx.get(reportRef);
        if (!reportSnap.exists) {
          throw Exception('Report not found');
        }

        if (likeSnap.exists) {
          // unlike
          tx.delete(likeRef);
          tx.update(reportRef, {'upvotes': FieldValue.increment(-1)});
        } else {
          // like
          tx.set(likeRef, {
            'userId': uid,
            'reportId': reportId,
            'createdAt': FieldValue.serverTimestamp(),
          });
          tx.update(reportRef, {'upvotes': FieldValue.increment(1)});
        }
      });
      // runTransaction succeeded — UI will update via stream listeners
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to toggle like: ${e.toString()}')));
    }
  }

  void _onBottomNavTap(int idx) {
    setState(() => _selectedIndex = idx);
    if (idx == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => MapsPage()));
      return;
    }
    if (idx == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddReportPage()));
      return;
    }
    if (idx == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => MyReportsPage()));
      return;
    }
    if (idx == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(['Home', 'Maps', 'Add Report', 'My Reports', 'Profile'][idx])),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final themeService = Provider.of<ThemeService>(context);
    final primaryText = themeService.getPrimaryTextColor(context);
    final secondaryText = themeService.getSecondaryTextColor(context);
    final secondaryBg = themeService.getSecondaryBackgroundColor(context);

    Widget toolbar = Container(
      height: _toolbarHeight - 12,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.menu, color: primaryText),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            elevation: 6,
            shape: const CircleBorder(),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.location_city, color: secondaryBg),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CivicSync',
                style: TextStyle(
                  fontSize: 18,
                  color: primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Report. Track. Resolve.',
                style: TextStyle(color: secondaryText, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
            },
            icon: Icon(Icons.search, color: primaryText),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
            },
            icon: Icon(Icons.notifications_none, color: primaryText),
          ),
        ],
      ),
    );

    Widget chips = SizedBox(
      height: _chipsHeight - 4,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: sorts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final selected = _selectedSortIndex == idx;
          return _AccessibleSortChip(
            label: sorts[idx],
            selected: selected,
            onPressed: () => _onSortSelected(idx),
            activeGradient: Provider.of<ThemeService>(context).getAccentGradient(context),
          );
        },
      ),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: Provider.of<ThemeService>(context).getBackgroundGradient(context),
      ),
      child: Column(
        children: [
          SizedBox(height: topPadding),
          toolbar,
          chips,
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final String docId = post['docId'] as String;
    final bool upvoted = _likedReportIds.contains(docId);
    final status = post['status'] as String;
    final statusColor = statusColors[status] ?? Colors.white;
    final theme = Theme.of(context);
    final themeService = Provider.of<ThemeService>(context);
    final primaryText = themeService.getPrimaryTextColor(context);
    final secondaryText = themeService.getSecondaryTextColor(context);
    final onSurface = theme.colorScheme.onSurface;
    final divider = theme.dividerColor;

    return Card(
      color: theme.cardColor,
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  post['imageUrl'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: theme.cardColor,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(themeService.getPrimaryAccentColor(context)),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.cardColor,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: theme.iconTheme.color,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Audio player — only if audioUrl present
            if (post['audioUrl'] != null && (post['audioUrl'] as String).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ReportAudioPlayer(audioUrl: post['audioUrl'] as String),
              ),

            Row(
              children: [
                Expanded(
                  child: Text(
                    post['title'],
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                      color: primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  post['time'],
                  style: TextStyle(color: secondaryText),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.28)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: TextStyle(
                          color: secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.reply, size: 16, color: onSurface),
                  label: Text('Reply', style: TextStyle(color: onSurface)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: onSurface,
                    side: BorderSide(color: divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _toggleLike(docId),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: upvoted ? themeService.getPrimaryAccentColor(context).withOpacity(0.18) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: divider.withOpacity(0.8)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          upvoted ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: upvoted ? theme.colorScheme.onPrimary : secondaryText,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${post['upvotes'] ?? 0}',
                          style: TextStyle(
                            color: upvoted ? theme.colorScheme.onPrimary : secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
                  child: Icon(Icons.person, color: theme.iconTheme.color),
                ),
                const SizedBox(width: 8),
                Text(
                  post['author'],
                  style: TextStyle(color: secondaryText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeed() {
    final theme = Theme.of(context);
    final themeService = Provider.of<ThemeService>(context);
    final textColor = themeService.getSecondaryTextColor(context);

    return RefreshIndicator(
      onRefresh: () async {
        // Stream is realtime; refresh will just rebuild UI.
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 400));
      },
      color: themeService.getPrimaryAccentColor(context),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _reportsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading feed: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          // Build posts list from docs
          final List<Map<String, dynamic>> posts = [];
          for (var doc in docs) {
            final data = doc.data();

            // Title: prefer explicit title, otherwise description
            final title = (data['title'] as String?)?.trim().isNotEmpty == true
                ? (data['title'] as String)
                : (data['description'] as String?) ?? 'Untitled Report';

            // Author: fallbacks used
            final author = (data['authorName'] as String?) ??
                (data['author'] as String?) ??
                (data['createdBy'] as String?) ??
                'Unknown';

            // Time: createdAt -> format to '2h', '5m', etc.
            final createdAt = data['createdAt'] as Timestamp?;
            final time = _formatTimeAgo(createdAt);

            // Upvotes: may not exist in your schema
            final upvotes = (data['upvotes'] is int)
                ? data['upvotes'] as int
                : (data['upvotes'] is double) ? (data['upvotes'] as double).toInt() : 0;

            // Status: normalize
            final rawStatus = (data['status'] as String?) ?? 'pending';
            final status = _normalizeStatus(rawStatus);

            // image extraction: prefer imageUrls list, then imageUrl or imageURL
            String imageUrl = '';
            try {
              final images = data['imageUrls'];
              if (images is List && images.isNotEmpty) {
                imageUrl = images.first as String;
              } else if ((data['imageUrl'] as String?)?.isNotEmpty == true) {
                imageUrl = data['imageUrl'] as String;
              } else if ((data['imageURL'] as String?)?.isNotEmpty == true) {
                imageUrl = data['imageURL'] as String;
              }
            } catch (_) {
              imageUrl = '';
            }

            // audio extraction (supports audioUrl, audioURL, or audioUrls list)
            String audioUrl = '';
            try {
              final audios = data['audioUrls'];
              if (audios is List && audios.isNotEmpty) {
                audioUrl = audios.first as String;
              } else if ((data['audioUrl'] as String?)?.isNotEmpty == true) {
                audioUrl = data['audioUrl'] as String;
              } else if ((data['audioURL'] as String?)?.isNotEmpty == true) {
                audioUrl = data['audioURL'] as String;
              }
            } catch (_) {
              audioUrl = '';
            }

            final distanceKm = (data['distanceKm'] is num) ? (data['distanceKm'] as num).toDouble() : null;
            final severity = (data['severity'] is int) ? data['severity'] as int : 0;

            posts.add({
              'docId': doc.id,
              'title': title,
              'time': time,
              'author': author,
              'upvotes': upvotes,
              'status': status,
              'imageUrl': imageUrl.isNotEmpty ? imageUrl : 'https://picsum.photos/seed/${doc.id}/800/400',
              'audioUrl': audioUrl,
              'distanceKm': distanceKm ?? double.infinity,
              'severity': severity,
              'createdAt': createdAt,
            });
          }

          // Apply sort chosen by user
          _applySortToList(posts);

          // keep a local copy for local operations (we still persist likes to backend)
          _posts = posts;

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 10, top: 6),
            itemCount: _posts.length + 1,
            itemBuilder: (context, idx) {
              if (idx == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Card(
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          'Community Snapshot / Top Hotspot',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              }
              final post = _posts[idx - 1];
              return _buildPostCard(post);
            },
          );
        },
      ),
    );
  }

  String _formatTimeAgo(Timestamp? ts) {
    if (ts == null) return 'now';
    final dt = ts.toDate();
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }

  String _normalizeStatus(String s) {
    final lower = s.toLowerCase();
    switch (lower) {
      case 'pending':
        return 'Pending';
      case 'in progress':
      case 'in_progress':
      case 'inprogress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      default:
        if (s.isEmpty) return 'Pending';
        return s[0].toUpperCase() + s.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double headerHeight =
        (_toolbarHeight + _chipsHeight + topPadding - 12).clamp(
          0.0,
          double.infinity,
        );

    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuDrawer(),
      backgroundColor: Provider.of<ThemeService>(context).getPrimaryBackgroundColor(context),
      body: Stack(
        children: [
          Positioned.fill(child: _buildFeed()),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            top: _headerVisible ? 0 : -headerHeight,
            left: 0,
            right: 0,
            height: headerHeight,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _headerVisible ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              child: ClipRect(child: _buildHeader(context)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}

/// ---------- CustomBottomBar (unchanged logic but kept here full) ----------
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomBottomBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double barHeight = 56; // Slightly increased to avoid overflow
    final themeService = Provider.of<ThemeService>(context);
    final Color bgA = themeService.getPrimaryBackgroundColor(context);
    final Color bgB = themeService.getSecondaryBackgroundColor(context);
    final Color accent = themeService.getPrimaryAccentColor(context);
    final Color accent2 = themeService.getSecondaryAccentColor(context);
    final primaryText = themeService.getPrimaryTextColor(context);
    final secondaryText = themeService.getSecondaryTextColor(context);

    return SafeArea(
      top: false,
      child: Container(
        height: barHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgA, bgB],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.black26 : Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _buildButton(Icons.home, 'Home', 0, accent, accent2, primaryText, secondaryText)),
            Expanded(child: _buildButton(Icons.map, 'Maps', 1, accent, accent2, primaryText, secondaryText)),
            Expanded(child: _buildButton(
              Icons.add,
              'Add Report',
              2,
              accent,
              accent2,
              primaryText,
              secondaryText,
              emphasize: true,
            )),
            Expanded(child: _buildButton(Icons.list_alt, 'My Reports', 3, accent, accent2, primaryText, secondaryText)),
            Expanded(child: _buildButton(Icons.person, 'Profile', 4, accent, accent2, primaryText, secondaryText)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    IconData icon,
    String label,
    int index,
    Color accent,
    Color accent2,
    Color primaryText,
    Color secondaryText, {
    bool emphasize = false,
  }) {
    final bool active = index == currentIndex;
    final double iconSize = emphasize ? 28 : 20;

    final Gradient buttonGradient = LinearGradient(
      colors: [accent2, accent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: emphasize
                    ? BoxDecoration(
                        gradient: buttonGradient,
                        shape: BoxShape.circle,
                      )
                    : null,
                padding: emphasize ? const EdgeInsets.all(6) : EdgeInsets.zero,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: active ? Colors.white : secondaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: active ? Colors.white : secondaryText,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------- Accessible Sort Chip (unchanged) ----------
class _AccessibleSortChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final Gradient activeGradient;

  const _AccessibleSortChip({
    required this.label,
    required this.selected,
    required this.onPressed,
    required this.activeGradient,
  });

  @override
  State<_AccessibleSortChip> createState() => _AccessibleSortChipState();
}

class _AccessibleSortChipState extends State<_AccessibleSortChip> {
  bool _focused = false;
  bool _hovering = false;

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        widget.onPressed();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final themeService = Provider.of<ThemeService>(context);
    final primaryText = themeService.getPrimaryTextColor(context);
    final secondaryText = themeService.getSecondaryTextColor(context);

    return FocusableActionDetector(
      onShowFocusHighlight: (f) => setState(() => _focused = f),
      onShowHoverHighlight: (h) => setState(() => _hovering = h),
      onFocusChange: (f) => setState(() => _focused = f),
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) => widget.onPressed(),
        ),
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Semantics(
          button: true,
          label: widget.label,
          selected: selected,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: selected ? widget.activeGradient : null,
                color: selected ? null : Theme.of(context).cardColor.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : _focused
                        ? [BoxShadow(color: Colors.black12, blurRadius: 6)]
                        : null,
                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.6)),
              ),
              child: Row(
                children: [
                  if (selected) Icon(Icons.check, size: 16, color: Colors.white),
                  if (selected) const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: selected ? Colors.white : secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///// ---------- ReportIssuePage (unchanged stub) ----------
class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Report'),
        backgroundColor: themeService.getSecondaryBackgroundColor(context),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: themeService.getPrimaryBackgroundColor(context),
        child: Column(
          children: [
            Text(
              'Report submission screen (stub). Replace this with your report form: camera, location, category, description.',
              style: TextStyle(color: themeService.getSecondaryTextColor(context)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------- NEW: ReportAudioPlayer (compact, rounded aesthetic) ----------
class ReportAudioPlayer extends StatefulWidget {
  final String audioUrl;
  const ReportAudioPlayer({required this.audioUrl, super.key});

  @override
  State<ReportAudioPlayer> createState() => _ReportAudioPlayerState();
}

class _ReportAudioPlayerState extends State<ReportAudioPlayer> {
  late final AudioPlayer _player;
  bool _loading = true;
  bool _loadError = false;

  // seeking state
  bool _isSeeking = false;
  double _seekPositionMs = 0.0;

  StreamSubscription<ProcessingState>? _processingSub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(widget.audioUrl);

      // Listen for completion — when completed, pause and reset to 0
      _processingSub = _player.processingStateStream.listen((processingState) {
        if (processingState == ProcessingState.completed) {
          _player.pause();
          _player.seek(Duration.zero);
          // ensure UI updates
          setState(() {});
        }
      });

      setState(() {
        _loading = false;
        _loadError = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  @override
  void dispose() {
    _processingSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Future<void> _handlePlayPause() async {
    final playing = _player.playing;
    final duration = _player.duration ?? Duration.zero;
    final pos = _player.position;

    if (playing) {
      // Pause and reset to 0:00 as requested
      await _player.pause();
      await _player.seek(Duration.zero);
      setState(() {});
      return;
    }

    // If we are at end, reset before play
    if (duration != Duration.zero && pos >= duration) {
      await _player.seek(Duration.zero);
    }
    await _player.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // compact dimensions
    const double iconSize = 28;
    const double containerVerticalPadding = 6;
    const double containerHorizontalPadding = 8;
    const double borderRadius = 14.0;

    if (_loading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: containerHorizontalPadding, vertical: containerVerticalPadding),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 32, height: 32, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
            const SizedBox(width: 10),
            Text('Loading audio...', style: TextStyle(color: theme.textTheme.bodySmall?.color)),
          ],
        ),
      );
    }

    if (_loadError) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: containerHorizontalPadding, vertical: containerVerticalPadding),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
            const SizedBox(width: 8),
            Text('Failed to load audio', style: TextStyle(color: theme.textTheme.bodySmall?.color)),
          ],
        ),
      );
    }

    return StreamBuilder<Duration?>(
      stream: _player.durationStream,
      builder: (context, durSnap) {
        final duration = durSnap.data ?? Duration.zero;
        final durMs = duration.inMilliseconds.toDouble().clamp(0.0, double.infinity);

        return StreamBuilder<Duration>(
          stream: _player.positionStream,
          builder: (context, posSnap) {
            final position = posSnap.data ?? Duration.zero;
            final effectivePositionMs = _isSeeking ? _seekPositionMs : position.inMilliseconds.toDouble();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: containerHorizontalPadding, vertical: containerVerticalPadding),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Row(
                children: [
                  IconButton(
                    iconSize: iconSize,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    icon: Icon(_player.playing ? Icons.pause_circle_filled : Icons.play_circle_filled),
                    onPressed: _handlePlayPause,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Slim slider
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                            thumbColor: theme.colorScheme.primary,
                            activeTrackColor: theme.colorScheme.primary,
                          ),
                          child: Slider(
                            min: 0,
                            max: durMs > 0 ? durMs : 1,
                            value: effectivePositionMs.clamp(0.0, durMs > 0 ? durMs : 1),
                            onChangeStart: (_) {
                              setState(() => _isSeeking = true);
                            },
                            onChanged: (v) {
                              setState(() => _seekPositionMs = v);
                            },
                            onChangeEnd: (v) async {
                              final seekTo = Duration(milliseconds: v.round());
                              await _player.seek(seekTo);
                              setState(() {
                                _isSeeking = false;
                                _seekPositionMs = 0.0;
                              });
                            },
                          ),
                        ),
                        // tiny timestamps
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_format(Duration(milliseconds: effectivePositionMs.round())), style: TextStyle(fontSize: 11, color: theme.textTheme.bodySmall?.color)),
                            Text(_format(duration), style: TextStyle(fontSize: 11, color: theme.textTheme.bodySmall?.color)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
