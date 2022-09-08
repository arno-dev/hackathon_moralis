part of 'todo_cubit.dart';

@freezed
class TodoState with _$TodoState {
  const factory TodoState.start() = _Start;
  const factory TodoState.loading() = _Loading;
  const factory TodoState.loaded({
    @Default([]) List<Todos> todos,
    @Default([]) List<User> users,
  }) = _Loaded;
  const factory TodoState.error(String message) = _Error;
}
