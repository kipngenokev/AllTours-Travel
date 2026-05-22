import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/attraction_category.dart';
import '../models/place.dart';
import '../services/auth_service.dart';
import '../services/place_service.dart';
import '../theme/app_theme.dart';
import '../utils/season.dart';
import '../widgets/place_card.dart';
import '../widgets/ui.dart';
import 'admin_inbox_screen.dart';
import 'consultancy_screen.dart';
import 'continent_screen.dart';
import 'explore_kenya_screen.dart';
import 'my_requests_screen.dart';
import 'place_detail_screen.dart';
import 'places_list_screen.dart';
import 'search_screen.dart';
import 'season_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = PlaceService();
  late Future<List<Place>> _inSeason;
  final _month = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _inSeason = _service.placesInMonth(_month);
  }

  void _open(Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final firstName = (auth.displayName ?? 'Explorer').split(' ').first;
    final season = SeasonUtil.currentSeason();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => _inSeason = _service.placesInMonth(_month));
            await _inSeason;
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _TopBar(name: firstName),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Where to next,\n$firstName?',
                        style: AppTheme.display(size: 32)),
                    const SizedBox(height: 16),
                    _SearchBar(onTap: () =>
                        _open(SearchScreen(service: _service))),
                    const SizedBox(height: 22),
                    _OptionsRow(
                      onSeason: () => _open(SeasonScreen(service: _service)),
                      onContinent: () =>
                          _open(ContinentScreen(service: _service)),
                      onSearch: () => _open(SearchScreen(service: _service)),
                    ),
                    const SizedBox(height: 22),
                    _ConsultancyBanner(
                      onTap: () => _open(const ConsultancyScreen()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // ---- Explore Kenya by experience ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  eyebrow: 'Africa · Kenya',
                  title: 'Explore by experience',
                  trailing: ArrowLink(
                    label: 'All',
                    onTap: () =>
                        _open(ExploreKenyaScreen(service: _service)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _KenyaCategoryRow(
                onSelect: (cat) => _open(PlacesListScreen(
                  title: cat.label,
                  eyebrow: 'Kenya',
                  future:
                      _service.placesByCategory(cat.id, country: 'Kenya'),
                )),
              ),
              const SizedBox(height: 28),
              // ---- Seasonal hero + "in season now" carousel ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  eyebrow: '${season.emoji} ${SeasonUtil.monthName(_month)} · '
                      '${season.label}',
                  title: 'Best to visit now',
                  trailing: ArrowLink(
                    label: 'View all',
                    onTap: () => _open(PlacesListScreen(
                      title: 'Best to visit now',
                      eyebrow: SeasonUtil.monthName(_month),
                      future: _service.placesInMonth(_month),
                    )),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _SeasonalCarousel(
                future: _inSeason,
                onTap: (p) => _open(PlaceDetailScreen(place: p)),
              ),
              const SizedBox(height: 28),
              // ---- Browse by continent quick row ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  eyebrow: 'Explore',
                  title: 'Browse by continent',
                  trailing: ArrowLink(
                    label: 'All',
                    onTap: () => _open(ContinentScreen(service: _service)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _ContinentChips(
                onSelect: (name) => _open(PlacesListScreen(
                  title: name,
                  eyebrow: 'Continent',
                  future: _service.placesByContinent(name),
                )),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String name;
  const _TopBar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
      child: Row(
        children: [
          const Icon(Icons.travel_explore, color: AppColors.primary, size: 26),
          const SizedBox(width: 8),
          Text('All-Tours', style: AppTheme.display(size: 22)),
          const Spacer(),
          if (context.watch<AuthService>().isAdmin)
            IconButton(
              tooltip: 'Requests inbox',
              icon: const Icon(Icons.inbox_outlined, color: AppColors.primary),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AdminInboxScreen()),
              ),
            ),
          IconButton(
            tooltip: 'My requests',
            icon: const Icon(Icons.assignment_outlined, color: AppColors.muted),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyRequestsScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout, color: AppColors.muted),
            onPressed: () => context.read<AuthService>().signOut(),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.line),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: AppColors.muted),
            SizedBox(width: 10),
            Text('Search a city or country…',
                style: TextStyle(color: AppColors.muted, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _OptionsRow extends StatelessWidget {
  final VoidCallback onSeason;
  final VoidCallback onContinent;
  final VoidCallback onSearch;

  const _OptionsRow({
    required this.onSeason,
    required this.onContinent,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _OptionTile(
          icon: Icons.wb_sunny_outlined,
          label: 'By Season',
          onTap: onSeason,
        ),
        const SizedBox(width: 12),
        _OptionTile(
          icon: Icons.public,
          label: 'By Continent',
          onTap: onContinent,
        ),
        const SizedBox(width: 12),
        _OptionTile(
          icon: Icons.place_outlined,
          label: 'A Place',
          onTap: onSearch,
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 26),
              const SizedBox(height: 10),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeasonalCarousel extends StatelessWidget {
  final Future<List<Place>> future;
  final ValueChanged<Place> onTap;

  const _SeasonalCarousel({required this.future, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 320,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return _InlineMessage(
              'Could not load suggestions.\n${snap.error}');
        }
        final places = snap.data ?? [];
        if (places.isEmpty) {
          return const _InlineMessage(
              'No seasonal picks yet — add places in Supabase.');
        }
        return SizedBox(
          height: 340,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: places.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => SizedBox(
              width: 280,
              child: PlaceCard(
                place: places[i],
                onTap: () => onTap(places[i]),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Horizontal row of Kenya experience-category buttons.
class _KenyaCategoryRow extends StatelessWidget {
  final ValueChanged<AttractionCategory> onSelect;
  const _KenyaCategoryRow({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cats = AttractionCategory.all;
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: cats.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final cat = cats[i];
          return InkWell(
            onTap: () => onSelect(cat),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(cat.icon, color: AppColors.primary, size: 22),
                  ),
                  const Spacer(),
                  Text(cat.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          height: 1.2)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ContinentChips extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const _ContinentChips({required this.onSelect});

  static const _items = [
    'Africa', 'Asia', 'Europe', 'North America',
    'South America', 'Oceania', 'Antarctica',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => ActionChip(
          label: Text(_items[i]),
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          onPressed: () => onSelect(_items[i]),
        ),
      ),
    );
  }
}

/// Editorial banner promoting the trip-planning consultancy service.
class _ConsultancyBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _ConsultancyBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOCAL INTELLIGENCE & SAFETY',
                    style: TextStyle(
                      color: AppColors.accent.withValues(alpha: 0.95),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Plan your trip\nwith a local expert',
                      style: AppTheme.display(size: 24, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text(
                    'Custom itineraries, trusted bookings, honest pricing.',
                    style: TextStyle(color: Color(0xFFD9E4E2), fontSize: 13.5),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('See plans',
                          style: TextStyle(
                            color: AppColors.accent.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 0.2,
                          )),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward,
                          size: 16,
                          color: AppColors.accent.withValues(alpha: 0.95)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.travel_explore,
                color: Color(0x33FFFFFF), size: 64),
          ],
        ),
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  final String text;
  const _InlineMessage(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted)),
    );
  }
}
