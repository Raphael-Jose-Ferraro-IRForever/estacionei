import 'package:estacionei/utils/colors_util.dart';
import 'package:flutter/material.dart';

class DialogUtil {
  static showAlertSimNao(
      {required BuildContext context,
      required Widget content,
      required String title,
      required String confirm,
      required VoidCallback simListener}) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        var width = MediaQuery.of(context).size.width;
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          content: Container(
            width: width * .9,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: content,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 16),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsUtil.vermelho,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              child: const Text('CANCELAR',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsUtil.verde,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              child: Text(confirm,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                simListener();
              },
            ),
          ],
        );
      },
    );
  }
}
