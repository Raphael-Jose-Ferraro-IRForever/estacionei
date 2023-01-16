import 'package:estacionei/components/base_box_widget.dart';
import 'package:estacionei/utils/colors_util.dart';
import 'package:flutter/material.dart';

class SelectBoxWidget extends StatefulWidget {
  final Color color;
  final String text;
  final double width;
  final double height;
  bool selected;
  final Function(bool) onChanged;

  SelectBoxWidget(
      {required this.color,
      required this.text,
      required this.width,
      required this.height,
      required this.onChanged,
      required this.selected,
      Key? key})
      : super(key: key);

  @override
  State<SelectBoxWidget> createState() => _SelectBoxWidgetState();
}

class _SelectBoxWidgetState extends State<SelectBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.selected = !widget.selected;
        });
        widget.onChanged(widget.selected);
      },
      child: BaseBoxWidget(
        width: widget.width,
        height: widget.height,
        color: widget.selected ? widget.color : ColorsUtil.cinzaClaro,
        child: Center(
          child: Text(widget.text,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: widget.selected ? Colors.white : widget.color)),
        ),
      ),
    );
  }
}
