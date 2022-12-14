import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../features/home/data/models/alerts_model.dart';
import '../../features/home/data/models/images_from_link_model.dart';
import '../../features/home/data/models/save_images_model.dart';
import '../constants/api_path.dart';

part 'api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: ApiPath.baseUrl)
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio) = _ApiClient;

  @GET(ApiPath.imagesFromLink)
  Future<ImagesFromLinkModel> getImagesFromLink(
    @Path('link') String link,
  );

  @GET(ApiPath.recent)
  Future<List<ImagesFromLinkModel>> getRecents(
    @Path('recents') String recents,
  );

  @GET(ApiPath.alertAddress)
  Future<List<AlertsModel>> getAlerts(
    @Path('address') String address,
  );

  @POST(ApiPath.saveImages)
  Future<SaveImagesModel> postSaveImages(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiPath.saveFirebaseToken)
  Future<dynamic> saveFirebaseToken(
    @Body() Map<String, dynamic> body,
  );
}
