part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class InitialSearchState extends SearchState {}

class ErrorSearchState extends SearchState {}

class LoadedSearchState extends SearchState {
  LoadedSearchState(this.newCourses, this.popularSearch);

  final List<CoursesBean?> newCourses;
  final List<String> popularSearch;
}

class ResultsSearchState extends SearchState {
  ResultsSearchState(this.courses);

  final List<CoursesBean> courses;
}
