import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';

class UploadMediaUsecase {
  final ChatRepository repository;
  UploadMediaUsecase(this.repository);

  Future<String> call(String endpoint, String filePath) async {
    return await repository.uploadMedia(endpoint, filePath); // already returns a String
  }
}
