
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KBackButton extends StatelessWidget {
  final Widget? previousScreen;
  final Color? iconColor;
  final IconData? icon;
  const KBackButton(
      {Key? key,
      required this.previousScreen,
      required this.iconColor,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
                splashColor: Theme.of(context).primaryColor.withOpacity(.2),
                highlightColor: Theme.of(context).primaryColor.withOpacity(.05),
                onTap: () async {
                  previousScreen == null
                      ? Navigator.pop(context)
                      : Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => previousScreen!));
                },
                child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(icon ?? Icons.arrow_back_ios_new,
                            color: iconColor ?? Colors.black.withOpacity(.7),
                            size: 25))))));
  }
}
