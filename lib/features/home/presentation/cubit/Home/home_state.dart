part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(DataStatus.initial) DataStatus dataStatus,
    List<ImagesFromLink>? recents,
    ImagesFromLink? imagesFromLink,
    List<Images>? currentFolder,
    List<Images>? prevFolder,
  }) = _Loaded;
}
