
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'core/config/routes/router.dart';
import 'generated/locale_keys.g.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.rootTitle.tr()),
      ),
      body: ListView(children: [
        Card(
          elevation: 5,
          child: ListTile(
            onTap: () {
              navService.pushNamed(AppRoute.todosRoute);
            },
            title: Text(LocaleKeys.jsonPlaceHolder.tr()),
          ),
        )
      ]),
    );
  }
}
