import 'dart:io';

import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';

class UpdateProfilePhotoUsecase {
  final UserProfileRepository repository;

  UpdateProfilePhotoUsecase(this.repository);

  Future<String> call(File file) async {
    return await repository.updateProfilePhoto(file);
  }
}
