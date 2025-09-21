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
class CustomTextFeild extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  String? hint;
  final bool isPassword;
  final IconData iconPre;
  final TextInputType type;
  bool? disabled = true;
  Function? fun;
  // ignore: use_super_parameters
  CustomTextFeild({
    required this.controller,
    required this.label,
    required this.isPassword,
    required this.iconPre,
    required this.type,
    this.hint,
    this.disabled,
    this.fun,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFeildState createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return config.localization['empty'];
          }
          return null; // Input is valid
        },
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscure : false,
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
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          hintText: widget.hint ?? '${widget.label}..',
          hintStyle: TextStyle(
            color: Colours.LightBlue,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Icon(
            widget.iconPre,
            color: Colours.LightBlue,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colours.LightBlue,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
              : null,
          enabled: widget.disabled ?? true,
        ),
        cursorColor: Colours.LightBlue,
        style: TextStyle(
          // color: Colors.white,
          color: Colours.LightBlue,
          fontSize: 20.sp,
        ),
        onTap: () {
          widget.fun!();
        },
      ),
    );
  }
}
