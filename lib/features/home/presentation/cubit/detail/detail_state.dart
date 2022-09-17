part of 'detail_cubit.dart';

@freezed
class DetailState with _$DetailState {
  const factory DetailState({
    @Default(DataStatus.initial) DataStatus dataStatus,
    ImagesFromLink? imagesFromLink,
    List<Images>? currentFolder,
    List<ImagesFromLink>? recents,
    @Default([]) List<int> stack,
    @Default([]) List<String> stackName,
    String? errorMessage
  }) = _Loaded;
}
