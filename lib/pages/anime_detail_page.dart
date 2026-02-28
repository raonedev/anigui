import 'dart:ui';

import '../blocs/anime_detail/cubit/anime_detail_cubit.dart';
import 'video_player_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hugeicons/hugeicons.dart';

import '../blocs/episodes_bloc/dart/anime_episodes_cubit.dart';
import '../models/episodes_model.dart';

class AnimeDetailPage extends StatefulWidget {
  const AnimeDetailPage({super.key, required this.animeId});

  final String? animeId;

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  bool isExpanded = false;
  bool isDub = false;

  @override
  void initState() {
    super.initState();
    if (widget.animeId != null) {
      context.read<AnimeDetailCubit>().getAnimeDetail(animeId: widget.animeId!);
      context.read<AnimeEpisodesCubit>().getAllEpisodes(widget.animeId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: BlocConsumer<AnimeEpisodesCubit, AnimeEpisodesState>(
        listener: (context, episodeState) {
          if (episodeState is AnimeEpisodesLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoPlayerPage(
                  videoUrls: episodeState.videoUrls,
                  episodeNo: episodeState.episodeNo,
                  animeId: episodeState.animeId,
                  isSub: episodeState.isSub,
                ),
              ),
            );
            context.read<AnimeEpisodesCubit>().resetState();
          } else if (episodeState is AnimeEpisodesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(episodeState.message)),
            );
          }
        },
        builder: (context, episodeState) {
          return BlocBuilder<AnimeDetailCubit, AnimeDetailState>(
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
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        state.errorMessage,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
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
                        animeDetail.thumbnail ??
                            DateTime.now().toIso8601String(),
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

                    CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: isExpanded
                              ? MediaQuery.of(context).size.height * 0.8
                              : 400,
                          floating: false,
                          pinned: true,
                          leading: IconButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowLeft02,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          title: Text(
                            "Episodes",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            background: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: kToolbarHeight + 20,
                                  bottom: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            width: 120,
                                            height: 150,
                                            imageUrl:
                                            animeDetail.thumbnail ?? '',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 4,
                                                  horizontal: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      animeDetail.score
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                animeDetail.type ?? 'Unknown',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      animeDetail.name ?? "Unknown",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Description",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        AnimatedSize(
                                          duration:
                                          const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          child: ConstrainedBox(
                                            constraints: isExpanded
                                                ? const BoxConstraints()
                                                : const BoxConstraints(
                                              maxHeight: 80,
                                            ),
                                            child: Html(
                                              data: animeDetail.description ??
                                                  "Unknown",
                                              style: {
                                                "*": Style(
                                                  color: Colors.white,
                                                  fontSize: FontSize(14),
                                                  margin: Margins.zero,
                                                ),
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isExpanded = !isExpanded;
                                            });
                                          },
                                          child: Text(
                                            isExpanded
                                                ? "Show less"
                                                : "Show more",
                                            style: const TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 14,
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
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Row(
                              children: [
                                Text(
                                  "Episodes",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "SUB",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    value: isDub,
                                    onChanged: (value) {
                                      setState(() {
                                        isDub = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "DUB",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverList.builder(
                          itemCount: isDub
                              ? animeDetail
                              .availableEpisodesDetail?.dub?.length ??
                              0
                              : animeDetail
                              .availableEpisodesDetail?.sub?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final String? ep;
                            if (isDub) {
                              ep = animeDetail
                                  .availableEpisodesDetail?.dub?[index];
                            } else {
                              ep = animeDetail
                                  .availableEpisodesDetail?.sub?[index];
                            }

                            return FutureBuilder<EpisodeModel?>(
                              future: context.read<AnimeEpisodesCubit>().getEpisodeFromDatabase(
                                animeId: animeDetail.id ?? '',
                                episodeNumber:int.tryParse(ep ?? '0') ?? 0,
                                isSub: !isDub,
                              ),
                              builder: (context, snapshot) {
                                final watchedTime =  snapshot.data?.watchedTime ?? 0;
                                final isComplete = snapshot.data?.isCompletelyWatched == 1;

                                Color leadingColor = Colors.black;
                                if (isComplete) {
                                  leadingColor = Colors.green;
                                } else if (watchedTime > 0) {
                                  leadingColor = Colors.orange;
                                }

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "Episode ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          color: leadingColor,
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            ep.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      trailing: HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedPlayCircle02,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        context
                                            .read<AnimeEpisodesCubit>()
                                            .fetchEpisodeSources(
                                          showId: animeDetail.id ?? '',
                                          episode: ep ?? "",
                                          isDub: isDub,
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 0.2,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    BlocBuilder<AnimeEpisodesCubit, AnimeEpisodesState>(
                      builder: (context, episodeState) {
                        if (episodeState is AnimeEpisodesLoading) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                color: Colors.white,
                                radius: 30,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
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
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        state.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}