import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/posts/add_post_usecase.dart';
import './events/add_post_event.dart';
import './states/add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final AddPostUseCase addPostUseCase;

  AddPostBloc({required this.addPostUseCase}) : super(AddPostInitial()) {
    on<SubmitPostEvent>((event, emit) async {
      emit(AddPostLoading());
      try {
        final post = await addPostUseCase(
          content: event.content,
          location: event.location,
          mediaFiles: event.mediaFiles,
        );
        emit(AddPostSuccess(post: post));
      } catch (e) {
        emit(AddPostFailure(error: e.toString()));
      }
    });
  }
}
