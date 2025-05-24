part of '../search_bloc.dart';

enum SearchUserStatus { initial, loading, success, failure }

class SearchUserState with EquatableMixin {
  final SearchUserStatus status;
  final List<SearchUserModel>? results;
  final String? errorMessage;

  const SearchUserState({
    this.status = SearchUserStatus.initial,
    this.results,
    this.errorMessage,
  });

  SearchUserState copyWith({
    SearchUserStatus? status,
    List<SearchUserModel>? results,
    String? errorMessage,
  }) {
    return SearchUserState(
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, errorMessage];
}
