library globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/components/layout/loader.dart';

bool isNullOrEmpty(dynamic val) {
  return val == null ||
      val == '' ||
      val == 0 ||
      val == false ||
      val == [] ||
      false;
}

bool setSafe(
  void Function(void Function()) setState,
  void Function() fn,
) {
  try {
    setState(fn);
    return true;
  } catch (e) {
    // prevent error if use left before state changed
    print('===== STATE ERROR =====');
    print(e);
    return false;
  }
}

Future<T?> pushPage<T>(BuildContext context, Widget page) {
  return Navigator.of(context)
      .push<T>(CupertinoPageRoute(builder: (BuildContext context) {
    return page;
  }));
}

void showLoader(BuildContext context) => showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      context: context,
      builder: (BuildContext context) {
        return const Loader(null, color: Colors.white);
      },
    );
