import 'package:d_box/features/home/domain/entities/images_from_link.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/util/response_helper.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/images_from_link_model.dart';

abstract class DboxRemoteDataSource {
  Future<ImagesFromLinkModel> getImageFromLink(String link);
  Future<List<ImagesFromLinkModel>> getRecents(String recents);
}

@LazySingleton(as: DboxRemoteDataSource)
class DboxRemoteDataSourceImpl extends DboxRemoteDataSource {
  final ApiClient apiClient;

  DboxRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ImagesFromLinkModel> getImageFromLink(String link) async {
    try {
      return await apiClient.getImagesFromLink(link);
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.somethingWrong.tr());
    }
  }

  @override
  Future<List<ImagesFromLinkModel>> getRecents(String recents) async {
    try {
      return await apiClient.getRecents(recents);
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.somethingWrong.tr());
    }
  }
}
