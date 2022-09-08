import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/util/response_helper.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/todos_model.dart';
import '../models/user_model.dart';

abstract class TodosRemoteDatasource {
  Future<List<TodosModel>> getTodos();
  Future<List<UserModel>> getUsers();
}

@LazySingleton(as: TodosRemoteDatasource)
class TodosRemoteDatasourceImpl extends TodosRemoteDatasource {
  final ApiClient apiClient;
  TodosRemoteDatasourceImpl(this.apiClient);

  //send the resposne from Remote database or some third party, if error throw our exception here or you can throw on services.
  @override
  Future<List<TodosModel>> getTodos() async {
    try {
      return await apiClient.getTodos();
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.somethingWrong.tr());
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      return await apiClient.getUsers();
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.somethingWrong.tr());
    }
  }
}
