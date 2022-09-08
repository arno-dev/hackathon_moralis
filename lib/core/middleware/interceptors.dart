import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Named("appInterceptors")
@lazySingleton
class AppInterceptors extends Interceptor {
  AppInterceptors();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
