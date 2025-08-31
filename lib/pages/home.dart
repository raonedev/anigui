import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';

import '../blocs/home_cubits/movies/cubit/anime_movie_cubit.dart';
import '../blocs/home_cubits/ona/cubit/anime_ona_cubit.dart';
import '../blocs/home_cubits/ova/cubit/anime_ova_cubit.dart';
import '../blocs/home_cubits/special/cubit/anime_special_cubit.dart';
import '../blocs/home_cubits/tv_shows/cubit/anime_tv_cubit.dart';
import '../common/anime_card.dart';
import '../models/anime_home_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Set your desired color here
        statusBarIconBrightness:
            Brightness.light, // For icons/text on the status bar
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight - 8),
                _buildSectionTitle(context, 'Special Anime'),
                _buildAnimeList<AnimeSpecialCubit, AnimeSpecialState>(
                  context,
                  stateSelector: (state) =>
                      state is AnimeSpecialSuccessState ? state.animes : [],
                ),
                _buildSectionTitle(context, 'TV Anime'),
                _buildAnimeList<AnimeTvCubit, AnimeTvState>(
                  context,
                  stateSelector: (state) =>
                      state is AnimeTvSuccessState ? state.animes : [],
                ),
                _buildSectionTitle(context, 'Movie Anime'),
                _buildAnimeList<AnimeMovieCubit, AnimeMovieState>(
                  context,
                  stateSelector: (state) =>
                      state is AnimeMovieSuccessState ? state.animes : [],
                ),
                _buildSectionTitle(context, 'OVA Anime'),
                _buildAnimeList<AnimeOvaCubit, AnimeOvaState>(
                  context,
                  stateSelector: (state) =>
                      state is AnimeOvaSuccessState ? state.animes : [],
                ),
                _buildSectionTitle(context, 'ONA Anime'),
                _buildAnimeList<AnimeOnaCubit, AnimeOnaState>(
                  context,
                  stateSelector: (state) =>
                      state is AnimeOnaSuccessState ? state.animes : [],
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadiusGeometry.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedHome04,
                                color: Colors.white,
                              ),
                              Text(
                                "Home",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(),
                          Column(
                            children: [
                               HugeIcon(
                              icon: HugeIcons.strokeRoundedSearch01,
                              color: Colors.white,
                            ),
                            Text(
                              "Search",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }

  Widget _buildAnimeList<T extends Cubit<S>, S>(
    BuildContext context, {
    required List<AnimeHomeCard> Function(S) stateSelector,
  }) {
    return ClipRRect(
      child: SizedBox(
        height: 250,
        child: BlocBuilder<T, S>(
          builder: (context, state) {
            if (state is AnimeTvLoadingState ||
                state is AnimeOvaLoadingState ||
                state is AnimeMovieLoadingState ||
                state is AnimeSpecialLoadingState ||
                state is AnimeOnaLoadingState) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5, // Number of shimmer placeholders
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[900]!,
                    highlightColor: Colors.grey[700]!,
                    child: Container(
                      width: 150, // Match the width of AnimeCardWidget
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Placeholder for the image area
                          Container(
                            height:
                                180, // Approximate height of AnimeCardWidget image
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                          ),
                          // Placeholder for text area
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 16,
                                  width: 100,
                                  color: Colors.grey[800],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 14,
                                  width: 60,
                                  color: Colors.grey[800],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
      
            final animes = stateSelector(state);
      
            if (animes.isEmpty) {
              return const Center(child: Text('No anime available'));
            }
      
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: animes.length,
              itemBuilder: (context, index) {
                final anime = animes[index];
                return AnimeCardWidget(anime: anime);
              },
            );
          },
        ),
      ),
    );
  }
}
