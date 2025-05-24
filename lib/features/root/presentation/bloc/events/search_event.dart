part of '../search_bloc.dart';

@immutable
sealed class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object?> get props => [];
}

class FetchSearchUserRequested extends SearchUserEvent {
  final String query;
  const FetchSearchUserRequested(this.query);

  @override
  List<Object?> get props => [query];
}
