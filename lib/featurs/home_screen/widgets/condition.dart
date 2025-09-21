import 'package:dr_sami/core/constant_widgets/circle_progress.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget ConditionBuilder({
  required bool condition,
  // required Widget ifTrue,
  required Widget ifFalse,
}) {
  return condition ? customLoader() : ifFalse;
}
