import 'package:d_box/core/config/themes/app_text_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/data_status.dart';
import '../../../../core/widgets/d_appbar.dart';
import '../cubit/alerts/alerts_cubit.dart';
import '../widgets/notifications_list_view.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertsCubit, AlertsState>(
      builder: (context, state) {
        if (state.dataStatus == DataStatus.initial) {
          return const SizedBox();
        } else if (state.dataStatus == DataStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.dataStatus == DataStatus.loaded) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: DAppBar(
              title: tr('notifiCations'),
              titleStyle: Theme.of(context).textTheme.caption2,
              centerTitle: false,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: NotificationListView(alerts: state.alerts),
                ),
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
    );
  }
}
