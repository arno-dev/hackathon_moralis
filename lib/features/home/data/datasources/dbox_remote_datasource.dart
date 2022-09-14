import 'package:d_box/core/services/file_handler.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/image_param.dart';
import 'package:d_box/features/home/data/models/save_images_model.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/util/response_helper.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/images_from_link_model.dart';
import '../models/params/upload_image_param/upload_image_param.dart';

abstract class DboxRemoteDataSource {
  Future<ImagesFromLinkModel> getImageFromLink(String link);
  Future<List<ImagesFromLinkModel>> getRecents(String recents);
  Future<SaveImagesModel> postSaveImages(UploadImageParam uploadImageParam);
  Future<List<ImageParam>> pickImages();
}

@LazySingleton(as: DboxRemoteDataSource)
class DboxRemoteDataSourceImpl extends DboxRemoteDataSource {
  final ApiClient apiClient;
  final FileHandler fileHandler;

  DboxRemoteDataSourceImpl(this.apiClient, this.fileHandler);

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

  @override
  Future<SaveImagesModel> postSaveImages(
      UploadImageParam uploadImageParam) async {
    Map<String, dynamic> body = uploadImageParam.toMap();
    try {
      return await apiClient.postSaveImages(body);
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.somethingWrong.tr());
    }
  }

  @override
  Future<List<ImageParam>> pickImages() async {
    try {
      return await fileHandler.getMultiFiles();
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.somethingWrong.tr());
    }
  }
}
