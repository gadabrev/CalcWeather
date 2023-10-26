import 'package:flutter/material.dart';
import 'package:test_project/core/globals.dart';

class Alert {
  static BuildContext? context;
  static List readyStack = [];
  static ready(_context) {
    context = _context;
    readyStack.reversed.forEach((f) {
      f();
    });
    readyStack = [];
  }

  static warning({
    String title = 'Warning',
    String? text,
    Function()? accept,
    Function()? cancel,
  }) {
    Alert.alert_(
      title: title,
      text: text,
      accept: accept,
      cancel: cancel,
      acceptLabel: 'Ok',
      cancelLabel: 'Cancel',
      dismissable: false,
    );
  }

  static errorAgain({
    String title = 'Error',
    String? text,
    Function()? accept,
  }) {
    Alert.alert_(
      title: title,
      text: text,
      accept: accept,
      acceptLabel: 'Try again',
      dismissable: false,
    );
  }

  static errorTryAgain({
    String title = 'Error',
    String? text,
    Function()? accept,
    Function()? cancel,
  }) {
    Alert.alert_(
      title: title,
      text: text,
      accept: accept,
      cancel: cancel,
      acceptLabel: 'Try again',
      cancelLabel: 'Cancel',
      dismissable: false,
    );
  }

  static show({
    required Widget child,
    double radiusBorder = 5,
    bool dismissable = true,
  }) {
    showDialog(
      barrierColor: Colors.black.withOpacity(.25),
      barrierDismissible: dismissable,
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusBorder),
          ),
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          content: child,
        );
      },
    );
  }

  static alert_({
    String? title,
    String? text,
    Function()? accept,
    String? acceptLabel,
    Function()? cancel,
    String? cancelLabel,
    bool dismissable = true,
  }) async {
    if (isNullOrEmpty(context)) {
      readyStack.add(() => Alert.alert_(
            title: title,
            text: text,
            cancel: cancel,
            accept: accept,
          ));
      return;
    }

    showDialog(
      barrierDismissible: dismissable,
      context: context!,
      builder: (BuildContext context) {
        Widget cancelButton = TextButton(
          child: Text(
            cancelLabel ?? "Cancel",
            style: TextStyle(
              color: Color.fromARGB(255, 114, 1, 44),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (!isNullOrEmpty(cancel)) cancel!();
          },
        );

        Widget acceptButton = TextButton(
          child: Text(
            acceptLabel ?? "Ok",
            style: TextStyle(
              color: Color.fromARGB(255, 114, 1, 44),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (!isNullOrEmpty(accept)) accept!();
          },
        );

        return AlertDialog(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          title: Text(title ?? '<Alert>'),
          content: Text(text ?? '<No Description>'),
          actions: [
            if (cancelLabel != null) cancelButton,
            acceptButton,
          ],
        );
      },
    );
  }
}
