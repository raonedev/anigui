import 'dart:developer' as dev;
import 'dart:ui';

import 'package:anigui/blocs/anime_detail/cubit/anime_detail_cubit.dart';
import 'package:anigui/pages/video_player_page.dart';
import 'package:anigui/services/http_api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class AnimeDetailPage extends StatefulWidget {
  const AnimeDetailPage({super.key, required this.animeId});
  final String? animeId;

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.animeId != null) {
      context.read<AnimeDetailCubit>().getAnimeDetail(animeId: widget.animeId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: BlocBuilder<AnimeDetailCubit, AnimeDetailState>(
        builder: (context, state) {
          if (state is AnimeDetailLoadingState) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.grey),
            );
          } else if (state is AnimeDetailErrorState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Something Went Wrong",
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.white),
                  ),
                  Text(
                    state.errorMessage,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          } else if (state is AnimeDetailSuccessState) {
            final animeDetail = state.animeDetail;
            return Stack(
              children: [
                Container(
                  key: ValueKey<String>(
                    animeDetail.thumbnail ?? DateTime.now().toIso8601String(),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        animeDetail.thumbnail ?? '',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ),

                // Use the SingleChildScrollView directly within the Stack
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              width: 200,
                              height: 250,
                              imageUrl: animeDetail.thumbnail ?? '',
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ///Rating
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    HugeIcon(
                                      icon: HugeIcons.strokeRoundedStarCircle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      animeDetail.score.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),

                              /// type of anime
                              Text(
                                animeDetail.type ?? 'Unknown',
                                textAlign: TextAlign.justify,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Removed Flexible as it's not needed here
                      Text(
                        animeDetail.name ?? "Unknown",
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        animeDetail.description ?? "Unknown",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                /// just for [Testing]
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CupertinoButton.filled(
                    color: Colors.amberAccent,
                    onPressed: () async {
                      final apiservice = ApiService();
                      final res = await apiservice.fetchEpisodeSources(
                        showId: animeDetail.id ?? '',
                        episode: "1",
                        translationType: "sub",
                      );
                      // Extract all URLs from the response
                      List<String> videoUrls = res
                          .map<String>((e) => e['url']?.toString() ?? '')
                          .toList();

                      // Remove any empty URLs
                      videoUrls = videoUrls
                          .where((url) => url.isNotEmpty)
                          .toList();

                      if (videoUrls.isNotEmpty) {
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VideoPlayerPage(videoUrls: videoUrls),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      animeDetail.id ?? "Get Link",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Something Went Wrong",
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.white),
                  ),
                  Text(
                    state.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
