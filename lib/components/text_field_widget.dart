import 'package:estacionei/components/base_box_widget.dart';
import 'package:estacionei/utils/colors_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {

  final TextEditingController? controller;
  final String hintText;
  final double width;
  final double? height;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatter;

  const TextFieldWidget({Key? key, this.height, this.validator, this.textCapitalization = TextCapitalization.none, this.onSubmitted, this.inputFormatter,required this.width, this.controller, this.hintText = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBoxWidget(
      height: height ?? 46,
        width: width,
        color: ColorsUtil.cinzaClaro,
        child: TextFormField(
          autofocus: false,
          controller: controller,
          textAlign: TextAlign.center,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatter,
          decoration: InputDecoration(
            counterStyle: const TextStyle(fontSize: 0),
            hintText: hintText,
            border: InputBorder.none,
            hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
          ),
        ));
  }
}
