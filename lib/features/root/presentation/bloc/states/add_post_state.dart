abstract class AddPostState {}

class AddPostInitial extends AddPostState {}

class AddPostLoading extends AddPostState {}

class AddPostSuccess extends AddPostState {
  final Map<String, dynamic> post;

  AddPostSuccess({required this.post});
}

class AddPostFailure extends AddPostState {
  final String error;

  AddPostFailure({required this.error});
}
