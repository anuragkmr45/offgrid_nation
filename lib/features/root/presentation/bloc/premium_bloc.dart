import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/premium/create_checkout_session_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/premium/fetch_premium_feed_usecase.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/premium_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final CreateCheckoutSessionUseCase createCheckoutSessionUseCase;
  final FetchPremiumFeedUseCase fetchPremiumFeedUseCase;

  PremiumBloc({
    required this.createCheckoutSessionUseCase,
    required this.fetchPremiumFeedUseCase,
  }) : super(PremiumInitial()) {
    on<CreateCheckoutSessionRequested>(_onCreateCheckoutSessionRequested);
    on<FetchPremiumFeedRequested>(_onFetchPremiumFeedRequested);
  }

  Future<void> _onCreateCheckoutSessionRequested(
    CreateCheckoutSessionRequested event,
    Emitter<PremiumState> emit,
  ) async {
    emit(CreateCheckoutSessionLoading());
    try {
      final url = await createCheckoutSessionUseCase();
      emit(CreateCheckoutSessionSuccess(url));
    } on NetworkException catch (e) {
      emit(CreateCheckoutSessionFailure(e.message ?? 'Something went wrong'));
    } catch (e) {
      emit(CreateCheckoutSessionFailure(e.toString()));
    }
  }

  Future<void> _onFetchPremiumFeedRequested(
    FetchPremiumFeedRequested event,
    Emitter<PremiumState> emit,
  ) async {
    emit(PremiumFeedLoading());
    try {
      final posts = await fetchPremiumFeedUseCase();
      emit(PremiumFeedLoaded(posts));
    } on NetworkException catch (e) {
      if (e.message == 'USER_NOT_PREMIUM') {
        emit(PremiumUserNotSubscribed());
      } else {
        emit(PremiumFeedFailure(e.message ?? 'Something went wrong'));
      }
    } catch (e) {
      emit(PremiumFeedFailure(e.toString()));
    }
  }
}
