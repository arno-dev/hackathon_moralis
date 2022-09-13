// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'authentication_cubit_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthenticationState {
  DataStatus get dataStatus => throw _privateConstructorUsedError;
  bool get firstStep => throw _privateConstructorUsedError;
  List<String>? get mnemonic => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthenticationStateCopyWith<AuthenticationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationStateCopyWith(
          AuthenticationState value, $Res Function(AuthenticationState) then) =
      _$AuthenticationStateCopyWithImpl<$Res>;
  $Res call(
      {DataStatus dataStatus,
      bool firstStep,
      List<String>? mnemonic,
      String? error});
}

/// @nodoc
class _$AuthenticationStateCopyWithImpl<$Res>
    implements $AuthenticationStateCopyWith<$Res> {
  _$AuthenticationStateCopyWithImpl(this._value, this._then);

  final AuthenticationState _value;
  // ignore: unused_field
  final $Res Function(AuthenticationState) _then;

  @override
  $Res call({
    Object? dataStatus = freezed,
    Object? firstStep = freezed,
    Object? mnemonic = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      dataStatus: dataStatus == freezed
          ? _value.dataStatus
          : dataStatus // ignore: cast_nullable_to_non_nullable
              as DataStatus,
      firstStep: firstStep == freezed
          ? _value.firstStep
          : firstStep // ignore: cast_nullable_to_non_nullable
              as bool,
      mnemonic: mnemonic == freezed
          ? _value.mnemonic
          : mnemonic // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $AuthenticationStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  $Res call(
      {DataStatus dataStatus,
      bool firstStep,
      List<String>? mnemonic,
      String? error});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$AuthenticationStateCopyWithImpl<$Res>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, (v) => _then(v as _$_Initial));

  @override
  _$_Initial get _value => super._value as _$_Initial;

  @override
  $Res call({
    Object? dataStatus = freezed,
    Object? firstStep = freezed,
    Object? mnemonic = freezed,
    Object? error = freezed,
  }) {
    return _then(_$_Initial(
      dataStatus: dataStatus == freezed
          ? _value.dataStatus
          : dataStatus // ignore: cast_nullable_to_non_nullable
              as DataStatus,
      firstStep: firstStep == freezed
          ? _value.firstStep
          : firstStep // ignore: cast_nullable_to_non_nullable
              as bool,
      mnemonic: mnemonic == freezed
          ? _value._mnemonic
          : mnemonic // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {this.dataStatus = DataStatus.initial,
      this.firstStep = true,
      final List<String>? mnemonic,
      this.error})
      : _mnemonic = mnemonic;

  @override
  @JsonKey()
  final DataStatus dataStatus;
  @override
  @JsonKey()
  final bool firstStep;
  final List<String>? _mnemonic;
  @override
  List<String>? get mnemonic {
    final value = _mnemonic;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'AuthenticationState(dataStatus: $dataStatus, firstStep: $firstStep, mnemonic: $mnemonic, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            const DeepCollectionEquality()
                .equals(other.dataStatus, dataStatus) &&
            const DeepCollectionEquality().equals(other.firstStep, firstStep) &&
            const DeepCollectionEquality().equals(other._mnemonic, _mnemonic) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(dataStatus),
      const DeepCollectionEquality().hash(firstStep),
      const DeepCollectionEquality().hash(_mnemonic),
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);
}

abstract class _Initial implements AuthenticationState {
  const factory _Initial(
      {final DataStatus dataStatus,
      final bool firstStep,
      final List<String>? mnemonic,
      final String? error}) = _$_Initial;

  @override
  DataStatus get dataStatus;
  @override
  bool get firstStep;
  @override
  List<String>? get mnemonic;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
