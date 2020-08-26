import 'package:flutter/material.dart';

class PrimaryAppBar extends PreferredSize {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  PrimaryAppBar({
    this.elevation,
    this.title,
    this.centerTitle,
    this.backgroundColor,
    this.actions,
    this.iconTheme,
    this.implyLeading,
    this.leading,
  });

  double elevation;
  String title;
  bool centerTitle;
  Color backgroundColor;
  List<Widget> actions;
  IconThemeData iconTheme;
  bool implyLeading;
  Widget leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation ?? 0,
      title: Text(
        title != null ? "${title}" : "",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: centerTitle ?? true,
      backgroundColor: backgroundColor ?? Colors.transparent,
      actions: actions,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      automaticallyImplyLeading: implyLeading ?? true,
      leading: leading,
    );
  }
}
