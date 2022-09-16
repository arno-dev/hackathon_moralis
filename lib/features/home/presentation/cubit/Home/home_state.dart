part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(DataStatus.initial) DataStatus dataStatus,
    List<ImagesFromLink>? recents,
    ImagesFromLink? imagesFromLink,
    List<Images>? currentFolder,
    List<Images>? prevFolder,
    @Default([]) List<ImageParam>? listImages,
    @Default(false) bool isHasImage,
    String? addPeople,
    String? urlPath,
    @Default("") String addFolder,
    @Default([]) List<int> stack,
    @Default([]) List<String> nameStack,
    @Default(false) bool isHasQrAddress,
  }) = _Loaded;
}
