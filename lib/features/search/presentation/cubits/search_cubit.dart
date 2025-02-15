import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/search/domain/search_repository.dart';
import 'package:flutter_social_media/features/search/presentation/cubits/search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  final SearchRepository searchRepository;

  SearchCubit({
    required this.searchRepository,
  }) : super(SearchInital());

  Future<void> searchUsers(String query) async {
    if(query.isEmpty){
      emit(SearchInital());
      return;
    }
    try {
      emit(SearchLoading());
      final users = await searchRepository.searchUsers(query);
      emit(SearchLoaded(users));
    } catch (e) {
      emit(SearchError("Error fetching search results: $e"));
    }
  }
}
