import 'package:anigui/models/anime_home_card.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_tv_state.dart';

class AnimeTvCubit extends Cubit<AnimeTvState> {
  AnimeTvCubit() : super(AnimeTvInitialState());

  Future<void> loadTvAnimes()async{
    
  }
}
