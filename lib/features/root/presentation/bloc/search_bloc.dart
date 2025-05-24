import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:offgrid_nation_app/core/errors/error_handler.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/search/search_users_usecase.dart';
import '../../domain/entities/search_user_model.dart';

part 'events/search_event.dart';
part 'states/search_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final FetchSearchUsersUsecase fetchSearchUsersUsecase;

  SearchUserBloc({required this.fetchSearchUsersUsecase})
    : super(const SearchUserState()) {
    on<FetchSearchUserRequested>(_onFetchSearchUser);
  }

  Future<void> _onFetchSearchUser(
    FetchSearchUserRequested event,
    Emitter<SearchUserState> emit,
  ) async {
    emit(state.copyWith(status: SearchUserStatus.loading));
    try {
      final results = await fetchSearchUsersUsecase(event.query);
      emit(state.copyWith(status: SearchUserStatus.success, results: results));
    } catch (err) {
      emit(
        state.copyWith(
          status: SearchUserStatus.failure,
          errorMessage: ErrorHandler.handle(err),
        ),
      );
    }
  }
}
