import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a_play/data/models/event/event_model.dart';
import 'package:a_play/presentation/pages/home/controller/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class FeedsPage extends ConsumerStatefulWidget {
  const FeedsPage({super.key});

  @override
  ConsumerState<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends ConsumerState<FeedsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        title: const Text(
          'My Feed',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          
          // Overlay to ensure content visibility
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: eventsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading feed',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(eventsProvider),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                  data: (events) {
                    if (events.isEmpty) {
                      return const Center(child: Text('No events found'));
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return FeedEventCard(event: event);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedEventCard extends StatefulWidget {
  final EventModel event;

  const FeedEventCard({
    super.key,
    required this.event,
  });

  @override
  State<FeedEventCard> createState() => _FeedEventCardState();
}

class _FeedEventCardState extends State<FeedEventCard> {
  bool isLiked = false;
  bool isCommentsVisible = false;
  TextEditingController commentController = TextEditingController();
  final List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    // Add some sample comments
    comments.add(Comment(
      username: 'john_doe',
      text: 'This event looks amazing! Can\'t wait to attend.',
      timeAgo: '2h ago',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
    ));
    comments.add(Comment(
      username: 'sarah_smith',
      text: 'Has anyone been to this before? How is it?',
      timeAgo: '1h ago',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
    ));
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${widget.event.id.hashCode % 70}'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Event Organizer',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.event.location,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              
              // Event Image
              GestureDetector(
                onTap: () => context.pushNamed(
                  'event-detail',
                  pathParameters: {'id': widget.event.id},
                  extra: widget.event,
                ),
                child: Hero(
                  tag: 'feed-event-image-${widget.event.id}',
                  child: SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: widget.event.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.event.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[600]!,
                              child: Container(color: Colors.black),
                            ),
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error, color: Colors.white)),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: const Center(child: Icon(Icons.event, size: 48, color: Colors.white)),
                          ),
                  ),
                ),
              ),
              
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _buildActionButton(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                      onTap: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildActionButton(
                      icon: Icons.chat_bubble_outline,
                      onTap: () {
                        setState(() {
                          isCommentsVisible = !isCommentsVisible;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildActionButton(
                      icon: Icons.share_outlined,
                      onTap: () {
                        // Handle share
                      },
                    ),
                    const Spacer(),
                    _buildActionButton(
                      icon: Icons.bookmark_border,
                      onTap: () {
                        // Handle bookmark
                      },
                    ),
                  ],
                ),
              ),
              
              // Like count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${isLiked ? 146 : 145} likes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Event title and description
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Join us for an amazing event! Tickets start at GH₵ ${widget.event.price.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Date of post
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  widget.event.formattedDate,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ),
              
              // Comments section
              if (isCommentsVisible) ...[
                const Divider(color: Colors.white24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(comment.avatarUrl),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.username,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      comment.timeAgo,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border, size: 16),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                // Add comment field
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (commentController.text.isNotEmpty) {
                            setState(() {
                              comments.add(Comment(
                                username: 'you',
                                text: commentController.text,
                                timeAgo: 'just now',
                                avatarUrl: 'https://i.pravatar.cc/150?img=8',
                              ));
                              commentController.clear();
                            });
                          }
                        },
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}

class Comment {
  final String username;
  final String text;
  final String timeAgo;
  final String avatarUrl;

  Comment({
    required this.username,
    required this.text,
    required this.timeAgo,
    required this.avatarUrl,
  });
} 