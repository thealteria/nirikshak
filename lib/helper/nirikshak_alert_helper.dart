import 'package:flutter/material.dart';

class NirikshakAlertHelper {
  const NirikshakAlertHelper._();

  ///Helper method used to open alarm with given title and description.
  static void showAlert(
    BuildContext context,
    String title,
    String description, {
    String firstButtonTitle = "Accept",
    String? secondButtonTitle,
    Function? firstButtonAction,
    Function? secondButtonAction,
  }) {
    List<Widget> actions = [];
    actions.add(
      TextButton(
        child: Text(firstButtonTitle),
        onPressed: () {
          if (firstButtonAction != null) {
            firstButtonAction();
          }
          Navigator.of(context).pop();
        },
      ),
    );
    if (secondButtonTitle != null) {
      actions.add(
        TextButton(
          child: Text(secondButtonTitle),
          onPressed: () {
            if (secondButtonAction != null) {
              secondButtonAction();
            }
            Navigator.of(context).pop();
          },
        ),
      );
    }
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: actions,
        );
      },
    );
  }
}
