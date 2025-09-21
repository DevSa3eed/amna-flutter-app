// ignore_for_file: file_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';
import '../../../core/config/config.dart';

//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'This field mustn`t be empty';
//         }
//         return null; // Input is valid
//       },
//
class CountryKey extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  final TextInputType type;
  bool? disabled = true;
  Function? fun;
  // ignore: use_super_parameters
  CountryKey({
    required this.controller,
    required this.label,
    required this.type,
    this.disabled,
    this.fun,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CountryKeyState createState() => _CountryKeyState();
}

class _CountryKeyState extends State<CountryKey> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75.w,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return config.localization['empty'];
            }
            return null; // Input is valid
          },
          controller: widget.controller,
          keyboardType: widget.type,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: BorderSide(
                color: Colours.LightBlue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: BorderSide(
                color: Colours.LightBlue,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: BorderSide(
                color: Colours.LightBlue,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: BorderSide(
                color: Colours.LightBlue,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: BorderSide(
                color: Colours.LightBlue,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: BorderSide(
                color: Colours.LightBlue,
              ),
            ),
            label: Text(
              widget.label,
              style: TextStyle(
                color: Colours.LightBlue,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            hintText: '${widget.label}..',
            hintStyle: TextStyle(
              color: Colours.LightBlue,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            enabled: widget.disabled ?? true,
          ),
          cursorColor: Colours.LightBlue,
          style: TextStyle(
            // color: Colors.white,
            color: Colours.LightBlue,
            fontSize: 14.sp,
          ),
          onTap: () {
            widget.fun!();
          },
        ),
      ),
    );
  }
}
