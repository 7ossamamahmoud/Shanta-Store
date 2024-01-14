part of 'search_cubit.dart';

@immutable
abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class SearchLoadingState extends SearchStates {}

class SearchSuccessfulState extends SearchStates {}

class SearchErrorState extends SearchStates {
  final String error;

  SearchErrorState({required this.error});
}
