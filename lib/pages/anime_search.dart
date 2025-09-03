import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/search/cubit/anime_search_cubit.dart';
import '../common/anime_card.dart';

class AnimeSearchPage extends StatefulWidget {
  const AnimeSearchPage({super.key});

  @override
  State<AnimeSearchPage> createState() => _AnimeSearchPageState();
}

class _AnimeSearchPageState extends State<AnimeSearchPage> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch(BuildContext context) {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      context.read<AnimeSearchCubit>().searchAnime(name: query);
    }
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
          style: const TextStyle(color: Colors.white),
          placeholder: "Search anime...",
          placeholderStyle: TextStyle(color: Colors.grey[500]),
          backgroundColor:  Colors.grey[850],
          onSubmitted: (value) => _onSearch(context),
          itemColor: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 20),
        child: BlocBuilder<AnimeSearchCubit, AnimeSearchState>(
          builder: (context, state) {
            if (state is AnimeSearchLoadingState) {
              return const Center(
                child: CupertinoActivityIndicator(color: Colors.white),
              );
            } else if (state is AnimeSearchSuccessState) {
              return GridView.builder(
                itemCount: state.animes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  return AnimeCardWidget(anime: state.animes[index],);
                },
              );
            } else if (state is AnimeSearchEmptyState) {
              return const Center(
                child: Text(
                  "No results found",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            } else if (state is AnimeSearchErrorState) {
              return Center(
                child: Text(
                  "Error: ${state.errorMessage}",
                  style: const TextStyle(color: Colors.redAccent),
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
