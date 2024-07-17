import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/my_color.dart';
import '../core/style.dart';



class RoundedButton extends StatefulWidget {
  final bool isColorChange;
  final String text;
  final VoidCallback press;
  final Color color;
  final Color? textColor;
  final double width;
  final double horizontalPadding;
  final double verticalPadding;
  final double cornerRadius;
  final double textSize;
  final bool isOutlined;
  final Widget? child;

  const RoundedButton({
    super.key,
    this.isColorChange = false,
    this.width = 1,
    this.child,
    this.cornerRadius = 10,
    this.textSize = 14,
    required this.text,
    required this.press,
    this.isOutlined = false,
    this.horizontalPadding = 35,
    this.verticalPadding = 18,
    this.color = MyColor.primaryColor,
    this.textColor = MyColor.colorWhite,
  });

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.isOutlined
            ? Material(
                child: InkWell(
                  onTap: widget.press,
                  splashColor: MyColor.getScreenBgColor(),
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.horizontalPadding,
                          vertical: widget.verticalPadding),
                      width: size.width * widget.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: widget.isColorChange
                              ? widget.color
                              : MyColor.getPrimaryButtonColor()),
                      child: Center(
                          child: Text(widget.text,
                              style: GoogleFonts.poppins(
                                textStyle: boldExtraLarge.copyWith(
                                    color: widget.isColorChange
                                        ? widget.textColor
                                        : MyColor.getPrimaryButtonTextColor(),
                                    fontSize: widget.textSize,
                                    fontWeight: FontWeight.w500),
                              )


                            /*style: TextStyle(
                                  color: widget.isColorChange
                                      ? widget.textColor
                                      : MyColor.getPrimaryButtonTextColor(),
                                  fontSize: widget.textSize,
                                  fontWeight: FontWeight.w500)*/))),
                ),
              )
            : InkWell(
              onTap: widget.press,
              splashColor: MyColor.getScreenBgColor(),
              child: Container(
                  width: size.width * widget.width,
                  padding: EdgeInsets.symmetric(vertical: widget.verticalPadding, horizontal: widget.horizontalPadding),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.cornerRadius), color: widget.color),
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.text,
                    style: GoogleFonts.poppins(textStyle : semiBoldDefault.copyWith(color: widget.textColor, fontSize: widget.textSize, fontWeight: FontWeight.w500)),
                  ),
                ),
            );
  }
}
