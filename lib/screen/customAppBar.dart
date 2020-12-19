import 'package:covid_dashboard/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      leading: IconButton(icon: Icon(Icons.menu),iconSize: 28.0, onPressed: () {  },),
      actions: [
        IconButton(icon: Icon(Icons.notifications_none),iconSize: 28.0, onPressed: () {  },),
      ],
);

  }

  @override
  Size get preferredSize =>Size.fromHeight(kToolbarHeight);
}
