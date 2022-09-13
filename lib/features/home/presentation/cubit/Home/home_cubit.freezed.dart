// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeState {
  DataStatus get dataStatus => throw _privateConstructorUsedError;
  List<ImagesFromLink>? get recents => throw _privateConstructorUsedError;
  ImagesFromLink? get imagesFromLink => throw _privateConstructorUsedError;
  List<Images>? get currentFolder => throw _privateConstructorUsedError;
  List<Images>? get prevFolder => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res>;
  $Res call(
      {DataStatus dataStatus,
      List<ImagesFromLink>? recents,
      ImagesFromLink? imagesFromLink,
      List<Images>? currentFolder,
      List<Images>? prevFolder});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res> implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  final HomeState _value;
  // ignore: unused_field
  final $Res Function(HomeState) _then;

  @override
  $Res call({
    Object? dataStatus = freezed,
    Object? recents = freezed,
    Object? imagesFromLink = freezed,
    Object? currentFolder = freezed,
    Object? prevFolder = freezed,
  }) {
    return _then(_value.copyWith(
      dataStatus: dataStatus == freezed
          ? _value.dataStatus
          : dataStatus // ignore: cast_nullable_to_non_nullable
              as DataStatus,
      recents: recents == freezed
          ? _value.recents
          : recents // ignore: cast_nullable_to_non_nullable
              as List<ImagesFromLink>?,
      imagesFromLink: imagesFromLink == freezed
          ? _value.imagesFromLink
          : imagesFromLink // ignore: cast_nullable_to_non_nullable
              as ImagesFromLink?,
      currentFolder: currentFolder == freezed
          ? _value.currentFolder
          : currentFolder // ignore: cast_nullable_to_non_nullable
              as List<Images>?,
      prevFolder: prevFolder == freezed
          ? _value.prevFolder
          : prevFolder // ignore: cast_nullable_to_non_nullable
              as List<Images>?,
    ));
  }
}

/// @nodoc
abstract class _$$_LoadedCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$$_LoadedCopyWith(_$_Loaded value, $Res Function(_$_Loaded) then) =
      __$$_LoadedCopyWithImpl<$Res>;
  @override
  $Res call(
      {DataStatus dataStatus,
      List<ImagesFromLink>? recents,
      ImagesFromLink? imagesFromLink,
      List<Images>? currentFolder,
      List<Images>? prevFolder});
}

/// @nodoc
class __$$_LoadedCopyWithImpl<$Res> extends _$HomeStateCopyWithImpl<$Res>
    implements _$$_LoadedCopyWith<$Res> {
  __$$_LoadedCopyWithImpl(_$_Loaded _value, $Res Function(_$_Loaded) _then)
      : super(_value, (v) => _then(v as _$_Loaded));

  @override
  _$_Loaded get _value => super._value as _$_Loaded;

  @override
  $Res call({
    Object? dataStatus = freezed,
    Object? recents = freezed,
    Object? imagesFromLink = freezed,
    Object? currentFolder = freezed,
    Object? prevFolder = freezed,
  }) {
    return _then(_$_Loaded(
      dataStatus: dataStatus == freezed
          ? _value.dataStatus
          : dataStatus // ignore: cast_nullable_to_non_nullable
              as DataStatus,
      recents: recents == freezed
          ? _value._recents
          : recents // ignore: cast_nullable_to_non_nullable
              as List<ImagesFromLink>?,
      imagesFromLink: imagesFromLink == freezed
          ? _value.imagesFromLink
          : imagesFromLink // ignore: cast_nullable_to_non_nullable
              as ImagesFromLink?,
      currentFolder: currentFolder == freezed
          ? _value._currentFolder
          : currentFolder // ignore: cast_nullable_to_non_nullable
              as List<Images>?,
      prevFolder: prevFolder == freezed
          ? _value._prevFolder
          : prevFolder // ignore: cast_nullable_to_non_nullable
              as List<Images>?,
    ));
  }
}

/// @nodoc

class _$_Loaded implements _Loaded {
  const _$_Loaded(
      {this.dataStatus = DataStatus.initial,
      final List<ImagesFromLink>? recents,
      this.imagesFromLink,
      final List<Images>? currentFolder,
      final List<Images>? prevFolder})
      : _recents = recents,
        _currentFolder = currentFolder,
        _prevFolder = prevFolder;

  @override
  @JsonKey()
  final DataStatus dataStatus;
  final List<ImagesFromLink>? _recents;
  @override
  List<ImagesFromLink>? get recents {
    final value = _recents;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final ImagesFromLink? imagesFromLink;
  final List<Images>? _currentFolder;
  @override
  List<Images>? get currentFolder {
    final value = _currentFolder;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Images>? _prevFolder;
  @override
  List<Images>? get prevFolder {
    final value = _prevFolder;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HomeState(dataStatus: $dataStatus, recents: $recents, imagesFromLink: $imagesFromLink, currentFolder: $currentFolder, prevFolder: $prevFolder)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Loaded &&
            const DeepCollectionEquality()
                .equals(other.dataStatus, dataStatus) &&
            const DeepCollectionEquality().equals(other._recents, _recents) &&
            const DeepCollectionEquality()
                .equals(other.imagesFromLink, imagesFromLink) &&
            const DeepCollectionEquality()
                .equals(other._currentFolder, _currentFolder) &&
            const DeepCollectionEquality()
                .equals(other._prevFolder, _prevFolder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(dataStatus),
      const DeepCollectionEquality().hash(_recents),
      const DeepCollectionEquality().hash(imagesFromLink),
      const DeepCollectionEquality().hash(_currentFolder),
      const DeepCollectionEquality().hash(_prevFolder));

  @JsonKey(ignore: true)
  @override
  _$$_LoadedCopyWith<_$_Loaded> get copyWith =>
      __$$_LoadedCopyWithImpl<_$_Loaded>(this, _$identity);
}

abstract class _Loaded implements HomeState {
  const factory _Loaded(
      {final DataStatus dataStatus,
      final List<ImagesFromLink>? recents,
      final ImagesFromLink? imagesFromLink,
      final List<Images>? currentFolder,
      final List<Images>? prevFolder}) = _$_Loaded;

  @override
  DataStatus get dataStatus;
  @override
  List<ImagesFromLink>? get recents;
  @override
  ImagesFromLink? get imagesFromLink;
  @override
  List<Images>? get currentFolder;
  @override
  List<Images>? get prevFolder;
  @override
  @JsonKey(ignore: true)
  _$$_LoadedCopyWith<_$_Loaded> get copyWith =>
      throw _privateConstructorUsedError;
}
