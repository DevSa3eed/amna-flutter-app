import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String content}) {
  Fluttertoast.showToast(
    msg: content,
    toastLength: Toast.LENGTH_SHORT, // Duration of the toast
    gravity: ToastGravity.BOTTOM, // Position of the toast
    backgroundColor: Colours.LightBlue, // Background color of the toast
    textColor: Colours.White, // Text color of the toast
    fontSize: 16.0, // Font size of the message
  );
}
