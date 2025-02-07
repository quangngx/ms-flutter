import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(InitialSearchState()) {
    on<FetchEvent>((event, emit) async {
      emit(InitialSearchState());
      try {
        final _newCourses = (await _coursesRepository.getCourses()).courses.cast<CoursesBean>();

        final _popularSearches = (await _coursesRepository.getPopularSearches()).searches;

        emit(LoadedSearchState(_newCourses, _popularSearches));
      } catch (e, s) {
        logger.e('Error getPopularSearches / getCourses', e, s);
        emit(ErrorSearchState());
      }
    });
  }

  final CoursesRepository _coursesRepository = CoursesRepositoryImpl();
}
