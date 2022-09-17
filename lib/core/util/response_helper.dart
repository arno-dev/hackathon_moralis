import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../generated/locale_keys.g.dart';
import '../error/exceptions.dart';

class ResponseHelper {
  static Exception returnResponse(DioError dioError) {
    try {
      if (dioError.error.runtimeType == SocketException &&
          dioError.type == DioErrorType.other) {
        return ServerException(dioError.message);
      } else {
        return ServerException(
          dioError.message,
        );
      }
    } catch (e) {
      return ServerException(LocaleKeys.errorMessages_somethingWrong.tr());
    }
  }
}
