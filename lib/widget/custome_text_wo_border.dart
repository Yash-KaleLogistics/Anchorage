import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/my_color.dart';
import '../core/style.dart';

class CustomeTextWOBorder extends StatefulWidget {

  final String? labelText;
  final IconData? prefixicon;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isIcon;
  final VoidCallback? onSuffixTap;
  final bool isSearch;
  final bool isCountryPicker;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool readOnly;
  final bool needRequiredSign;
  final int maxLines;
  final bool animatedLabel;
  final Color fillColor;
  final Color fontColor;
  final bool isRequired;
  final bool hasIcon;
  final bool hastextcolor;
  final double fontSize;
  final bool showErrorText;
  final VoidCallback? onPress;
  final double circularCorner;
  final double verticalPadding;
  final Color? prefixIconcolor;
  final Color? hintTextcolor;
  final Color? cursorColor;

  const CustomeTextWOBorder({super.key,
    this.labelText,
    this.readOnly = false,
    this.fillColor = MyColor.transparentColor,
    this.fontColor = MyColor.colorWhite,
    required this.onChanged,
    this.hintText,
    this.prefixicon,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.isShowSuffixIcon = false,
    this.isIcon = false,
    this.onSuffixTap,
    this.fontSize = 10,
    this.isSearch = false,
    this.isCountryPicker = false,
    this.inputAction = TextInputAction.next,
    this.needOutlineBorder = false,
    this.needRequiredSign = false,
    this.maxLines = 1,
    this.animatedLabel = false,
    this.isRequired = false,
    this.hasIcon = false,
    this.hastextcolor = false,
    this.showErrorText = true,
    this.onPress,
    this.circularCorner = 30,
    this.verticalPadding = 20,
    this.prefixIconcolor,
    this.cursorColor = Colors.white,
  this.hintTextcolor});

  @override
  State<CustomeTextWOBorder> createState() => _CustomeTextWOBorderState();
}

class _CustomeTextWOBorderState extends State<CustomeTextWOBorder> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:  widget.fillColor,
          borderRadius: BorderRadius.circular(widget.circularCorner)
      ),
      child: TextFormField(
       onTap: () {
         widget.onPress!();
       },
        readOnly: widget.readOnly,
        cursorColor: widget.cursorColor,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        obscureText: widget.isPassword ? obscureText : false,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(color: widget.fontColor, fontWeight: FontWeight.w400),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: widget.verticalPadding, horizontal: 20),
          prefixIcon: widget.hasIcon ? Icon(widget.prefixicon, color: widget.prefixIconcolor,) : null,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(textStyle : mediumDefault.copyWith(fontSize: widget.fontSize, color: widget.hintTextcolor, fontWeight: FontWeight.w400)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          suffixIcon: widget.isShowSuffixIcon
              ? widget.isPassword
              ? IconButton(
              icon: Icon(
                  obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: widget.prefixIconcolor,
                  size: 20),
              onPressed: _toggle)
              : widget.isIcon
              ? IconButton(
            onPressed: widget.onSuffixTap,
            icon: Icon(
              widget.isSearch
                  ? Icons.search_outlined
                  : widget.isCountryPicker
                  ? Icons.arrow_drop_down_outlined
                  : Icons.camera_alt_outlined,
              size: 25,
              color: MyColor.getPrimaryColor(),
            ),
          )
              : null
              : null,
        ),
        onFieldSubmitted: (text) => widget.nextFocus != null
            ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : null,
        onChanged: (text) => widget.onChanged!(text),
        textInputAction: widget.inputAction,
      ),
    );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
