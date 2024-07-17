import 'package:flutter/material.dart';
import '../../core/dimensions.dart';
import '../../core/my_color.dart';

class CustomDivider extends StatelessWidget {
  final double space;
  final Color color;
  final bool hascolor;

  const CustomDivider(
      {Key? key,
      this.space = Dimensions.space20,
      this.color = MyColor.colorBlack, this.hascolor =false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: space),
        Divider(color:
        hascolor ==true?
         color.withOpacity(0.2):color.withOpacity(0), height: 0.5, thickness: 0.5),
        SizedBox(height: space),
      ],
    );
  }
}
