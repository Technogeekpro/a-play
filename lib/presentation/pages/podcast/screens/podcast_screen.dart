import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  // Sample YouTube video IDs for podcasts
  final List<String> _videoIds = [
    'xAt1xcC6qfM',  // First YouTube video ever
    'M8ICGx4p0lA',  // Sample TED Talk
    'LLTStbLZYaI',  // Sample podcast episode
    'RRKJiM9Njr8',  // Sample interview
    'ZWCq52FHGSY',  // Sample podcast episode
  ];

  late List<YoutubePlayerController> _controllers;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _controllers = _videoIds.map((videoId) {
      return YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          useHybridComposition: true,
        ),
      )..addListener(() {
          if (mounted) setState(() {});
        });
    }).toList();
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildYoutubePlayer(YoutubePlayerController controller) {
    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.purple,
      progressColors: const ProgressBarColors(
        playedColor: Colors.purple,
        handleColor: Colors.purpleAccent,
      ),
      onReady: () {
        print('Player is ready.');
      },
      onEnded: (data) {
        controller.pause();
      },
      bottomActions: const [
        CurrentPosition(),
        ProgressBar(
          isExpanded: true,
          colors: ProgressBarColors(
            playedColor: Colors.purple,
            handleColor: Colors.purpleAccent,
          ),
        ),
        RemainingDuration(),
        PlaybackSpeedButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controllers.first,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.purple,
        progressColors: const ProgressBarColors(
          playedColor: Colors.purple,
          handleColor: Colors.purpleAccent,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      // Modern App Bar
                      SliverAppBar(
                        expandedHeight: 200,
                        floating: true,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.purple.shade900,
                                  const Color(0xFF121212),
                                ],
                              ),
                            ),
                          ),
                          title: const Text(
                            'Trending Podcasts',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Iconsax.search_normal),
                            onPressed: () {
                              // TODO: Implement search
                            },
                          ),
                          IconButton(
                            icon: const Icon(Iconsax.filter),
                            onPressed: () {
                              // TODO: Implement filters
                            },
                          ),
                        ],
                      ),

                      // Featured Videos Section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Featured Episodes',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _controllers.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(right: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: _buildYoutubePlayer(_controllers[index]),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Episode ${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Recent Episodes
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Recent Episodes',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Implement view all
                                    },
                                    child: const Text(
                                      'View All',
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Episodes List
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    YoutubePlayer.getThumbnail(
                                      videoId: _videoIds[index % _videoIds.length],
                                    ),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  'Episode ${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Trending podcast episode ${index + 1}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Iconsax.play_circle,
                                    color: Colors.purple,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    _controllers[index % _videoIds.length].play();
                                  },
                                ),
                              ),
                            );
                          },
                          childCount: 10,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
} 