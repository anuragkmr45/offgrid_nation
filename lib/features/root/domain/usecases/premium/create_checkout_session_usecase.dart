import 'package:offgrid_nation_app/features/root/domain/repositories/premium_repository.dart';

class CreateCheckoutSessionUseCase {
  final PremiumRepository repository;

  CreateCheckoutSessionUseCase(this.repository);

  Future<String> call() {
    return repository.createCheckoutSession();
  }
}
