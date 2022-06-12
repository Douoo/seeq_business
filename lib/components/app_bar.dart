import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ElevatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? showBackButton;
  const ElevatedAppBar({
    Key? key,
    required this.title,
    this.showBackButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton ?? true,
      title: Text(
        title,
      ),
      // centerTitle: true,
      backgroundColor: kBlackColor,
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
