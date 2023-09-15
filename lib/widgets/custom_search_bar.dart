import 'package:flutter/material.dart';

class KCustomButton extends StatelessWidget {
  final Widget widget;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final double? radius;

  const KCustomButton(
      {Key? key,
      required this.widget,
      required this.onPressed,
      this.radius,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 50),
        child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius ?? 50),
            child: InkWell(
                splashColor: Theme.of(context).primaryColor.withOpacity(.2),
                highlightColor: Theme.of(context).primaryColor.withOpacity(.05),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: widget),
                onTap: onPressed,
                onLongPress: onLongPress)));
  }
}