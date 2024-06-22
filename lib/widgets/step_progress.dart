// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';

class StepProgress extends StatefulWidget {
  final double currenstStep;
  final double steps;

  const StepProgress(
      {Key? key, required this.currenstStep, required this.steps})
      : super(key: key);

  @override
  State<StepProgress> createState() => _StepProgressState();
}

class _StepProgressState extends State<StepProgress> {
  double _stepWidth = 0;

  @override
  void initState() {
    _onSizeWidget();
    super.initState();
  }

  void _onSizeWidget() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.size is Size) {
        Size size = context.size!;
        _stepWidth = (size.width - 32) / (widget.steps - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextWidget(
                text:
                    'Paso ${(widget.currenstStep + 1).toInt()} / ${widget.steps.toInt()}',
                type: TextType.Subtitle,
                fontSize: 18,
                color: ColorType.Secondary,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Stack(
              children: [
                AnimatedContainer(
                  width: widget.currenstStep * _stepWidth,
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: Color(0xFF016171),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}
