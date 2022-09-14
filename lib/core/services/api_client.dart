import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../features/home/data/models/images_from_link_model.dart';
import '../../features/home/data/models/params/upload_image_param/upload_image_param.dart';
import '../../features/home/data/models/save_images_model.dart';
import '../../features/todo/data/models/todos_model.dart';
import '../../features/todo/data/models/user_model.dart';
import '../constants/api_path.dart';

part 'api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: ApiPath.baseUrl)
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio) = _ApiClient;

  @GET(ApiPath.todos)
  Future<List<TodosModel>> getTodos();

  @GET(ApiPath.users)
  Future<List<UserModel>> getUsers();

  @GET(ApiPath.imagesFromLink)
  Future<ImagesFromLinkModel> getImagesFromLink(
    @Path('link') String link,
  );

  @GET(ApiPath.recent)
  Future<List<ImagesFromLinkModel>> getRecents(
    @Path('recents') String recents,
  );
  @POST(ApiPath.saveImages)
  Future<SaveImagesModel> postSaveImages(
    @Body() Map<String, dynamic> body,
  );
}
