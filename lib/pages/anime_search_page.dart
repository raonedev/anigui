import 'package:anigui/pages/anime_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/search/cubit/anime_search_cubit.dart';
import '../common/anime_card.dart';
import '../common/ui/animated_grid.dart';

class AnimeSearchPage extends StatefulWidget {
  const AnimeSearchPage({super.key});

  @override
  State<AnimeSearchPage> createState() => _AnimeSearchPageState();
}

class _AnimeSearchPageState extends State<AnimeSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final String searchHistoryKey = "search_history";
  List<String> _searchItems = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistoryList();
  }

  Future<void> _loadSearchHistoryList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchItems = prefs.getStringList(searchHistoryKey) ?? [];
    });
  }

  void _onSearch(BuildContext context) async {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      context.read<AnimeSearchCubit>().searchAnime(name: query);
      await addStringIfNotExists(query);
      _loadSearchHistoryList();
    }
  }

  Future<void> addStringIfNotExists(String newValue) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing list (or empty list if not found)
    List<String> existingList = prefs.getStringList(searchHistoryKey) ?? [];

    // Check if value exists
    if (!existingList.contains(newValue)) {
      existingList.add(newValue);
      await prefs.setStringList(searchHistoryKey, existingList);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: CupertinoSearchTextField(
          controller: _controller,
          focusNode: _focusNode,
          style: const TextStyle(color: Colors.white),
          placeholder: "Search anime...",
          placeholderStyle: TextStyle(color: Colors.grey[500]),
          backgroundColor: Colors.grey[850],
          onSubmitted: (value) => _onSearch(context),
          itemColor: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: BlocBuilder<AnimeSearchCubit, AnimeSearchState>(
          builder: (context, state) {
            if (state is AnimeSearchLoadingState) {
              return const Center(
                child: CupertinoActivityIndicator(color: Colors.white),
              );
            }
            else if (state is AnimeSearchSuccessState) {
              if (state.animes.isEmpty) {
                return const Center(
                  child: Text(
                    "No results found",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return AnimatedCustomGrid(
                itemCount: state.animes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final anime = state.animes[index];
                  return KeyedSubtree(
                    key: ValueKey(index),
                    child: AnimeCardWidget(
                      anime: anime,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnimeDetailPage(animeId: anime.id),
                        ),
                      ),
                    ),
                  );
                },
              );
              // return state.animes.isEmpty
              //     ? Center(
              //         child: Text(
              //           "No results found",
              //           style: TextStyle(color: Colors.white70),
              //         ),
              //       )
              //     : GridView.builder(
              //         itemCount: state.animes.length,
              //         gridDelegate:
              //             const SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: 2,
              //               crossAxisSpacing: 8,
              //               mainAxisSpacing: 8,
              //               childAspectRatio: 0.65,
              //             ),
              //         itemBuilder: (context, index) {
              //           return AnimeCardWidget(
              //             anime: state.animes[index],
              //             onTap: () => Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (_) => AnimeDetailPage(
              //                   animeId: state.animes[index].id,
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //       );
            }
            else if (state is AnimeSearchEmptyState) {
              return const Center(
                child: Text(
                  "No results found",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            else if (state is AnimeSearchErrorState) {
              return Center(
                child: Text(
                  "Error: ${state.errorMessage}",
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }
            else if (state is AnimeSearchInitialState) {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(color: Colors.grey[850],),
                itemCount: _searchItems.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      _controller.text=_searchItems[index];
                      _focusNode.requestFocus();
                    },
                    child: Text(
                      _searchItems[index],
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                "Search for anime...",
                style: TextStyle(color: Colors.white70),
              ),
            );
          },
        ),
      ),
    );
  }
}
