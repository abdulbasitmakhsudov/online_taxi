import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

FloatingActionButton primaryFloatingActionButton(
    {required VoidCallback onPressed,
    required BuildContext context,
    Widget? child}) {
  return FloatingActionButton(
    onPressed: () async {
      onPressed.call();
    },
    shape: const CircleBorder(),
    backgroundColor: Theme.of(context).primaryColor,
    child: child ??
        const Icon(
          Icons.add,
          color: AppColors.white,
        ),
  );
}
