import 'package:flutter/material.dart';
import '../../models/tour_model.dart';
import '../widgets/filter_dialog.dart';
import 'service_detail_page.dart';
import 'provider_detail_page.dart';

class ServiceListPage extends StatefulWidget {
  final String title;
  final bool showGuides;

  const ServiceListPage({
    super.key,
    required this.title,
    this.showGuides = false,
  });

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  String _selectedCategory = 'All';

  List<TourModel> get _filteredTours {
    if (_selectedCategory == 'All') return sampleTours;
    return sampleTours.where((t) => t.category == _selectedCategory).toList();
  }

  void _openFilter() {
    showDialog(
      context: context,
      builder: (_) => FilterDialog(
        selectedCategory: _selectedCategory,
        onCategorySelected: (cat) {
          setState(() => _selectedCategory = cat);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  cat == 'All' ? 'Showing all tours' : 'Filtered by: $cat'),
              backgroundColor: const Color(0xFF4A7C59),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          if (!widget.showGuides)
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.black54),
              onPressed: _openFilter,
            ),
        ],
      ),
      body: widget.showGuides ? _buildGuidesList() : _buildToursList(),
    );
  }

  Widget _buildToursList() {
    final tours = _filteredTours;
    if (tours.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text('No tours in this category',
                style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tours.length,
      itemBuilder: (ctx, i) {
        final tour = tours[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ServiceDetailPage(tour: tour)),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'tour_image_${tour.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14)),
                      child: Image.network(
                        tour.imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 160,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image,
                              color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tour.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 2),
                                Text(tour.rating.toString(),
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tour.description,
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.schedule,
                                size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              '${tour.durationHours} Hours',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12),
                            ),
                            const Spacer(),
                            Text(
                              '${tour.price.toInt()} ${tour.currency}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF4A7C59),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuidesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sampleGuides.length,
      itemBuilder: (ctx, i) {
        final guide = sampleGuides[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProviderDetailPage(guide: guide)),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Hero(
                  tag: 'guide_image_${guide.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      guide.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                title: Text(guide.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(guide.specialty,
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(guide.rating.toString(),
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right,
                    color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}