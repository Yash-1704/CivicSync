// lib/screens/home/home_user.dart
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

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  final List<String> sorts = ['Trending', 'Latest', 'Nearby', 'High'];
  int _selectedSortIndex = 0;

  late List<Map<String, dynamic>> _posts;
  final Set<int> _upvoted = {};

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

  // ADDED: scaffold key for opening the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _generatePosts();
    _applySort();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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

  void _generatePosts() {
    final rnd = Random();
    _posts = List.generate(8, (i) {
      final picId = 100 + i;
      final status = statuses[rnd.nextInt(statuses.length)];
      final upvotes = rnd.nextInt(20) + 1;
      return {
        'id': i,
        'title': 'Pothole near Block ${i + 1}',
        'time': '${(i + 1) * 2}h',
        'author': 'User ${i + 1}',
        'upvotes': upvotes,
        'status': status,
        'imageUrl': 'https://picsum.photos/id/$picId/800/400',
        'distanceKm': rnd.nextDouble() * 5,
        'severity': rnd.nextInt(3),
      };
    });
  }

  void _applySort() {
    setState(() {
      switch (_selectedSortIndex) {
        case 0:
          _posts.sort((a, b) => b['upvotes'].compareTo(a['upvotes']));
          break;
        case 1:
          _posts.sort((a, b) => b['id'].compareTo(a['id']));
          break;
        case 2:
          _posts.sort((a, b) => a['distanceKm'].compareTo(b['distanceKm']));
          break;
        case 3:
          _posts.sort((a, b) => b['severity'].compareTo(a['severity']));
          break;
      }
    });
  }

  void _onSortSelected(int index) {
    if (_selectedSortIndex == index) return;
    _selectedSortIndex = index;
    _applySort();
  }

  void _toggleUpvote(int postId) {
    setState(() {
      final post = _posts.firstWhere((p) => p['id'] == postId);
      if (_upvoted.contains(postId)) {
        _upvoted.remove(postId);
        post['upvotes'] = (post['upvotes'] as int) - 1;
      } else {
        _upvoted.add(postId);
        post['upvotes'] = (post['upvotes'] as int) + 1;
      }
    });
  }

  void _onBottomNavTap(int idx) {
    setState(() => _selectedIndex = idx);
    if (idx == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => MapsPage()));
    }
    if (idx == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddReportPage()),
      );
    }
    if (idx == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MyReportsPage()),
      );
    }
    if (idx == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ['Home', 'Maps', 'Add Report', 'My Reports', 'Profile'][idx],
          ),
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    Widget toolbar = Container(
      height: _toolbarHeight - 12,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              // ADDED: open the drawer
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.menu, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            elevation: 6,
            shape: const CircleBorder(),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.location_city, color: Provider.of<ThemeService>(context).getSecondaryBackgroundColor(context)),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'CivicSync',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Report. Track. Resolve.',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
            icon: const Icon(Icons.notifications_none, color: Colors.white),
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
    final int id = post['id'] as int;
    final bool upvoted = _upvoted.contains(id);
    final status = post['status'] as String;
    final statusColor = statusColors[status] ?? Colors.white;

    return Card(
      color: Colors.white.withOpacity(0.03),
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
                      color: Colors.white.withOpacity(0.02),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white.withOpacity(0.02),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    post['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  post['time'],
                  style: const TextStyle(color: Colors.white70),
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
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.reply, size: 16),
                  label: const Text('Reply'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.06)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _toggleUpvote(id),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: upvoted
                          ? Provider.of<ThemeService>(context).getPrimaryAccentColor(context).withOpacity(0.18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          upvoted ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: upvoted ? Colors.white : Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${post['upvotes']}',
                          style: TextStyle(
                            color: upvoted ? Colors.white : Colors.white70,
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
                  backgroundColor: Colors.white24,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  post['author'],
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeed() {
    return RefreshIndicator(
      onRefresh: () async {
        _generatePosts();
        _applySort();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 10, top: 6),
        itemCount: _posts.length + 1,
        itemBuilder: (context, idx) {
          if (idx == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Card(
                color: Colors.white.withOpacity(0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      'Community Snapshot / Top Hotspot',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
              ),
            );
          }
          final post = _posts[idx - 1];
          return _buildPostCard(post);
        },
      ),
    );
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
      key: _scaffoldKey, // ADDED
      drawer: MenuDrawer(), // ADDED
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
    final Color darkA = themeService.getPrimaryBackgroundColor(context);
    final Color darkB = themeService.getSecondaryBackgroundColor(context);
    final Color accent = themeService.getPrimaryAccentColor(context);
    final Color accent2 = themeService.getSecondaryAccentColor(context);

    return SafeArea(
      top: false,
      child: Container(
        height: barHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [darkA, darkB],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildButton(Icons.home, 'Home', 0, accent, accent2),
            _buildButton(Icons.map, 'Maps', 1, accent, accent2),
            _buildButton(
              Icons.add,
              'Add Report',
              2,
              accent,
              accent2,
              emphasize: true,
            ),
            _buildButton(Icons.list_alt, 'My Reports', 3, accent, accent2),
            _buildButton(Icons.person, 'Profile', 4, accent, accent2),
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
    Color accent2, {
    bool emphasize = false,
  }) {
    final bool active = index == currentIndex;
    final double iconSize = emphasize ? 28 : 20;

    final Gradient buttonGradient = LinearGradient(
      colors: [accent2, accent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
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
              color: active ? Colors.white : Colors.white70,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: active ? Colors.white : Colors.white70,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

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
                color: selected ? null : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : _focused
                    ? [BoxShadow(color: Colors.white10, blurRadius: 6)]
                    : null,
                border: Border.all(color: Colors.white.withOpacity(0.02)),
              ),
              child: Row(
                children: [
                  if (selected)
                    const Icon(Icons.check, size: 16, color: Colors.white),
                  if (selected) const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
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

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Report'),
        backgroundColor: const Color(0xFF312E81),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF0F172A),
        child: Column(
          children: [
            const Text(
              'Report submission screen (stub). Replace this with your report form: camera, location, category, description.',
              style: TextStyle(color: Colors.white70),
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