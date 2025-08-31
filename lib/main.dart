import 'package:anigui/pages/home.dart';

import 'blocs/home_cubits/movies/cubit/anime_movie_cubit.dart';
import 'blocs/home_cubits/ona/cubit/anime_ona_cubit.dart';
import 'blocs/home_cubits/ova/cubit/anime_ova_cubit.dart';
import 'blocs/home_cubits/special/cubit/anime_special_cubit.dart';
import 'blocs/home_cubits/tv_shows/cubit/anime_tv_cubit.dart';
import 'package:anigui/services/home_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final ApiService apiService = ApiService();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AnimeTvCubit(apiService)..loadTvAnimes()),
        BlocProvider(create: (context) => AnimeOvaCubit(apiService)..loadOvaAnime()),
        BlocProvider(create: (context) => AnimeMovieCubit(apiService)..loadMovieAnime()),
        BlocProvider(create: (context) => AnimeSpecialCubit(apiService)..loadSpecialAnimes()),
        BlocProvider(create: (context) => AnimeOnaCubit(apiService)..loadOnaAnime()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomePage(),
      ),
    );
  }
}
