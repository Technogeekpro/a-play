import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:a_play_world/core/theme/app_text_styles.dart';
import 'package:a_play_world/data/models/event/event_model.dart';
import 'package:a_play_world/presentation/widgets/home/featured_event_card.dart';

class FeaturedEventsSection extends StatefulWidget {
  final List<EventModel> events;

  const FeaturedEventsSection({
    super.key,
    required this.events,
  });

  @override
  State<FeaturedEventsSection> createState() => _FeaturedEventsSectionState();
}

class _FeaturedEventsSectionState extends State<FeaturedEventsSection> {
  int _currentCarouselIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Carousel
          _buildCarousel(widget.events),
          
          const SizedBox(height: 16),
          
          // Event info below carousel
          if (widget.events.isNotEmpty)
            _buildEventInfo(widget.events[_currentCarouselIndex]),
          
          const SizedBox(height: 12),
          
          // Indicators
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildCustomIndicators(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<EventModel> featuredEvents) {
    return CarouselSlider(
      carouselController: _carouselController,
      options: CarouselOptions(
        height: 350,
        viewportFraction: 0.80,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        enableInfiniteScroll: true,
        autoPlay: true,
        onPageChanged: (index, reason) {
          setState(() {
            _currentCarouselIndex = index;
          });
        },
      ),
      items: featuredEvents.map((event) {
        return Builder(
          builder: (BuildContext context) {
            return FeaturedEventCard(event: event);
          },
        );
      }).toList(),
    );
  }

  Widget _buildEventInfo(EventModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            event.title,
            style: AppTextStyles.bodyLarge(color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${DateFormat('dd MMM').format(event.startDate)}, ${DateFormat('hh:mm a').format(event.startDate)} | ${event.locationName}",
                style: AppTextStyles.bodySmall(color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCustomIndicators() {
    final int totalDots = widget.events.length;
    final List<Widget> dots = [];
    
    // Show only 6 dots at a time
    int startIndex = _currentCarouselIndex - 2;
    int endIndex = _currentCarouselIndex + 3;
    
    // Adjust indices if they're out of bounds
    if (startIndex < 0) {
      endIndex += (startIndex).abs();
      startIndex = 0;
    }
    if (endIndex > totalDots) {
      startIndex -= (endIndex - totalDots);
      endIndex = totalDots;
    }
    
    // Ensure we show exactly 6 dots when possible
    if (totalDots >= 6) {
      if (startIndex < 0) startIndex = 0;
      if (endIndex - startIndex < 6) endIndex = startIndex + 6;
      if (endIndex > totalDots) {
        endIndex = totalDots;
        startIndex = totalDots - 6;
      }
    }

    for (int i = startIndex; i < endIndex; i++) {
      if (i < 0 || i >= totalDots) continue;
      
      // Calculate distance from current index
      int distance = (_currentCarouselIndex - i).abs();
      
      // Calculate dot size based on distance from current index
      double size = distance == 0 ? 10.0 : 
                   distance == 1 ? 8.0 :
                   distance == 2 ? 6.0 : 5.0;
      
      // Calculate opacity based on distance
      double opacity = distance == 0 ? 1.0 :
                      distance == 1 ? 0.7 :
                      distance == 2 ? 0.4 : 0.2;
      
      dots.add(
        GestureDetector(
          onTap: () => _carouselController.jumpToPage(i),
          child: Container(
            width: size,
            height: size,
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(opacity),
            ),
          ),
        ),
      );
    }
    
    return dots;
  }
}
