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
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/alerts.dart';
import '../cubit/alerts/alerts_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../widgets/error_view.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DAppBar(
        title: LocaleKeys.notifiCations.tr(),
        titleStyle: Theme.of(context).textTheme.caption2,
        centerTitle: false,
        onTap: () => navService.goBack(),
      ),
      body: BlocConsumer<AlertsCubit, AlertsState>(
        listener: (context, state) async {
          if (state.errorMessage != null) {
            await context.read<AlertsCubit>().onDismissErorr();
          }
        },
        builder: (context, state) {
          if (state.dataStatus == DataStatus.loading) {
            return const LoadingWidget();
          } else {
            List<Alerts> listOfAlert = state.alerts ?? [];
            return SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Column(
                    children: [
                      ...List.generate(
                        listOfAlert.length,
                        (index) => GestureDetector(
                          onTap: () => navService.pushNamed(
                              AppRoute.detailRoute,
                              args:
                                  listOfAlert[index].payloadEntity.linkEntity),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              index == 0
                                  ? const SizedBox.shrink()
                                  : const Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        width: 70.w,
                                        child: Text(
                                          listOfAlert[index]
                                              .messageEntity
                                              .notificationEntity
                                              .bodyEnitity,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis),
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
                  )),
            );
          }
        },
      ),
      bottomNavigationBar: BlocSelector<AlertsCubit, AlertsState, String?>(
        selector: (state) {
          return state.errorMessage;
        },
        builder: (context, errorMessage) {
          return ErrorView(
            errorMessage: errorMessage,
          );
        },
      ),
    );
  }
}
