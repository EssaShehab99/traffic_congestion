import 'package:flutter/material.dart';
import '/views/shared/shared_values.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget(
      {Key? key,
      this.onPressed,
      this.minWidth,
      this.height,
      this.child,
      this.color,
      this.elevation,
      this.isCircle})
      : super(key: key);
  final Function()? onPressed;
  final double? minWidth;
  final double? height;
  final Widget? child;
  final bool? isCircle;
  final Color? color;
  final double? elevation;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        isLoading = true;
        if (mounted) setState(() {});
        if (widget.onPressed != null) {
          await widget.onPressed!();
        }
        isLoading = false;
        if (mounted) setState(() {});
      },
      height: widget.height ?? 45,
      padding: EdgeInsets.zero,
      minWidth: widget.minWidth,
      elevation: widget.elevation,
      color: widget.color??Theme.of(context).primaryColor ,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.isCircle==true?100:SharedValues.borderRadius),
          borderSide: BorderSide.none
      ),
      child: Builder(builder: (context) {
        if (isLoading) {
          return CircularProgressIndicator(
              color: Theme.of(context).colorScheme.background);
        }
        return widget.child ?? const SizedBox.shrink();
      }),
    );
  }
}
