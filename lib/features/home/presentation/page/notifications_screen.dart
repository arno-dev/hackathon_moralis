import 'package:d_box/core/config/themes/app_text_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/config/routes/router.dart';
import '../../../../core/constants/data_status.dart';
import '../../../../core/widgets/d_appbar.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../generated/assets.gen.dart';
import '../../domain/entities/alerts.dart';
import '../cubit/alerts/alerts_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: DAppBar(
          title: tr('notifiCations'),
          titleStyle: Theme.of(context).textTheme.caption2,
          centerTitle: false,
          onTap: () => navService.goBack(),
        ),
        body: BlocBuilder<AlertsCubit, AlertsState>(
          builder: (context, state) {
            if (state.dataStatus == DataStatus.initial) {
              return const SizedBox();
            } else if (state.dataStatus == DataStatus.loading) {
              return const LoadingWidget();
            } else if (state.dataStatus == DataStatus.loaded) {
              List<Alerts> listOfAlert =  state.alerts ??[];
              return SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Column(
                        children: [
                          ...List.generate(
                           listOfAlert.length,
                            (index) => GestureDetector(
                              onTap: () =>  navService.pushNamed(AppRoute.detailRoute,args: listOfAlert[index].payloadEntity.linkEntity),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  index == 0
                                      ? const SizedBox.shrink()
                                      : const Divider(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Assets.images.folder.image(
                                        scale: .2,
                                        width: 50,
                                        height: 50,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 74.w,
                                            child: Text(
                                             listOfAlert[index].messageEntity.notificationEntity.bodyEnitity,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                         Text(
                                              timeago.format(
                                                  listOfAlert[index]
                                                      .createdAtEntity,
                                                  locale: 'en_short'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .customText6),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                      ),
                ),
              );
            } else if (state.dataStatus == DataStatus.error) {
              return Center(
                child: Text(
                  "ERROR",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
