import 'package:flutter/material.dart';
import 'package:weight_tracker/ui/widgets/primary_circular_progress.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    this.color,
    this.label,
    this.labelStyle,
    this.onPressed,
    this.loading = false,
    this.textColor,
    this.tag,
    this.skipHero,
    this.elevation,
  });

  String label;
  TextStyle labelStyle;
  Function onPressed;
  bool loading;
  String tag;
  Color color;
  final Color textColor;
  bool skipHero;
  double elevation;

  @override
  Widget build(BuildContext context) {
    final onSecondary = Theme.of(context).colorScheme.onSecondary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final buttonStyle = Theme.of(context).textTheme.button;

    return _hero(
      skip: skipHero ?? false,
      tag: tag ?? DateTime.now().toString(),
      child: RaisedButton(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        onPressed: onPressed,
        child: loading
            ? PrimaryCircularProgress()
            : Text(
                "$label",
                overflow: TextOverflow.ellipsis,
                style: labelStyle ??
                    buttonStyle.copyWith(
                      color: textColor ?? onSecondary,
                    ),
              ),
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }

  //Will remove hero from the widget tree if skip is true.
  //this is useful when using another conflicting hero tag
  Widget _hero({bool skip, String tag, Widget child}) {
    if (skip) return child;
    return Hero(
      tag: tag,
      child: child,
    );
  }
}
