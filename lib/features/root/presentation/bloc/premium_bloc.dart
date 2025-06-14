import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/premium/create_checkout_session_usecase.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/premium_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final CreateCheckoutSessionUseCase createCheckoutSessionUseCase;

  PremiumBloc({required this.createCheckoutSessionUseCase})
    : super(PremiumInitial()) {
    on<CreateCheckoutSessionRequested>(_onCreateCheckoutSessionRequested);
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
}
