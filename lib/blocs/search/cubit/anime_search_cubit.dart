import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_search_state.dart';

class AnimeSearchCubit extends Cubit<AnimeSearchState> {
  AnimeSearchCubit() : super(AnimeSearchInitial());
}
