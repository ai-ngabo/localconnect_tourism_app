import 'package:flutter/material.dart';
import '../../models/tour_model.dart';
import '../widgets/tour_card.dart';
import '../widgets/guide_card.dart';
import '../widgets/tour_search_bar.dart';
import '../widgets/filter_dialog.dart';
import '../widgets/section_header.dart';
import 'service_list_page.dart';
import 'service_detail_page.dart';
import 'provider_detail_page.dart';

class TourismHomeScreen extends StatefulWidget {
  final String userName;

  const TourismHomeScreen({super.key, this.userName = 'Sarah'});

  @override
  State<TourismHomeScreen> createState() => _TourismHomeScreenState();
}

class _TourismHomeScreenState extends State<TourismHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<TourModel> get _filteredTours {
    return sampleTours.where((tour) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          tour.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tour.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || tour.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => FilterDialog(
        selectedCategory: _selectedCategory,
        onCategorySelected: (cat) {
          setState(() => _selectedCategory = cat);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                cat == 'All'
                    ? 'Showing all tours'
                    : 'Filtered by: $cat',
              ),
              backgroundColor: const Color(0xFF4A7C59),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hii ${widget.userName}!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'Find Your Next Adventure',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined),
                          color: Colors.black54,
                        ),
                        IconButton(
                          onPressed: _openFilterDialog,
                          icon: const Icon(Icons.tune),
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: TourSearchBar(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
            ),

            // If searching, show filtered results
            if (_searchQuery.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: SectionHeader(title: 'Search Results'),
                ),
              ),

            if (_searchQuery.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: _filteredTours.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.search_off,
                                    size: 48, color: Colors.grey[300]),
                                const SizedBox(height: 12),
                                Text(
                                  'No tours found for "$_searchQuery"',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final tour = _filteredTours[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _TourListItem(
                                tour: tour,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ServiceDetailPage(tour: tour),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: _filteredTours.length,
                        ),
                      ),
              ),

            // Popular Tours section (shown when not searching)
            if (_searchQuery.isEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
                  child: SectionHeader(
                    title: 'Popular Tours',
                    onSeeAll: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ServiceListPage(title: 'Popular Tours'),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 175,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: sampleTours.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (ctx, i) {
                      final tour = sampleTours[i];
                      return TourCard(
                        tour: tour,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceDetailPage(tour: tour),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Local Guides section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
                  child: SectionHeader(
                    title: 'Local Guide',
                    onSeeAll: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ServiceListPage(
                          title: 'Local Guides',
                          showGuides: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 180,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: sampleGuides.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (ctx, i) {
                      final guide = sampleGuides[i];
                      return GuideCard(
                        guide: guide,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProviderDetailPage(guide: guide),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ],
        ),
      ),
    );
  }
}

// Compact list item for search results
class _TourListItem extends StatelessWidget {
  final TourModel tour;
  final VoidCallback onTap;

  const _TourListItem({required this.tour, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'tour_image_${tour.id}',
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(12)),
                child: Image.network(
                  tour.imageUrl,
                  width: 90,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 90,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tour.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    tour.description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7C59).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tour.category,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF4A7C59),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${tour.price.toInt()} ${tour.currency}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF4A7C59),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}