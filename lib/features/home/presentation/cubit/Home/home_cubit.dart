import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/images_from_link.dart';
import '../../../../home/domain/usecases/image_from_link_usecase.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetImagesFromLinkUsecase getImagesFromLinkUsecase;
  HomeCubit(this.getImagesFromLinkUsecase) : super(const HomeState.initial());

  TextEditingController searchController = TextEditingController();

  Future<void> getUserFromLink(String link) async {
    try {
      emit(const HomeState.loading());
      final request =
          await getImagesFromLinkUsecase(GetImagesFromLinkParams(link));
      request.fold(
        (error) => emit(
          HomeState.error(error.message),
        ),
        (imagesFromLink) => emit(
          HomeState.loaded(imagesFromLink: imagesFromLink),
        ),
      );
    } on PlatformException catch (e) {
      // emit(
      //   HomeState.error(e.message),
      // );
    }
  }
}
