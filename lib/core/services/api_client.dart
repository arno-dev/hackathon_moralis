import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../features/home/data/models/images_from_link_model.dart';
import '../../features/todo/data/models/todos_model.dart';
import '../../features/todo/data/models/user_model.dart';
import '../constants/api_path.dart';

part 'api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: ApiPaht.baseUrl)
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio) = _ApiClient;

  @GET(ApiPaht.todos)
  Future<List<TodosModel>> getTodos();

  @GET(ApiPaht.users)
  Future<List<UserModel>> getUsers();

  @GET(ApiPaht.imagesFromLink)
  Future<ImagesFromLinkModel> getImagesFromLink(
    @Path('link') String link,
  );

  @GET(ApiPaht.imagesFromLink)
  Future<List<ImagesFromLinkModel>> getRecents(
    @Path('recnets') String link,
  );
}
